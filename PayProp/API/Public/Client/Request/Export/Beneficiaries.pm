package PayProp::API::Public::Client::Request::Export::Beneficiaries;

use strict;
use warnings;

use Mouse;
with qw/ PayProp::API::Public::Client::Role::APIRequest /;

use PayProp::API::Public::Client::Response::Export::Beneficiary;
use PayProp::API::Public::Client::Response::Export::Beneficiary::Address;
use PayProp::API::Public::Client::Response::Export::Beneficiary::Property;

=head1 NAME

	PayProp::API::Public::Client::Request::Export::Beneficiaries - Beneficiary export module.

=head1 SYNOPSIS

	my $Beneficiaries = PayProp::API::Public::Client::Request::Export::Beneficiaries->new(
		domain => 'API_DOMAIN.com',                                         # Required: API domain.
		authorization => C<PayProp::API::Public::Client::Authorization::*>, # Required: Instance of an authorization module.
	);

=head1 DESCRIPTION

Implementation for retrieving beneficiary export results via API.
This module is intended to be accessed via instance of C<PayProp::API::Public::Client>.

Example:

	PayProp::API::Public::Client->new( ... )
		->export
		->beneficiaries
		->list_p({ ... })
		->then( sub {
			my ( $beneficiaries ) = @_;
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
		return $self->abs_domain . '/api/agency/' . $self->api_version . '/export/beneficiaries';
	},
);

=head2 list_p

Call to API beneficiaries export that returns C<Mojo::Promise>.

	$self
		->list_p({ ... })
		->then( sub {
			my ( $beneficiaries, $optional ) = @_;
			...;
		} )
		->catch( sub {
			my ( $Exception ) = @_;
			...;
		} )
		->wait
	;

Return:

	C<Mojo::Promise> containing list of C<PayProp::API::Public::Client::Response::Export::Beneficiary> on success.

	or

	C<PayProp::API::Public::Client::Exception::Response> on failure.

=cut

sub list_p {
	my ( $self, $params ) = @_;

	return $self
		->api_request_p({
			params => $params,
			handle_response_cb => sub { $self->_get_beneficiaries( @_ ) },
		})
	;
}

sub _get_beneficiaries {
	my ( $self, $response_json ) = @_;

	my @beneficiaries;
	for my $beneficiary ( @{ $response_json->{items} // [] } ) {
		my $Beneficiary = PayProp::API::Public::Client::Response::Export::Beneficiary->new(
			id                 => $beneficiary->{id},
			comment            => $beneficiary->{comment},
			is_owner           => $beneficiary->{is_owner},
			owner_app          => $beneficiary->{owner_app},
			last_name          => $beneficiary->{last_name},
			first_name         => $beneficiary->{first_name},
			notify_sms         => $beneficiary->{notify_sms},
			id_type_id         => $beneficiary->{id_type_id},
			vat_number         => $beneficiary->{vat_number},
			customer_id        => $beneficiary->{customer_id},
			notify_email       => $beneficiary->{notify_email},
			international      => $beneficiary->{international},
			email_address      => $beneficiary->{email_address},
			mobile_number      => $beneficiary->{mobile_number},
			id_reg_number      => $beneficiary->{id_reg_number},
			business_name      => $beneficiary->{business_name},
			is_active_owner    => $beneficiary->{is_active_owner},
			email_cc_address   => $beneficiary->{email_cc_address},
			customer_reference => $beneficiary->{customer_reference},

			properties => $self->_build_properties( $beneficiary->{properties} ),
			billing_address => $self->_build_address( $beneficiary->{billing_address} ),
		);

		push( @beneficiaries, $Beneficiary );
	}

	return \@beneficiaries;
}

sub _build_properties {
	my ( $self, $properties_ref ) = @_;

	return [] unless @{ $properties_ref // [] };

	my @properties;

	foreach my $property ( $properties_ref->@* ) {
		my $Property = PayProp::API::Public::Client::Response::Export::Beneficiary::Property->new(
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

	my $Address = PayProp::API::Public::Client::Response::Export::Beneficiary::Address->new(
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
			owners
			external_id
			search_by
			search_value
			is_archived
			customer_id
			bank_branch_code
			customer_reference
			modified_from_time
			bank_account_number
			modified_from_timezone
		/
	];
}

__PACKAGE__->meta->make_immutable;
