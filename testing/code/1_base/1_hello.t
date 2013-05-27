#!/usr/bin/perl
use strict;
use warnings;
use Test::Simple tests => 1;
sub hello_world {
    return "hello,world";
}

ok(hello_world() eq "hello,world");
