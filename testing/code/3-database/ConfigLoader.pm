package ConfigLoader;

use strict;
use warnings;
use Data::Visitor::Callback;
use YAML;


sub load{
  my $file = 'config.yml';
  
  my $config = YAML::LoadFile( $file );
  
  my $v = Data::Visitor::Callback->new(
    plain_value => sub {
      return unless defined $_;
      s[\_\_HOME\_\_][];
    }
  );
  $v->visit( $config );
  
  $config->{ home } = '';
  return $config;
}

1;
