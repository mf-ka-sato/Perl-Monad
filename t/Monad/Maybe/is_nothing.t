use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Maybe;

ok (Monad::Maybe->nothing->is_nothing);
ok (not Monad::Maybe->unit(100)->is_nothing);
ok (not Monad::Maybe->just(100)->is_nothing);

done_testing;
