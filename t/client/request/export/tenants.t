#!perl

use strict;
use warnings;

use JSON::PP;
use Test::Most;
use Test::Emulator;

use PayProp::API::Public::Client::Authorization::APIKey;


use_ok('PayProp::API::Public::Client::Request::Export::Tenants');

my $SCHEME = 'http';
my $EMULATOR_HOST = '127.0.0.1';

my $Emulator = Test::Emulator->new(
	scheme => 'http',
	exec => 'payprop_api_client.pl',
	host => $EMULATOR_HOST,
);

isa_ok(
	my $ExportTenants = PayProp::API::Public::Client::Request::Export::Tenants->new(
		scheme => $SCHEME,
		api_version => 'v1.1',
		domain => $Emulator->url,
		authorization => PayProp::API::Public::Client::Authorization::APIKey->new( token => 'AgencyAPIKey' ),
	),
	'PayProp::API::Public::Client::Request::Export::Tenants'
);

is $ExportTenants->url, $Emulator->url . '/api/agency/v1.1/export/tenants', 'Got expected ExportTenants URL';

subtest '->list_p' => sub {

	$Emulator->start;

	$ExportTenants
		->list_p
		->then( sub {
			my ( $tenants, $optional ) = @_;

			is scalar $tenants->@*, 25;
			isa_ok( $tenants->[0], 'PayProp::API::Public::Client::Response::Export::Tenant' );

			cmp_deeply
				$optional,
				{
					pagination => {
						rows => 25,
						page => 1,
						total_pages => 1,
						total_rows => 25,
					}
				},
				'optional args'
			;

		} )
		->wait
	;

	$Emulator->stop;

};

subtest '->_query_params' => sub {

	cmp_deeply
		$ExportTenants->_query_params,
		[
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
		]
	;

};

done_testing;
