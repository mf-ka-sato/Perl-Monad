package MonadRule;
use strict;
use warnings;
use utf8;
use Test::More;

# モナド則のテスト
sub monad_rule {
    my ($pkg, $compare_f) = @_;
    
    rule1($pkg, $compare_f);
    rule2($pkg, $compare_f);
    rule3($pkg, $compare_f);
};

sub rule1 {
    my ($pkg, $compare_f) = @_;

    # return x >>= f == f x

    my $x = 100;
    my $f = sub { $pkg->unit($_[0] + 11) };

    my $left = $pkg->unit($x)->flatmap($f);
    my $right = $f->($x);

    is_deeply $compare_f->($left), $compare_f->($right);
}

sub rule2 {
    my ($pkg, $compare_f) = @_;

    # m >>= return == m
    
    my $m = $pkg->unit("String");
    
    my $left = $m->flatmap(sub { $pkg->unit($_[0]) });
    my $right = $m;

    is_deeply $compare_f->($left), $compare_f->($right);
}

sub rule3 {
    my ($pkg, $compare_f) = @_;

    # (m >>= f) >>= g == m >>= (\x -> f x >>= g)

    my $m = $pkg->unit("Monad");
    my $f = sub { $pkg->unit($_[0] x 3) };
    my $g = sub { $pkg->unit($_[0] . "?") };

    my $left = ($m->flatmap($f))->flatmap($g);
    my $right = $m->flatmap(sub { $f->($_[0])->flatmap($g) });

    is_deeply $compare_f->($left), $compare_f->($right);
}
1;
