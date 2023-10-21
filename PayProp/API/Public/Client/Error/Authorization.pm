package PayProp::API::Public::Client::Error::Authorization;

use strict;
use warnings;

use Mouse;

=head1 NAME

	PayProp::API::Public::Client::Error::Authorization - Authorization error.

=head1 SYNOPSIS

	PayProp::API::Public::Client::Error::Authorization->new(
		code => 'ERROR_CODE',
		message => 'ERROR_MESSAGE',
	);

=head1 DESCRIPTION

Construct C<PayProp::API::Public::Client::Error::Authorization> errors.

=cut

has code => ( is => 'ro', isa => 'Maybe[Str]' );
has message => ( is => 'ro', isa => 'Str' );

__PACKAGE__->meta->make_immutable;
