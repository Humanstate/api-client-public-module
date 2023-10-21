#!/opt/tools/bin/perl

use strict;
use warnings;

use Test::Most;

use PayProp::API::Public::Client::Authorization::APIKey;


use_ok('PayProp::API::Public::Client::Request::Export');

isa_ok(
	my $ClientExport = PayProp::API::Public::Client::Request::Export->new(
		domain => 'mock.com',
		authorization => PayProp::API::Public::Client::Authorization::APIKey->new( token => 'AgencyAPIKey' )
	),
	'PayProp::API::Public::Client::Request::Export',
);

isa_ok(
	$ClientExport->beneficiaries,
	'PayProp::API::Public::Client::Request::Export::Beneficiaries',
);

done_testing;
