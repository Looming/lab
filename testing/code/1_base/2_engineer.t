#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 5;

my $test_engineer = {
    name  => 'jack',
    age   => 24,
    skill => 'perl'
};

my $wrong_engineer = {
    name  => 'zz',
    age   => 20,
    skill => 'perl'
};

use_ok('Engineer') or exit;

my $engineer = Engineer->new( $test_engineer );

isa_ok( $engineer, 'Engineer' );

is( $engineer->age, $test_engineer->{age}, 'age() should return ' . $test_engineer->{age} );

like( $engineer->des, qr/^jack.*perl$/ );

is( $engineer->age, $wrong_engineer->{age}, 'age() should return ' . $test_engineer->{age} );
