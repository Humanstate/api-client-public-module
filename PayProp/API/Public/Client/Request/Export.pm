package PayProp::API::Public::Client::Request::Export;

use strict;
use warnings;

use Mouse;
with qw/ PayProp::API::Public::Client::Role::Attribute::UA /;
with qw/ PayProp::API::Public::Client::Role::Attribute::Domain /;
with qw/ PayProp::API::Public::Client::Role::Attribute::Authorization /;

=head1 NAME

	PayProp::API::Public::Client::Request::Export - Module containing various export types as attributes.

=head1 SYNOPSIS

	use PayProp::API::Public::Client::Request::Export;

	my $Export = PayProp::API::Public::Client::Request::Export->new(
		domain => 'API_DOMAIN.com',                                         # Required: API domain.
		authorization => C<PayProp::API::Public::Client::Authorization::*>, # Required: Instance of an authorization module.
	);

=head1 DESCRIPTION

Contains various API export types defined on attributes.
This module is intended to be accessed via instance of C<PayProp::API::Public::Client>.

Example:

	my $Export = PayProp::API::Public::Client->new( ... )
		->export
	;

=cut

has beneficiaries => (
	is => 'ro',
	isa => 'PayProp::API::Public::Client::Request::Export::Beneficiaries',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;

		require PayProp::API::Public::Client::Request::Export::Beneficiaries;

		return PayProp::API::Public::Client::Request::Export::Beneficiaries->new(
			ua => $self->ua,
			domain => $self->domain,
			scheme => $self->scheme,
			authorization => $self->authorization,
		);
	},
);

has tenants => (
	is => 'ro',
	isa => 'PayProp::API::Public::Client::Request::Export::Tenants',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;

		require PayProp::API::Public::Client::Request::Export::Tenants;

		return PayProp::API::Public::Client::Request::Export::Tenants->new(
			ua => $self->ua,
			domain => $self->domain,
			scheme => $self->scheme,
			authorization => $self->authorization,
		);
	},
);

__PACKAGE__->meta->make_immutable;
