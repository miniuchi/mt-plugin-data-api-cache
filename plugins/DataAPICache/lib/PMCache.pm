package PMCache;
use strict;
use warnings;

sub new { bless {}, shift }

sub get {
    my $self = shift;
    my ($env) = @_;
    return;
}

sub set {
    my $self = shift;
    my ( $env, $response ) = @_;
}

sub is_cacheable {
    my $self = shift;
    my ( $env, $response ) = @_;
    return;
}

sub flush_all {
    my $self = shift;
}

1;

