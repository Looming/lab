package ADMongo::Connection;

use strict;
use Moose;
use namespace::autoclean;
extends 'MongoDB::Connection';

override 'get_database' => sub {
    my $self = shift;
    return super();
};

1;
