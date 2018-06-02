use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Maybe qw/to_maybe/;

subtest 'no error' => sub {
    my $maybe = to_maybe { 
        100 / 20;
    };

    ok not $maybe->is_nothing;
    is $maybe->{_value}, 5;
};

subtest 'error' => sub {
    my $maybe = to_maybe {
        100 / 0;
    };

    ok $maybe->is_nothing;
};

done_testing;
