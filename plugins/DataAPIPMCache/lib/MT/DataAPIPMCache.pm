package MT::DataAPIPMCache;
use strict;
use warnings;

use MT;
use MT::PMCache::File;

our ( $INSTANCE, $PURGE_OBJS_HASH );

sub purge_all_cache {
    my ( $eh, $obj ) = @_;
    if ( _get_purge_objs_hash()->{ ref $obj } ) {
        get_cache_instance()->flush_all;
    }
    1;
}

sub _get_purge_objs_hash {
    unless ($PURGE_OBJS_HASH) {
        my @objs = split ',', MT->config->DataAPIPMCacheFilePurgeObjs;
        if ( MT->config->DataAPIPMCacheFileAuth ) {
            push @objs,
                ( split ',', MT->config->DataAPIPMCacheFileAuthPurgeObjs );
        }
        $PURGE_OBJS_HASH = +{ map { $_ => 1 } @objs };
    }
    $PURGE_OBJS_HASH;
}

sub get_cache_instance {
    $INSTANCE ||= MT::PMCache::File->new(
        {   auth    => MT->config->DataAPIPMCacheFileAuth,
            dir     => MT->config->DataAPIPMCacheFileDir,
            expires => MT->config->DataAPIPMCacheFileExpires,
        }
    );
}

sub is_cacheable {
    my ($env) = @_;
    get_cache_instance()->is_cacheable($env);
}

1;

