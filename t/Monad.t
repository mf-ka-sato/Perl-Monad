use strict;
use warnings;
use utf8;
use Test::More;

use Monad qw/do_monad/;
use Monad::Maybe qw/just nothing to_maybe/;

sub safety_divide {
    my ($x, $y) = @_;
    to_maybe { $x / $y };
}

my $result = do_monad 'Monad::Maybe' => (
    x => sub { safety_divide(100, 10) },
    y => sub { safety_divide(100, 2) },
    sub { $_->{x} + $_->{y} }
);

ok not $result->is_nothing;
is $result->{_value}, 60;

done_testing;
