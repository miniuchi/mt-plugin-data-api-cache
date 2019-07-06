use strict;
use warnings;

use Test::More;

use lib './lib', './extlib', './plugins/DataAPICache/lib';

use_ok('MT::DataAPICache');
use_ok('MT::PMCache::File');
use_ok('PMCache');
use_ok('Plack::Middleware::PMCache');

done_testing;

