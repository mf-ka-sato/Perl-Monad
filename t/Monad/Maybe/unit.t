use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Maybe;

subtest 'basic' => sub {
    my $maybe = Monad::Maybe->unit(100);

    is $maybe->{_value}, 100;
};

done_testing;
