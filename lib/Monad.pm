package Monad;
use strict;
use warnings;
use utf8;
use Exporter 'import';
our @EXPORT_OK = qw/do_monad/;
use Mouse::Role;

requires qw/unit map flatmap/;

sub do_monad {
    my ($monad, @arr) = @_;
    local $_ = {
        monad => $monad
    };

    my $tmp_f = pop @arr;
    my $f = $tmp_f;

    @arr = reverse @arr;

    while ((@arr != 0) && (my ($generator, $key) = (shift @arr, shift @arr))) {
        my $old_f = $f;
        $f = sub { $generator->()->flatmap(sub { $_->{$key} = shift; $old_f->(); }) }
    }

    $f->();
}
1;
