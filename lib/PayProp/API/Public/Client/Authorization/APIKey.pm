package PayProp::API::Public::Client::Authorization::APIKey;

use strict;
use warnings;

use Mouse;
extends qw/ PayProp::API::Public::Client::Authorization::Base /;

use Mojo::Promise;

=head1 NAME

	PayProp::API::Public::Client::Authorization::APIKey - API key authorization module.

=head1 SYNOPSIS

	use PayProp::API::Public::Client::Authorization::APIKey;

	my $APIKey = PayProp::API::Public::Client::Authorization::APIKey->new(
		token => 'YOUR_API_KEY', # Required: PayProp API key.
	);

=head1 DESCRIPTION

API key authorization module type to be provided for C<PayProp::API::Public::Client> initialization.
Note that C<storage_key> is not overridden in this module as it's not expected for this module to utilize storage solution;
an exception will be thrown by default if storage is provided for C<PayProp::API::Public::Client::Authorization::APIKey> module.

=cut

has token => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has '+token_type' => ( default => sub { 'APIkey' } );

sub _token_request_p {
	my ( $self ) = @_;

	return Mojo::Promise
		->new( sub {
			my ( $resolve, $reject ) = @_;

			return $resolve->({
				token => $self->token,
				token_type => $self->token_type,
			});
		} )
	;
}

__PACKAGE__->meta->make_immutable;
