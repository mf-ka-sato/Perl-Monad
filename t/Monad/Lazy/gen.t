use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Lazy;

subtest 'basic' => sub {
    my $lazy = Monad::Lazy->gen(sub { 200 });

    is $lazy->{_value}, undef;
    is $lazy->value, 200;
    is $lazy->{_value}, 200;
    is $lazy->{_gen}->(), 200;
};

subtest 'lazy evaluation' => sub {
    my $x = 0;
    my $lazy = Monad::Lazy->gen(sub { $x++; 100 });

    is $x, 0;
    is $lazy->{_value}, undef;
    is $lazy->value, 100;
    is $x, 1;
    
    $lazy->value;           # use cache
    is $x, 1;

    is $lazy->{_gen}->(), 100;
    is $x, 2;
};


done_testing;
