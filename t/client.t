#!/opt/tools/bin/perl

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
	exec => 'payprop_api_client.pl',
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

subtest 'entity' => sub {

	$Emulator->start;

	foreach my $Client ( $APIKeyClient, $ClientCredentialsClient ) {
		my $Entity = $Client->entity;

		subtest 'payment' => sub {

			isa_ok(
				my $Payment = $Entity->payment,
				'PayProp::API::Public::Client::Request::Entity::Payment'
			);

			subtest 'READ' => sub {

				subtest 'without query params' => sub {

					$Payment
						->list_p({ path_params => { external_id => 'MZnW5oLYJ7' } })
						->then( sub {
							my ( $RetrievedPayment ) = @_;

							is $RetrievedPayment->id, 'MZnW5oLYJ7';
							isa_ok( $RetrievedPayment, 'PayProp::API::Public::Client::Response::Entity::Payment' );
						} )
						->wait
					;
				};

				subtest '?is_customer_id' => sub {

					$Payment
						->list_p({ is_customer_id => 'PaymentCustomerID', path_params => { external_id => 'MZnW5oLYJ7' } })
						->then( sub {
							my ( $Payment ) = @_;

							is $Payment->customer_id, 'PaymentCustomerID';
							isa_ok( $Payment, 'PayProp::API::Public::Client::Response::Entity::Payment' );
						} )
						->wait
					;
				};
			};

			subtest 'CREATE' => sub {

				my $data = {
					"amount" => 850.0,
					"frequency" => "M",
					"start_date" => "2022-04-08",
					"category_id" => "Vv2XlY1ema",
					"property_id" => "mGX0O4zrJ3",
					"use_money_from" => "any_tenant",
					"beneficiary_id" => "B6XK97WwZW",
					"beneficiary_type" => "beneficiary",
					"reference" => "sed suscipit explicabo",
				};

				$Payment
					->create_p( $data )
					->then( sub {
						my ( $CreatedPayment ) = @_;

						is $CreatedPayment->id, 'nZ3YqdvzXN';
						isa_ok( $CreatedPayment, 'PayProp::API::Public::Client::Response::Entity::Payment' );
					} )
					->wait
				;
			};

			subtest 'UPDATE' => sub {

				my $data = {
					"amount" => 850.0,
				};

				subtest 'without query params' => sub {

					$Payment
						->update_p( { path_params => { external_id => 'MZnW5oLYJ7' } }, $data )
						->then( sub {
							my ( $UpdatedPayment ) = @_;
							isa_ok( $UpdatedPayment, 'PayProp::API::Public::Client::Response::Entity::Payment' );
						} )
						->wait
					;
				};

				subtest '?is_customer_id' => sub {

					$Payment
						->update_p(
							{
								is_customer_id => 'PaymentCustomerID',
								path_params => { external_id => 'MZnW5oLYJ7' }
							},
							$data,
						)
						->then( sub {
							my ( $UpdatedPayment ) = @_;
							isa_ok( $UpdatedPayment, 'PayProp::API::Public::Client::Response::Entity::Payment' );
						} )
						->wait
					;
				};
			};
		};
	}

	$Emulator->stop;

};

done_testing;
