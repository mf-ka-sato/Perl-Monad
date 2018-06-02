package Monad::List;
use strict;
use warnings;
use utf8;
use Mouse;
with 'Monad';

#------ Functions ------#

sub list {}

sub empty_list {}

#------ Methods ------#

sub unit {}

sub map {}

sub flatmap {}

sub foreach {}

sub foldl {}
sub foldr {}

sub forall {}
sub exists {}

sub zip_with {}

1;
