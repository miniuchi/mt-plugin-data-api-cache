package MT::DataAPIPMCache;
use strict;
use warnings;

use MT;
use MT::PMCache::File;

our ( $INSTANCE, $PURGE_OBJS );

sub purge_all_cache {
    my ( $eh, $obj ) = @_;

    $PURGE_OBJS ||= +{
        map { $_ => 1 } split ',',
        MT->config->DataAPIPMCacheFilePurgeObjects
    };
    my $class = ref $obj;
    return 1 unless $PURGE_OBJS->{$class};

    get_cache_instance()->flush_all;

    1;
}

sub get_cache_instance {
    $INSTANCE ||= MT::PMCache::File->new(
        {   dir     => MT->config->DataAPIPMCacheFileDir,
            expires => MT->config->DataAPIPMCacheFileExpires,
        }
    );
}

sub is_cacheable {
    my ($env) = @_;
    get_cache_instance()->is_cacheable($env);
}

1;

