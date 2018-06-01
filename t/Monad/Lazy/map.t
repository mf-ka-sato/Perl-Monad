use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Lazy;

subtest 'basic' => sub {
    my $lazy = Monad::Lazy->unit(300);
    my $mapped = $lazy->map(sub { $_[0] + 33 });

    is $mapped->value, 333;
    is $lazy->value, 300;
};

subtest 'use cache' => sub {
    my $lazy = Monad::Lazy->unit(100);
    my $called = 0;
    my $f = sub { $called++; $_[0] * 10 };

    my $mapped = $lazy->map($f);

    is $called, 0;
    is $mapped->value, 1000;
    is $called, 1;

    is $mapped->value, 1000;
    is $called, 1;

    is $mapped->{_gen}->(), 1000;
    is $called, 2;
};

done_testing;
