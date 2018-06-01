use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Lazy;

subtest 'basic' => sub {
    my $lazy = Monad::Lazy->unit(30);
    my $f = sub { my $x = shift; Monad::Lazy->gen(sub { $x * 10 }) };
    my $flatmapped = $lazy->flatmap($f);

    is $flatmapped->{_value}, undef;
    is $flatmapped->value, 300;
    is $flatmapped->{_value}, 300;

    is $lazy->value, 30;
};

subtest 'lazy evaluation' => sub {
    my $lazy = Monad::Lazy->unit(50);
    my $called1 = 0;
    my $called2 = 0;
    my $f = sub { my $x = shift; $called1++; Monad::Lazy->gen(sub { $called2++; $x + 120 }) };

    my $flatmapped = $lazy->flatmap($f);

    
    is $called1, 0;
    is $called2, 0;

    is $flatmapped->value, 170;

    is $called1, 1;
    is $called2, 1;

    is $flatmapped->value, 170;

    is $called1, 1;
    is $called2, 1;
};

done_testing;
