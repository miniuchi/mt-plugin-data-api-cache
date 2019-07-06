package Plack::Middleware::PMCache;
use strict;
use warnings;
use parent 'Plack::Middleware';

use Plack::Util::Accessor qw( cache );

sub call {
    my ( $self, $env ) = @_;

    unless ( $self->cache->is_cacheable($env) ) {
        return $self->app->($env);
    }

    if ( my $cache_response = $self->cache->get($env) ) {
        return $cache_response;
    }

    my $response = $self->app->($env);

    if ( $self->cache->is_cacheable( $env, $response ) ) {
        $self->cache->set( $env, $response );
    }

    return $response;
}

1;

