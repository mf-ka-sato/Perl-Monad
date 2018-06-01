use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Maybe;

subtest 'exists value' => sub {
    my $maybe = Monad::Maybe->unit(100);
    my $f = sub { my $x = shift; Monad::Maybe->unit($x + 100) };

    my $flatmapped = $maybe->flatmap($f);

    is $flatmapped->{_value}, 200;
    is $maybe->{_value}, 100;
};

subtest 'not exists value' => sub {
    my $maybe = Monad::Maybe->nothing;
    my $f = sub { my $x = shift; Monad::Maybe->unit($x * 100) };

    my $flatmapped = $maybe->flatmap($f);

    ok $flatmapped->is_nothing;
};


subtest 'chain' => sub {
    my $maybe = Monad::Maybe->unit(100);
    my $flatmapped =
        $maybe
            ->flatmap(sub { my $x = shift; Monad::Maybe->unit($x + 100) })
            ->flatmap(sub { my $x = shift; Monad::Maybe->unit($x /  20) });

    is $flatmapped->{_value}, 10;
};

subtest 'not execute function if not exists value' => sub {
    my $called = 0;
    my $maybe = Monad::Maybe->nothing;
    my $flatmapped =
        $maybe
            ->flatmap(sub { my $x = shift; $called++; Monad::Maybe->unit($x + 100) })
            ->flatmap(sub { my $x = shift; $called++; Monad::maybe->unit($x *   2) });

    is $called, 0;
    ok $flatmapped->is_nothing;
};
done_testing;
