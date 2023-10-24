package PayProp::API::Public::Client::Request::Export::Tenants;

use strict;
use warnings;

use Mouse;
with qw/ PayProp::API::Public::Client::Role::APIRequest /;

use PayProp::API::Public::Client::Response::Export::Tenant;
use PayProp::API::Public::Client::Response::Export::Tenant::Address;
use PayProp::API::Public::Client::Response::Export::Tenant::Property;

=head1 NAME

	PayProp::API::Public::Client::Request::Export::Tenants - Tenant export module.

=head1 SYNOPSIS

	my $Tenants = PayProp::API::Public::Client::Request::Export::Tenants->new(
		domain => 'API_DOMAIN.com',                                         # Required: API domain.
		authorization => C<PayProp::API::Public::Client::Authorization::*>, # Required: Instance of an authorization module.
	);

=head1 DESCRIPTION

Implementation for retrieving tenant export results via API.
This module is intended to be accessed via instance of C<PayProp::API::Public::Client>.

Example:

	PayProp::API::Public::Client->new( ... )
		->export
		->tenants
		->list_p({ ... })
		->then( sub {
			my ( $tenants ) = @_;
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
		return $self->abs_domain . '/api/agency/' . $self->api_version . '/export/tenants';
	},
);

=head2 list_p

Call to API tenants export that returns C<Mojo::Promise>.

	$self
		->list_p({ ... })
		->then( sub {
			my ( $tenants, $optional ) = @_;
			...;
		} )
		->catch( sub {
			my ( $Exception ) = @_;
			...;
		} )
		->wait
	;

Return:

	C<Mojo::Promise> containing list of C<PayProp::API::Public::Client::Response::Export::Tenant> on success.

	or

	C<PayProp::API::Public::Client::Exception::Response> on failure.

=cut

sub list_p {
	my ( $self, $params ) = @_;

	return $self
		->api_request_p({
			params => $params,
			handle_response_cb => sub { $self->_get_tenants( @_ ) },
		})
	;
}

sub _get_tenants {
	my ( $self, $response_json ) = @_;

	my @tenants;
	for my $tenant ( @{ $response_json->{items} // [] } ) {
		my $Tenant = PayProp::API::Public::Client::Response::Export::Tenant->new(
			id                => $tenant->{id},
			status            => $tenant->{status},
			comment           => $tenant->{comment},
			reference         => $tenant->{reference},
			last_name         => $tenant->{last_name},
			first_name        => $tenant->{first_name},
			notify_sms        => $tenant->{notify_sms},
			id_reg_no         => $tenant->{id_reg_no},
			id_type_id        => $tenant->{id_type_id},
			vat_number        => $tenant->{vat_number},
			customer_id       => $tenant->{customer_id},
			notify_email      => $tenant->{notify_email},
			email_address     => $tenant->{email_address},
			display_name      => $tenant->{display_name},
			mobile_number     => $tenant->{mobile_number},
			id_reg_number     => $tenant->{id_reg_number},
			business_name     => $tenant->{business_name},
			date_of_birth     => $tenant->{date_of_birth},
			email_cc_address  => $tenant->{email_cc_address},
			invoice_lead_days => $tenant->{invoice_lead_days},

			address => $self->_build_address( $tenant->{address} ),
			properties => $self->_build_properties( $tenant->{properties} ),
		);

		push( @tenants, $Tenant );
	}

	return \@tenants;
}

sub _build_properties {
	my ( $self, $properties_ref ) = @_;

	return [] unless @{ $properties_ref // [] };

	my @properties;

	foreach my $property ( $properties_ref->@* ) {

		my $Property = PayProp::API::Public::Client::Response::Export::Tenant::Property->new(
			id => $property->{id},
			balance => $property->{balance},
			comment => $property->{comment},
			listed_from => $property->{listed_from},
			listed_until => $property->{listed_until},
			property_name => $property->{property_name},
			allow_payments => $property->{allow_payments},
			account_balance => $property->{account_balance},
			approval_required => $property->{approval_required},
			responsible_agent => $property->{responsible_agent},
			customer_reference => $property->{customer_reference},
			hold_all_owner_funds => $property->{hold_all_owner_funds},
			last_processing_info => $property->{last_processing_info},
			property_account_minimum_balance => $property->{property_account_minimum_balance},

			address => $self->_build_address( $property->{address} ),
		);

		push( @properties, $Property );
	}

	return \@properties;
}

sub _build_address {
	my ( $self, $addres_ref ) = @_;

	return undef unless %{ $addres_ref // {} };

	my $Address = PayProp::API::Public::Client::Response::Export::Tenant::Address->new(
		id           => $addres_ref->{id},
		fax          => $addres_ref->{fax},
		city         => $addres_ref->{city},
		email        => $addres_ref->{email},
		phone        => $addres_ref->{phone},
		state        => $addres_ref->{state},
		created      => $addres_ref->{created},
		zip_code     => $addres_ref->{zip_code},
		modified     => $addres_ref->{modified},
		latitude     => $addres_ref->{latitude},
		longitude    => $addres_ref->{longitude},
		third_line   => $addres_ref->{third_line},
		first_line   => $addres_ref->{first_line},
		second_line  => $addres_ref->{second_line},
		country_code => $addres_ref->{country_code},
	);

	return $Address;
}

sub _query_params {
	my ( $self ) = @_;

	return [
		qw/
			rows
			page
			search_by
			external_id
			property_id
			is_archived
			customer_id
			search_value
			customer_reference
			modified_from_time
			modified_from_timezone
		/
	];
}

__PACKAGE__->meta->make_immutable;
