use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Maybe;

subtest 'exists value' => sub {
    my $maybe = Monad::Maybe->unit(100);
    my $mapped = $maybe->map(sub { $_[0] + 11 });

    is $mapped->{_value}, 111;
    is $maybe->{_value}, 100;
};

subtest 'not exists value' => sub {
    my $maybe = Monad::Maybe->nothing;
    my $mapped = $maybe->map(sub { $_[0] + 100 });

    is_deeply ($mapped, Monad::Maybe->nothing);
};

subtest 'chain exists value' => sub {
    my $maybe = Monad::Maybe->unit(100);
    my $mapped = 
        $maybe
            ->map(sub { $_[0] + 10 })
            ->map(sub { $_[0] / 10 })
            ->map(sub { $_[0] *  3 });

    is $mapped->{_value}, 33;
};

subtest 'chain not exists value' => sub {
    my $maybe = Monad::Maybe->nothing;
    my $mapped =
        $maybe
            ->map(sub { $_[0] + 30 })
            ->map(sub { $_[0] * 10000 });

    ok $mapped->is_nothing;
};

subtest 'not execute function if not exists value' => sub {
    my $called = 0;
    my $maybe = Monad::Maybe->nothing;
    my $mapped = 
        $maybe
            ->map(sub { $called++ })
            ->map(sub { $called++ });

    is $called, 0;
};

done_testing;
