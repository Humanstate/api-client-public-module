package PayProp::API::Public::Client::Request::Entity;

use strict;
use warnings;

use Mouse;
with qw/ PayProp::API::Public::Client::Role::Attribute::UA /;
with qw/ PayProp::API::Public::Client::Role::Attribute::Domain /;
with qw/ PayProp::API::Public::Client::Role::Attribute::Authorization /;

=head1 NAME

	PayProp::API::Public::Client::Request::Entity - Module containing various entity types as attributes.

=head1 SYNOPSIS

	use PayProp::API::Public::Client::Request::Entity;

	my $Entity = PayProp::API::Public::Client::Request::Entity->new(
		domain => 'API_DOMAIN.com',                                         # Required: API domain.
		authorization => C<PayProp::API::Public::Client::Authorization::*>, # Required: Instance of an authorization module.
	);

=head1 DESCRIPTION

Contains various API entity types defined on attributes.
This module is intended to be accessed via instance of C<PayProp::API::Public::Client>.

Example:

	my $Entity = PayProp::API::Public::Client->new( ... )
		->entity
	;

=cut

has payment => (
	is => 'ro',
	isa => 'PayProp::API::Public::Client::Request::Entity::Payment',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;

		require PayProp::API::Public::Client::Request::Entity::Payment;

		return PayProp::API::Public::Client::Request::Entity::Payment->new(
			ua => $self->ua,
			domain => $self->domain,
			scheme => $self->scheme,
			authorization => $self->authorization,
		);
	},
);

has invoice => (
	is => 'ro',
	isa => 'PayProp::API::Public::Client::Request::Entity::Invoice',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;

		require PayProp::API::Public::Client::Request::Entity::Invoice;

		return PayProp::API::Public::Client::Request::Entity::Invoice->new(
			ua => $self->ua,
			domain => $self->domain,
			scheme => $self->scheme,
			authorization => $self->authorization,
		);
	},
);

__PACKAGE__->meta->make_immutable;
