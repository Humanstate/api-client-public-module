package PayProp::API::Public::Client::Authorization::Storage::Local;

use strict;
use warnings;

use Mouse;
with qw/ PayProp::API::Public::Client::Role::Storage /;

use Mojo::Promise;

=head1 NAME

	PayProp::API::Public::Client::Authorization::Storage::Local - Local in-memory storage for tokens.

=head1 SYNOPSIS

	my $Storage = PayProp::API::Public::Client::Authorization::Storage::Local->new

=head1 DESCRIPTION

Local key-value storage solution to be provided for C<PayProp::API::Public::Client::Authorization::*>.

=cut

has storage => (
	is => 'ro',
	isa => 'HashRef',
	default => sub { +{} },
);

sub _ping_p {
	my ( $self ) = @_;

	return Mojo::Promise->new(
		sub {
			my( $resolve, $reject ) = @_;

			return ref( $self->storage ) eq 'HASH' ? $resolve->( 1 ) : $reject->( 0 );
		}
	);
}

sub _set_p {
	my ( $self, $key, $value ) = @_;

	return Mojo::Promise->new(
		sub {
			my( $resolve, $reject ) = @_;

			$self->storage->{ $key } = $value;

			return $resolve->( 1 );
		}
	);
}

sub _get_p {
	my ( $self, $key ) = @_;

	return Mojo::Promise->new(
		sub {
			my( $resolve, $reject ) = @_;

			return $resolve->( $self->storage->{ $key } );
		}
	);
}

sub _delete_p {
	my ( $self, $key ) = @_;

	return Mojo::Promise->new(
		sub {
			my( $resolve, $reject ) = @_;

			delete $self->storage->{ $key };

			return $resolve->( 1 );
		}
	);
}

__PACKAGE__->meta->make_immutable;
