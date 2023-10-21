package PayProp::API::Public::Client::Request::Entity::Payment;

use strict;
use warnings;

use Mouse;
with qw/ PayProp::API::Public::Client::Role::APIRequest /;

use PayProp::API::Public::Client::Response::Entity::Payment;

=head1 NAME

	PayProp::API::Public::Client::Request::Entity::Payment - Payment entity module.

=head1 SYNOPSIS

	my $Payment = PayProp::API::Public::Client::Request::Entity::Payment->new(
		domain => 'API_DOMAIN.com',                                         # Required: API domain.
		authorization => C<PayProp::API::Public::Client::Authorization::*>, # Required: Instance of an authorization module.
	);

=head1 DESCRIPTION

Implementation for creating, retrieving and updating (CRU) payment entity results via API.
This module is intended to be accessed via instance of C<PayProp::API::Public::Client>.

Example:

	PayProp::API::Public::Client->new( ... )
		->entity
		->payment
		->create_p({ ... })
		->then( sub {
			my ( $payment ) = @_;
			...;
		} )
		->catch( sub {
			my ( $Exception ) = @_;
			...;
		} )
		->wait
	;

=cut

has '+url' => (
	default => sub {
		my ( $self ) = @_;
		return $self->abs_domain . '/api/agency/' . $self->api_version . '/entity/payment';
	},
);

=head2 list_p

Call to API payment entity that returns C<Mojo::Promise>.

	$self
		->list_p({ ... })
		->then( sub {
			my ( $Payment ) = @_;
			...;
		} )
		->catch( sub {
			my ( $Exception ) = @_;
			...;
		} )
		->wait
	;

Return:

	C<Mojo::Promise> containing an instance of C<PayProp::API::Public::Client::Response::Entity::Payment> on success.

	or

	C<PayProp::API::Public::Client::Exception::Response> on failure.

=cut

sub list_p {
	my ( $self, $params ) = @_;

	return $self
		->api_request_p({
			params => $params,
			handle_response_cb => sub { $self->_get_payment( @_ ) },
		})
	;
}

=head2 create_p

Call to API payment entity that returns C<Mojo::Promise>.

	$self
		->create_p({ ... })
		->then( sub {
			my ( $Payment ) = @_;
			...;
		} )
		->catch( sub {
			my ( $Exception ) = @_;
			...;
		} )
		->wait
	;

Return:

	C<Mojo::Promise> containing an instance of C<PayProp::API::Public::Client::Response::Entity::Payment> on success.

	or

	C<PayProp::API::Public::Client::Exception::Response> on failure.

=cut

sub create_p {
	my ( $self, $content ) = @_;

	return $self
		->api_request_p({
			method => 'POST',
			content => { json => $content },
			handle_response_cb => sub { $self->_get_payment( @_ ) },
		})
	;
}

=head2 update_p

Call to API payment entity that returns C<Mojo::Promise>.

	$self
		->update_p({ ... })
		->then( sub {
			my ( $Payment ) = @_;
			...;
		} )
		->catch( sub {
			my ( $Exception ) = @_;
			...;
		} )
		->wait
	;

Return:

	C<Mojo::Promise> containing an instance of C<PayProp::API::Public::Client::Response::Entity::Payment> on success.

	or

	C<PayProp::API::Public::Client::Exception::Response> on failure.

=cut

sub update_p {
	my ( $self, $params, $content ) = @_;

	return $self
		->api_request_p({
			method => 'PUT',
			params => $params,
			content => { json => $content },
			handle_response_cb => sub { $self->_get_payment( @_ ) },
		})
	;
}

sub _get_payment {
	my ( $self, $response_json ) = @_;

	my $Payment = PayProp::API::Public::Client::Response::Entity::Payment->new(
		id                    => $response_json->{id},
		tax                   => $response_json->{tax},
		amount                => $response_json->{amount},
		enabled               => $response_json->{enabled},
		has_tax               => $response_json->{has_tax},
		end_date              => $response_json->{end_date},
		frequency             => $response_json->{frequency},
		reference             => $response_json->{reference},
		tenant_id             => $response_json->{tenant_id},
		tax_amount            => $response_json->{tax_amount},
		start_date            => $response_json->{start_date},
		percentage            => $response_json->{percentage},
		payment_day           => $response_json->{payment_day},
		customer_id           => $response_json->{customer_id},
		description           => $response_json->{description},
		property_id           => $response_json->{property_id},
		category_id           => $response_json->{category_id},
		use_money_from        => $response_json->{use_money_from},
		beneficiary_id        => $response_json->{beneficiary_id},
		beneficiary_type      => $response_json->{beneficiary_type},
		global_beneficiary    => $response_json->{global_beneficiary},
		no_commission_amount  => $response_json->{no_commission_amount},
		maintenance_ticket_id => $response_json->{maintenance_ticket_id},
	);

	return $Payment;
}

sub _path_params {
	my ( $self ) = @_;

	return [qw/ external_id /];
}

sub _query_params {
	my ( $self ) = @_;

	return [qw/ is_customer_id /];
}

__PACKAGE__->meta->make_immutable;
