package TodayClick;

use strict;
use warnings;
use Date::Calc qw/Today/;

my $update_day = '2011-11-11 11:11:11';

sub get_today_click {
    my $day = Today();
    if ( $day == $update_day ){
        return {
            id          => 1,
            ip          => '127.0.0.1',
            update_time => $update_day,
        };
    }else{
        return undef;
    }
}
1;
