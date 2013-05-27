package TodayClick;

use strict;
use warnings;
use DBI;
use DateTime;
use Data::Dumper;


sub get_today_click {
    my $day   = DateTime->now()->ymd;
    my $dsn      = "DBI:mysql:database=tachyon;host=114.80.119.116;port=3306";
    my $user     = 'tachyon';
    my $password = 'tachyon';
    my $dbh = DBI->connect($dsn, $user, $password);
    my $rows = $dbh->selectall_arrayref(
            'select * from click where date = ? limit 1',
            {Slice => {}},
            $day
        );
    return {
        user_id => $rows->[0]->{'user_id'},
        ip      => $rows->[0]->{'ip'},
        date    => $rows->[0]->{'date'}
    }
}

1;
