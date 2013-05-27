#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::MockTime qw/set_fixed_time/;
use Test::MockModule;
use MockDatabase;
use TodayClick;


MockDatabase::mock();
set_fixed_time('12/11/2011', '%m/%d/%Y');

my $config = ConfigLoader->load();
use Data::Dumper;
#print Dumper $config;

my $expect = {
    user_id => 11,
    ip      => '222.73.96.250',
    date    => '2011-12-11',
};

is_deeply( TodayClick->new->get_today_click(), $expect);


done_testing;
