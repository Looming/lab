package Engineer;

use Moose;

has 'name'  => (is => 'rw', isa => 'Str');
has 'age'   => (is => 'rw', isa => 'Int');
has 'skill' => (is => 'rw', isa => 'Str');
has 'des'   => (is => 'rw', isa => 'Str');

sub BUILD {
    my $self = shift;
    $self->des($self->name . " " . $self->age . " " . $self->skill);
}

1;
