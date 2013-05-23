package TodayClick;

use strict;
use warnings;
use DBI;
use DateTime;
use Data::Dumper;

my $update_day = '2011-11-11';

sub get_today_click {
    my $day   = DateTime->now()->ymd;
    my $dsn      = "DBI:mysql:database=tachyon;host=114.80.119.116;port=3306";
    my $user     = 'tachyon';
    my $password = 'tachyon';
    my $dbh = DBI->connect($dsn, $user, $password);
    print Dumper $dbh;;
    my $rows = $dbh->selectall_arrayref(
            'select * from click',
            {Slice => {}}
        );
    print Dumper $rows;
}

=a
    if ( $day eq $update_day ){
        return {
            id          => 1,
            ip          => '127.0.0.1',
            update_time => $update_day,
        };
    }else{
        return undef;
    }
}
=cut
1;
