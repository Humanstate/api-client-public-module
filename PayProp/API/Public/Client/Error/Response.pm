package PayProp::API::Public::Client::Error::Response;

use strict;
use warnings;

use Mouse;

=head1 NAME

	PayProp::API::Public::Client::Error::Response - Response error.

=head1 SYNOPSIS

	PayProp::API::Public::Client::Error::Response->new(
		path => 'ERROR_PATH',
		message => 'ERROR_MESSAGE',
	);

=head1 DESCRIPTION

Construct C<PayProp::API::Public::Client::Error::Response> errors.

=cut

has path => ( is => 'ro', isa => 'Maybe[Str]' );
has message => ( is => 'ro', isa => 'Str' );

__PACKAGE__->meta->make_immutable;
