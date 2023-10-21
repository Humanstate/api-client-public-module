# https://metacpan.org/pod/distribution/Module-CPANfile/lib/cpanfile.pod

requires 'Cache::Memcached';
requires 'Crypt::CBC';
requires 'MIME::Base64';
requires 'Module::Load';
requires 'Mojo::Promise';
requires 'Mojo::URL';
requires 'Mojo::UserAgent';
requires 'Mojolicious';
requires 'Mouse';
requires 'Mouse::Role';
requires 'Mouse::Util::TypeConstraints';
requires 'parent';
requires 'strict';
requires 'warnings';

on test => sub {
    requires 'JSON::PP';
    requires 'Test::Emulator';
    requires 'Test::Most';
};
