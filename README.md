# NAME

PayProp::API::Public::Client - PayProp API client.

## SYNOPSIS

### APIkey

```perl
use PayProp::API::Public::Client;
use PayProp::API::Public::Client::Authorization::APIKey;

my $Client = PayProp::API::Public::Client->new(
    scheme => 'https',
    domain => 'https://staging-api.payprop.com', # relevant PayProp API domain

    authorization => PayProp::API::Public::Client::Authorization::APIKey->new(
        token => 'API_KEY_HERE'
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
    domain => 'https://staging-api.payprop.com', # relevant PayProp API domain

    authorization => PayProp::API::Public::Client::Authorization::ClientCredentials->new(
        scheme => 'https',
        domain => 'https://staging-api.payprop.com', # use relevant PayProp API domain

        client => 'YourPayPropClientID',
        secret => 'your-payprop-oauth2-client-id-secret',
        application_user_id => '123',

        storage => PayProp::API::Public::Client::Authorization::Storage::Memcached->new(
        servers => [ qw/ memcached:11211 / ], # Required: List of memcached servers.
        encryption_secret => 'your-optional-encryption-key',
        throw_on_storage_unavailable => 1,
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

## Description

The PayProp API Public Module is a standalone module that will allow you to interact with the PayProp API, through a normalised interface. This interface abstracts authentication methods, request and response building and more.

It is the core module that *should* be used to access various API requests as defined in `PayProp::API::Public::Client::Request::`.


# AUTHOR & CONTRIBUTORS

Yanga Kandeni - `yangak@cpan.org`

Valters Skrupskis - `malishew@cpan.org`

# LICENSE

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. If you would like to contribute documentation
or file a bug report then please raise an issue / pull request:

```bash
https://github.com/Humanstate/api-client-public-module
```
