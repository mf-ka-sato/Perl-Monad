use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Maybe;

ok not exists Monad::Maybe->nothing->{_value}; 
is_deeply(Monad::Maybe->nothing, Monad::Maybe->nothing);

done_testing;
