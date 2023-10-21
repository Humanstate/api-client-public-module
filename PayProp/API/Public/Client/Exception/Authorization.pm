package PayProp::API::Public::Client::Exception::Authorization;
use parent qw/ PayProp::API::Public::Client::Exception::Base /;

use strict;
use warnings;

=head1 NAME

	PayProp::API::Public::Client::Exception::Authorization - Authorization exception.

=head1 SYNOPSIS

	PayProp::API::Public::Client::Exception::Authorization->throw(
		status_code => 500,
		errors => [
			code => 'client_credentials',
			message => 'Bad client credentials',
		],
	);

=head1 DESCRIPTION

Throw C<PayProp::API::Public::Client::Exception::Authorization> exception.

=cut

sub error_class { 'PayProp::API::Public::Client::Error::Authorization' }
sub error_fields { qw/ code message / }

1;
