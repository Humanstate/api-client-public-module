package PayProp::API::Public::Client::Exception::Response;
use parent qw/ PayProp::API::Public::Client::Exception::Base /;

use strict;
use warnings;

=head1 NAME

	PayProp::API::Public::Client::Exception::Response - Response exception.

=head1 SYNOPSIS

	PayProp::API::Public::Client::Exception::Response->throw(
		status_code => 500,
		errors => [
			path => '/error/path',
			message => 'Error description.',
		],
	);

=head1 DESCRIPTION

Throw C<PayProp::API::Public::Client::Exception::Response> exception.

=cut

sub error_class { 'PayProp::API::Public::Client::Error::Response' }
sub error_fields { qw/ path message / }

1;
