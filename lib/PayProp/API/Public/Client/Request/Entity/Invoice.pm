package PayProp::API::Public::Client::Request::Entity::Invoice;

use strict;
use warnings;

use Mouse;
with qw/ PayProp::API::Public::Client::Role::APIRequest /;

use PayProp::API::Public::Client::Response::Entity::Invoice;

=head1 NAME

	PayProp::API::Public::Client::Request::Entity::Invoice - Invoice entity module.

=head1 SYNOPSIS

	my $Invoice = PayProp::API::Public::Client::Request::Entity::Invoice->new(
		domain => 'API_DOMAIN.com',                                         # Required: API domain.
		authorization => C<PayProp::API::Public::Client::Authorization::*>, # Required: Instance of an authorization module.
	);

=head1 DESCRIPTION

Implementation for creating, retrieving and updating (CRU) invoice entity results via API.
This module is intended to be accessed via instance of C<PayProp::API::Public::Client>.

Example:

	PayProp::API::Public::Client->new( ... )
		->entity
		->invoice
		->create_p({ ... })
		->then( sub {
			my ( $invoice ) = @_;
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
		return $self->abs_domain . '/api/agency/' . $self->api_version . '/entity/invoice';
	},
);

=head2 list_p

Call to API invoice entity that returns C<Mojo::Promise>.

	$self
		->list_p({ ... })
		->then( sub {
			my ( $Invoice ) = @_;
			...;
		} )
		->catch( sub {
			my ( $Exception ) = @_;
			...;
		} )
		->wait
	;

Return:

	C<Mojo::Promise> containing an instance of C<PayProp::API::Public::Client::Response::Entity::Invoice> on success.

	or

	C<PayProp::API::Public::Client::Exception::Response> on failure.

=cut

sub list_p {
	my ( $self, $params ) = @_;

	return $self
		->api_request_p({
			params => $params,
			handle_response_cb => sub { $self->_get_invoice( @_ ) },
		})
	;
}

=head2 create_p

Call to API invoice entity that returns C<Mojo::Promise>.

	$self
		->create_p({ ... })
		->then( sub {
			my ( $Invoice ) = @_;
			...;
		} )
		->catch( sub {
			my ( $Exception ) = @_;
			...;
		} )
		->wait
	;

Return:

	C<Mojo::Promise> containing an instance of C<PayProp::API::Public::Client::Response::Entity::Invoice> on success.

	or

	C<PayProp::API::Public::Client::Exception::Response> on failure.

=cut

sub create_p {
	my ( $self, $content ) = @_;

	return $self
		->api_request_p({
			method => 'POST',
			content => { json => $content },
			handle_response_cb => sub { $self->_get_invoice( @_ ) },
		})
	;
}

=head2 update_p

Call to API invoice entity that returns C<Mojo::Promise>.

	$self
		->update_p({ ... })
		->then( sub {
			my ( $Invoice ) = @_;
			...;
		} )
		->catch( sub {
			my ( $Exception ) = @_;
			...;
		} )
		->wait
	;

Return:

	C<Mojo::Promise> containing an instance of C<PayProp::API::Public::Client::Response::Entity::Invoice> on success.

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
			handle_response_cb => sub { $self->_get_invoice( @_ ) },
		})
	;
}

sub _get_invoice {
	my ( $self, $response_json ) = @_;

	my $Invoice = PayProp::API::Public::Client::Response::Entity::Invoice->new(
		id                 => $response_json->{id},
		tax                => $response_json->{tax},
		amount             => $response_json->{amount},
		has_tax            => $response_json->{has_tax},
		end_date           => $response_json->{end_date},
		frequency          => $response_json->{frequency},
		tenant_id          => $response_json->{tenant_id},
		tax_amount         => $response_json->{tax_amount},
		start_date         => $response_json->{start_date},
		deposit_id         => $response_json->{deposit_id},
		category_id        => $response_json->{category_id},
		property_id        => $response_json->{property_id},
		payment_day        => $response_json->{payment_day},
		customer_id        => $response_json->{customer_id},
		description        => $response_json->{description},
		is_direct_debit    => $response_json->{is_direct_debit},
		has_invoice_period => $response_json->{has_invoice_period},
	);

	return $Invoice;
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
