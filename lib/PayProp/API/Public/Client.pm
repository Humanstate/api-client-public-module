package PayProp::API::Public::Client;

use strict;
use warnings;

use Mouse;
with qw/ PayProp::API::Public::Client::Role::Attribute::UA /;
with qw/ PayProp::API::Public::Client::Role::Attribute::Domain /;
with qw/ PayProp::API::Public::Client::Role::Attribute::Authorization /;

our $VERSION = '0.01';

has export => (
	is => 'ro',
	isa => 'PayProp::API::Public::Client::Request::Export',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;

		require PayProp::API::Public::Client::Request::Export;
		return PayProp::API::Public::Client::Request::Export->new(
			ua => $self->ua,
			domain => $self->domain,
			scheme => $self->scheme,
			authorization => $self->authorization,
		);
	}
);

has entity => (
	is => 'ro',
	isa => 'PayProp::API::Public::Client::Request::Entity',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;

		require PayProp::API::Public::Client::Request::Entity;
		return PayProp::API::Public::Client::Request::Entity->new(
			ua => $self->ua,
			domain => $self->domain,
			scheme => $self->scheme,
			authorization => $self->authorization,
		);
	}
);

__PACKAGE__->meta->make_immutable;

__END__

=encoding utf-8

=head1 NAME

	PayProp::API::Public::Client - PayProp API client.

=head1 SYNOPSIS

	use PayProp::API::Public::Client;
	use PayProp::API::Public::Client::Authorization::APIKey;
	use PayProp::API::Public::Client::Authorization::ClientCredentials;
	use PayProp::API::Public::Client::Authorization::Storage::Memcached;

	my $Client = PayProp::API::Public::Client->new(
		domain => 'paypropdev.payprop.com',
		authorization => PayProp::API::Public::Client::Authorization::ClientCredentials->new(
			secret => 's3cr3t123',
			client => 'PayProp',
			application_user_id => 123,
			domain => 'uk.payprop.com',
			storage => PayProp::API::Public::Client::Authorization::Storage::Memcached->new(
				servers => [ qw/ memcached:11211 / ],
				encryption_secret => 's3cr3t123',
				throw_on_storage_unavailable => 1,
			),
		),
	);

	-or-

	my $Client = PayProp::API::Public::Client->new(
		domain => 'uk.payprop.com',
		authorization => PayProp::API::Public::Client::Authorization::APIKey->new(
			token => 'API_KEY_HERE',
		),
	);

	------------------------------------------------------------------

	$Client
		->export
		->beneficiaries
		->list_p
		->then( sub {
			my ( $beneficiaries ) = @_;
			print "Items: " . scalar( $beneficiaries->@* ) . "\n";
		} )
		->catch( sub {
			my ( $Exception ) = @_;
			warn "$Exception";
		} )
		->wait
	;

=head1 DESCRIPTION

PayProp API client - this is the core module that *should* be used to access various
API requests as defined in C<PayProp::API::Public::Client::Request::*>.

=head1 AUTHOR

Yanga Kandeni E<lt>yangak@cpan.orgE<gt>

Valters Skrupskis E<lt>malishew@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2023- PayProp

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
