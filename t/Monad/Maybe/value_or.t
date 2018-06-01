use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Maybe;

subtest 'exists value' => sub {
    my $maybe = Monad::Maybe->unit(100);

    is $maybe->value_or(200), 100;
};

subtest 'exists value with value generator' => sub {
    my $maybe = Monad::Maybe->unit(100);
    my $called = 0;

    is $maybe->value_or(sub { $called++; 500 }), 100;
    is $called, 0;
};

subtest 'not exists value' => sub {
    my $maybe = Monad::Maybe->nothing;

    is $maybe->value_or(300), 300;
};

subtest 'not exists value with value generator' => sub {
    my $maybe = Monad::Maybe->nothing;

    is $maybe->value_or(sub { 500 }), 500;
};

done_testing;
