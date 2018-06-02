use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Maybe;
use MonadRule;

sub compare_convert { shift->value_or("nothing") }

MonadRule::monad_rule('Monad::Maybe', \&compare_convert);

done_testing;
