#/usr/bin/perl

use ADMongo;
use Data::Dump qw/dump/;

#my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
#my $database = $client->get_database('test');
#my $collection = $database->get_collection('test');
#my $a = $collection->find({ some =>'data'});
#print $a;

my $db = ADMongo->new(database => 'test', table => 'test')->collection;
$a = $db->find({ a => 1 });
my $out = $a->next;
print dump $out;

