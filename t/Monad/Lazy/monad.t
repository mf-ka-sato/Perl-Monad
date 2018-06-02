use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Lazy;
use MonadRule;

sub compare_convert { shift->value }

MonadRule::monad_rule('Monad::Lazy', \&compare_convert);

done_testing;
