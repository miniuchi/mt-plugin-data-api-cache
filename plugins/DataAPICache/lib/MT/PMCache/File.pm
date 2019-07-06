package MT::PMCache::File;
use strict;
use warnings;
use utf8;
use parent 'PMCache';

use Digest::MD5;
use File::Path;
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
    $self->{dir}  = $args->{dir};
    $self->{fmgr} = MT::FileMgr->new('Local');
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
    my $file        = Digest::MD5::md5_hex($request_uri);
    return File::Spec->catfile( $self->{dir}, "$file.json" );
}

sub flush_all {
    my $self = shift;
    File::Path::rmtree( $self->{dir} );
}

sub is_cacheable {
    my $self = shift;
    my ( $env, $response ) = @_;
    !exists $env->{HTTP_X_MT_AUTHORIZATION}
        && $env->{REQUEST_METHOD} eq 'GET'
        && ( !$response || $response->[0] == 200 );
}

1;

