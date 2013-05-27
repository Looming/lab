package Mixi::Test::Fixtures;
use strict;
use warnings;

use List::MoreUtils qw/first_index first_value/;

use base qw/Nove::Test::Fixtures/;
use Nove::Core::Module::Method::ProxySubroutine 'Nove::Test::Fixtures' => qw/
    unique_prefix
/;

INIT {
    if ($ENV{MIXI_TEST_FIXTURES_STRICT}) {
        Mixi::Test::Fixtures->strict;

    } elsif ($ENV{MIXI_TEST_FIXTURES_WARNINGS}) {
        Mixi::Test::Fixtures->warnings;
    }
}

sub __export {
    my $class = shift;
    my $pkg   = shift;
    my $index = first_index { /\Afixtures\z/ } @_;
    if ($index != -1) {
        splice @_, $index, 1;
        Sub::Install::install_sub({
            code => \&fixtures,
            into => $pkg,
        });
    }
    return @_;
}

sub import {
    my $class = shift;
    my $pkg = (caller)[0];
    $class->_import($pkg, @_);
}

{
    my %originals;

    sub __inject {
        my ($class, $code) = @_;
        for my $sym (@Mixi::Config::EXPORT_OK) {
            next unless $sym =~ /\ADB_/;
            next if Mixi::Config->can("$sym\_origin");
            no strict 'refs';
            no warnings 'redefine';
            my $original = ($originals{$sym} ||= Mixi::Config->$sym);
            *{"Mixi::Config::_alias_$sym"} = *{"Mixi::Config::$sym"} = sub () {
                $code->("$sym is not fixtured.");
                return $original;
            };
        }
    };
}

sub fixtures {
    my $caller = caller;
    __PACKAGE__->_fixtures($caller, @_);
}

sub _can_use_local_mysql {
    my ($self, $dsn) = @_;

    return 0 if ($dsn =~ m{; host=( \Qtritonn.lo.mixi.jp\E |
                                    \Qq4m.lo.mixi.jp\E )}xms);

    return 0 if ($dsn =~ m{[:;] database=(?: goods_not_secure    |
                                             diary_manager       );}xms);
    return 1;
}

sub __label2dsn {
    my ($self, $label) = @_;

    throw Nove::Test::Fixtures::Error("$label is invalid")
        unless defined $label && ( $label =~ /^DB/ || $label =~ /^HANDLER_SOCKET_/ );

    my $config = first_value { Mixi::Config->can($_) }
        map { "$label$_" } qw/_origin _MST_origin/, q{}, q{_MST};

    if($label eq 'DB_OLD_MAILMAGA'){
        my $dsn = Mixi::Config::DB_OLD_MAILMAGA_SLV->[0];
        $dsn =~ s{ ;MixiDevReadOnly \z}{}xms;
        return $dsn;
    }
    if ($config) {
        if ($label =~ /^DB/ ){
            my $dsn = Mixi::Config->$config;
            return (ref $dsn ? $dsn->[0] : $dsn);
        }elsif( $label =~ /^HANDLER_SOCKET_/ ){
            my $setting = Mixi::Config->$config;

            return $self->__handler_socket_setting_2_dsn( $setting );
        }
    }
    else {
        throw Nove::Test::Fixtures::Error("$label does not exist")
            unless $config;
    }
}

sub __exclude_special_db_name {
    my ($self, $label) = @_;
    my @db_list = qw/DB_NOTIFY_BIRTHDAY_FRIEND/;

    return 1 if List::Util::first{$_ eq $label} @db_list;
}

sub __expand_database_label {
    my ($self, $label) = @_;

    # 以下のIF文内の条件に合致するDBの場合には通常のfixtureとは異なる命名規則のfixtureを
    # 用いる。前方一致で判別されてしまうため、通常のfixtureと同様にするためには
    # __exclude_special_db_nameのリストにDB名を追加しておく

    if ($self->__exclude_special_db_name($label)) {
        return map { "$label\_$_" } qw(MST SLV BAK);
    }
    elsif ($label =~ /^(DB_NOTIFY|DB_AFFINITY_DATA)/) {
        return ($label);
    }
    elsif ($label =~ /^DB_OLD|^DB_COMMUNITY_MEMBER/) {
        return map { "$label\_$_" } qw(MST SLV BAK SCR);
    }
    elsif ($label =~ /^DB_APPLICATION_(USER|PUSH)_REQUEST_MEMBER/) {
        return ($label);
    }
    elsif ($label =~ /^DB_FOOTPRINT/) {
        return ($label);
    }
    elsif ($label =~ /^DB_SELF_FOOTPRINT/) {
        return ($label);
    }
    elsif ($label =~ /^DB_VISITOR/) {
        return ($label);
    }
    elsif ($label =~ /^DB_SELF_VISITOR/) {
        return ($label);
    }
    else {
        return map { "$label\_$_" } qw(MST SLV BAK);
    }
}

sub replace_config_dsn {
    my ($self, $label, $builder_dsn) = @_;
    for my $label ($self->__expand_database_label($label)) {
        next unless $label =~ /^DB_/;
        next unless Mixi::Config->can($label);
        next if Mixi::Config->can("$label\_origin");
        my $original = Mixi::Config->can($label)->();
        no strict 'refs';
        no warnings;

        my $dsn = $builder_dsn;
        if ($original =~ /;MixiDevReadOnly\z/) {
            $dsn .= ';MixiDevReadOnly';
        }
        *{"Mixi::Config::$label"}         = sub () { $dsn };
        *{"Mixi::Config::$label\_origin"} = sub () { $original };
        *{"Mixi::Config::_alias_$label"}         = sub () { $dsn };
        *{"Mixi::Config::_alias_$label\_origin"} = sub () { $original };
    }
}

sub replace_config_handler_socket_setting {
    my ($self, $label, $builder_handler_socket_setting ) = @_;
    for my $label ( $self->__expand_database_label( $label ) ){
        next unless $label =~ /^HANDLER_SOCKET_/;
        next unless Mixi::Config->can($label);
        next if Mixi::Config->can("$label\_origin");

        my $original = Mixi::Config->can($label)->();
        no strict 'refs';
        no warnings;

        my $handler_socket_setting = $builder_handler_socket_setting;

        *{"Mixi::Config::$label"}           = sub () { $handler_socket_setting };
        *{"Mixi::Config::$label\_origin"}   = sub () { $original };
        *{"Mixi::Config::_alias_$label"}    = sub () { $handler_socket_setting };
        *{"Mixi::Config::_alias_$label\_origin"} = sub () { $original };
    }
}

1;
__END__

=head1 NAME

Mixi::Test::Fixtures - fixture機能を提供するモジュール

=head1 SEE ALSO

L<Nove::Test::Fixtures>, L<Nove::Test::Fixtures::L2>

=cut
