#!/usr/bin/perl

use Test::More;
use Test::MockTime qw/set_fixed_time/;

use TodayClick;
set_fixed_time('11/11/2011', '%m/%d/%Y');

my $expect = {
    id          => 1,
    ip          => '127.0.0.1',
    update_time => '2011-11-11',
};

is_deeply( TodayClick::get_today_click(), $expect);

done_testing;
