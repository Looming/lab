#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

my $engineer1 = {
    name  => 'jack',
    age   => 24,
    skill => 'perl'
};

my $engineer2 = {
    name  => 'zz',
    age   => 20,
    skill => 'java'
};

use_ok('Engineer') or exit;

my $engineer = Engineer->new( $engineer1 );

isa_ok( $engineer, 'Engineer' );

is( $engineer->age, $engineer1->{age}, 'age() should return ' . $engineer1->{age} );

like( $engineer->des, qr/^jack.*perl$/ );

isnt( $engineer->age, $engineer2->{age}, 'age() should return ' . $engineer1->{age} );


done_testing;
