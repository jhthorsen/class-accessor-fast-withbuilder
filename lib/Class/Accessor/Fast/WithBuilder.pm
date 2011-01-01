package Class::Accessor::Fast::WithBuilder;

=head1 NAME

Class::Accessor::Fast::WithBuilder - Class::Accessor::Fast with lazy defaults

=head1 VERSION

0.00

=head1 DESCRIPTION

=head1 SYNOPSIS

See L<Class::Accessor/SYNOPSIS>.

=cut

use strict;
use warnings;
use base 'Class::Accessor::Fast'; # overriding all ::Fast methods, but...

our $VERSION = eval '0.00';

=head1 METHODS

=head2 make_accessor

=cut

sub make_accessor {
    my($class, $field) = @_;
    my $builder = "_build_$field";

    return sub {
        return $_[0]->{$field} = @_ == 2 ? $_[1] : [@_[1..$#_]] if @_ > 1;
        exists $_[0]->{$field} or $_[0]->{$field} = $_[0]->$builder;
        return $_[0]->{$field} if @_ == 1;
    };
}

=head2 make_accessor

=cut

sub make_ro_accessor {
    my($class, $field) = @_;
    my $builder = "_build_$field";

    return sub {
        exists $_[0]->{$field} or $_[0]->{$field} = $_[0]->$builder;
        return $_[0]->{$field} if @_ == 1;
        my $caller = caller;
        $_[0]->_croak("'$caller' cannot alter the value of '$field' on objects of class '$class'");
    };
}

=head2 make_wo_accessor

This is not implemented.

=cut

sub make_wo_accessor {
    $_[0]->_croak('not implemented');
}

sub _mk_accessors {
    my $class = shift;
    my($type, @fields) = @_;

    for my $f (@fields) {
        unless($class->can("_build_$f")) {
            $class->_croak("$class\::_build_$f() is required!");
        }
    }

    return $class->SUPER::_mk_accessors(@_);
}

=head1 COPYRIGHT & LICENSE

=head1 AUTHOR

Jan Henning Thorsen C<< jhthorsen at cpan.org >>

=cut

1;
