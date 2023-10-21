#!/usr/bin/env perl

use strict;
use warnings;

use Test::Most;

use Test::Emulator;

use PayProp::API::Public::Client::Authorization::APIKey;
use PayProp::API::Public::Client::Authorization::ClientCredentials;


my $SCHEME = 'http';
my $EMULATOR_HOST = '127.0.0.1';

my $Emulator = Test::Emulator->new(
	scheme => $SCHEME,
	host => $EMULATOR_HOST,
	exec => 'payprop_api_public_client_emulator.pl',
);


use_ok('PayProp::API::Public::Client');

isa_ok(
	my $APIKeyClient = PayProp::API::Public::Client->new(
		scheme => $SCHEME,
		domain => $Emulator->url,
		authorization => PayProp::API::Public::Client::Authorization::APIKey->new( token => 'AgencyAPIKey' )
	),
	'PayProp::API::Public::Client',
	'PayProp::API::Public::Client via PayProp::API::Public::Client::Authorization::APIKey'
);

isa_ok(
	my $ClientCredentialsClient = PayProp::API::Public::Client->new(
		scheme => $SCHEME,
		domain => $Emulator->url,
		authorization => PayProp::API::Public::Client::Authorization::ClientCredentials->new(
			secret => 'test',
			scheme => $SCHEME,
			domain => $Emulator->url,
			client => 'AnotherTestClient',
			application_user_id => 908863,
		),
	),
	'PayProp::API::Public::Client',
	'PayProp::API::Public::Client via PayProp::API::Public::Client::Authorization::ClientCredentials'
);


subtest 'exports' => sub {

	$Emulator->start;

	foreach my $Client ( $APIKeyClient, $ClientCredentialsClient ) {
		my $Export = $Client->export;

		subtest 'beneficiaries' => sub {

			isa_ok(
				my $Beneficiaries = $Export->beneficiaries,
				'PayProp::API::Public::Client::Request::Export::Beneficiaries'
			);

			$Beneficiaries
				->list_p
				->then( sub {
					my ( $beneficiaries ) = @_;

					is scalar $beneficiaries->@*, 2;
					isa_ok( $_, 'PayProp::API::Public::Client::Response::Export::Beneficiary' )
						for $beneficiaries->@*
					;
				} )
				->wait
			;

		};
	}

	$Emulator->stop;

};

done_testing;
