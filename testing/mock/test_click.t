#!/usr/bin/perl

use Test::More;
use Test::MockTime qw/set_fixed_time/;
use Test::MockModule;
use TodayClick;
set_fixed_time('12/11/2011', '%m/%d/%Y');

my $expect = {
    user_id => 11,
    ip      => '222.73.96.250',
    date    => '2011-12-11',
};

is_deeply( TodayClick::get_today_click(), $expect);

{
    my $module = new Test::MockModule( 'TodayClick' );
    $module->mock('get_today_click', sub { return 'I am a liar' } );
    is( TodayClick::get_today_click(), 'I am a liar');
}

is_deeply( TodayClick::get_today_click(), $expect);

done_testing;
