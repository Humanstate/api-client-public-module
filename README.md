# PayProp API Public Module

The PayProp API Public Module is a standalone module that will allow you to interact with the PayProp API, through a normalised interface. This interface abstracts authentication methods, request and response building and more.

## Setup and running

The interface requires a couple of CPAN modules.

### Install necessary perl modules

Note if you are not using the system perl you shouldn't need to prefix the two commands below with `sudo`.

```bash
sudo cpan App::cpanminus # if you do not already have cpanm installed
sudo cpanm --installdeps .
```

### Run via APIkey

```perl
use PayProp::API::Public::Client;
use PayProp::API::Public::Client::Authorization::APIKey;

my $Client = PayProp::API::Public::Client->new(
    scheme => 'https',
    domain => 'https://staging-api.payprop.com', # use relevant PayProp API domain

    authorization => PayProp::API::Public::Client::Authorization::APIKey->new(
        token => 'MTY5ODA5NTE5My01V3ghXDowcHdFa2k3SVprc3hhblUnYWIuOi9VZSlCag=='
    ),
);

# export beneficiaries example
my $Export = $Client->export;
my $Beneficiaries = $Export->beneficiaries;

$Beneficiaries
    ->list_p
    ->then( sub {
        my ( $beneficiaries ) = @_;
        # TODO: do something with list of PayProp::API::Public::Client::Response::Export::Beneficiary objects
    } )
    ->wait
;
```

### Run via OAuth v2.0 Client (access token)

```perl
use PayProp::API::Public::Client;
use PayProp::API::Public::Client::Authorization::ClientCredentials;
use PayProp::API::Public::Client::Authorization::Storage::Memcached;

my $Client = PayProp::API::Public::Client->new(
    scheme => 'https',
    domain => 'https://staging-api.payprop.com', # use relevant PayProp API domain

    authorization => PayProp::API::Public::Client::Authorization::ClientCredentials->new(
        scheme => 'https',
        domain => 'https://staging-api.payprop.com', # use relevant PayProp API domain

        client => 'YourPayPropAuth2ClientID',
        secret => 'your-payprop-oauth2-client-id-secret',
        application_user_id => 'application-user-id-of-the-agency-or-agent',

        storage => PayProp::API::Public::Client::Authorization::Storage::Memcached->new(
        servers => [ qw/ 127.0.0.1:11211 / ], # Required: List of memcached servers.
        encryption_secret => 'your-optional-encryption-key',
    ),
 ),
);

# export beneficiaries example
my $Export = $Client->export;
my $Beneficiaries = $Export->beneficiaries;

$Beneficiaries
    ->list_p
    ->then( sub {
        my ( $beneficiaries ) = @_;
        # TODO: do something with list of PayProp::API::Public::Client::Response::Export::Beneficiary objects
    } )
    ->wait
;
```
