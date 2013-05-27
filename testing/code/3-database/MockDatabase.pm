package MockDatabase;

use warnings;
use Moose;
use Test::MockModule;
use Data::Visitor::Callback;
use YAML;
use Data::Dumper;

my $schema;

sub mock{
    no strict;
    $module = new Test::MockModule( 'ConfigLoader' );
    $module->mock('load', sub {
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
            $config->{ master }->{ database } = 'test_tachyon';
            $config->{ slave }->{ database } = 'test_tachyon';
            return $config;
        }
    );
}


sub install_schema{
}

sub reinstall_schema{
}

sub uninstall_schema{
}

sub import {
    my ($class, $pkg) = (shift, (caller)[0]);
#    $class->_import($pkg, @_);
    $schema = \@_;
    print Dumper $schema;
}
=cut
1;

