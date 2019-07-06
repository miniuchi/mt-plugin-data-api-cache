package MT::PMCache::File;
use strict;
use warnings;
use utf8;
use parent 'PMCache';

use Digest::MD5;
use File::Spec;
use JSON ();

use MT::FileMgr;

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->_init(@_);
    $self;
}

sub _init {
    my $self = shift;
    my ($args) = @_;
    $self->{auth}    = $args->{auth};
    $self->{dir}     = $args->{dir};
    $self->{expires} = $args->{expires};
    $self->{fmgr}    = MT::FileMgr->new('Local');
}

sub _mkdir_if_needed {
    my $self = shift;
    return if -d $self->{dir};
    my $created = $self->{fmgr}->mkpath( $self->{dir} );
    unless ($created) {
        die 'Failed to create directory: ' . $self->{fmgr}->errstr;
    }
}

sub get {
    my $self     = shift;
    my ($env)    = @_;
    my $filename = $self->_get_filename($env);
    return unless -f $filename;
    return if $self->_purge_if_expired($filename);
    my $json     = $self->{fmgr}->get_data($filename);
    my $response = eval { JSON::decode_json($json) };
    warn 'Failed to parse JSON while get: ' . $@ if $@;
    $response;
}

sub set {
    my $self = shift;
    my ( $env, $response ) = @_;
    $self->_mkdir_if_needed;
    my $filename = $self->_get_filename($env);
    my $json     = JSON::encode_json($response);
    my $set      = $self->{fmgr}->put_data( $json, $filename );
    die 'Failed to set: ' . $self->{fmgr}->errstr unless $set;
}

sub _get_filename {
    my $self        = shift;
    my ($env)       = @_;
    my $request_uri = $env->{REQUEST_URI};
    my $token       = $self->_get_token($env);
    my $file
        = Digest::MD5::md5_hex( ( $token ? "$token:" : '' ) . $request_uri );
    return File::Spec->catfile( $self->{dir}, "$file.json" );
}

sub _get_token {
    my $self = shift;
    my ($env) = @_;
    return unless $self->{auth};
    my $auth_header = $env->{HTTP_X_MT_AUTHORIZATION} || '';
    my ($token) = $auth_header =~ /^MTAuth accessToken=(.+)$/;
    $token;
}

sub _purge_if_expired {
    my $self = shift;
    my ($filename) = @_;
    return unless $self->{expires};
    return
        unless time - $self->{fmgr}->file_mod_time($filename)
        > $self->{expires};
    my $deleted = $self->{fmgr}->delete($filename);
    die $self->{fmgr}->errstr unless $deleted;
    1;
}

sub flush_all {
    my $self  = shift;
    my @files = glob File::Spec->catdir( $self->{dir}, '*' );
    for my $f (@files) {
        my $deleted = $self->{fmgr}->delete($f);
        warn $self->{fmgr}->errstr unless $deleted;
    }
}

sub is_cacheable {
    my $self = shift;
    my ( $env, $response ) = @_;
    if ( $self->{auth} && $self->_is_token_revoked( $env, $response ) ) {
        $self->flush_all;
        return;
    }
    ( $self->{auth} || !$env->{HTTP_X_MT_AUTHORIZATION} )
        && $env->{REQUEST_METHOD} eq 'GET'
        && ( !$response || $response->[0] == 200 );
}

sub _is_token_revoked {
    my $self = shift;
    my ( $env, $response ) = @_;
           $env->{REQUEST_URI} =~ m!^/v\d+/(?:authentication|revoke)!
        && $env->{REQUEST_METHOD} eq 'DELETE'
        && $response
        && $response->[0] == 200;
}

1;

