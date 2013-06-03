package ADMongo;

use strict;
use Moose;
use ADMongo::Connection;
use namespace::autoclean;
has 'database'   => (isa => 'Str', is => 'rw', required => 1);
has 'table'      => (isa => 'Str', is => 'rw', required => 1);
has 'collection' => (is => 'rw'); 

sub BUILD {
    my $self = shift;
    my $conn = ADMongo::Connection->new("host" => "mongodb://localhost:27017");
    my $database = $conn->get_database($self->database);
    $self->collection($database->get_collection($self->table));
}

1;
