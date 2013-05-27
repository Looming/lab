package TodayClick;

use strict;
use warnings;
use Moose;
use DBI;
use ConfigLoader;
use DateTime;
use Data::Dumper;

has 'dbh'   => (
    is  => 'rw',
    isa => 'DBI::db',
);
has 'config' => (
    is  => 'rw',
    isa => 'HashRef',
    default => sub {ConfigLoader::load()},
);

sub BUILD {
    my $self = shift;
    my $config   = $self->config;
    my $host     = $config->{'master'}->{'host'};
    my $database = $config->{'master'}->{'database'};
    my $port     = $config->{'master'}->{'port'};
    my $usr      = $config->{'master'}->{'usr'};
    my $passwd   = $config->{'master'}->{'passwd'};
    my $dsn = "DBI:mysql:database=$database;host=$host;port=$port";
    my $dbh = DBI->connect($dsn, $usr, $passwd);
    $self->dbh($dbh);
}

sub get_today_click {
    my $self = shift;
    my $day   = DateTime->now()->ymd;
    my $rows = $self->dbh->selectall_arrayref(
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
