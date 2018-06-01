use strict;
use warnings;
use utf8;
use Test::More;

use Monad::Lazy;

subtest 'basic' => sub {
    my $lazy = Monad::Lazy->unit(100);

    is $lazy->value, 100;
    is $lazy->{_value}, 100;
    is $lazy->{_gen}->(), 100;
};

done_testing;
