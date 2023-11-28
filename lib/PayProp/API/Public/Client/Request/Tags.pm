package PayProp::API::Public::Client::Request::Tags;

use strict;
use warnings;

use Mouse;
with qw/ PayProp::API::Public::Client::Role::APIRequest /;

use PayProp::API::Public::Client::Response::Tag;


has '+url' => (
	default => sub {
		my ( $self ) = @_;
		return $self->abs_domain . '/api/agency/' . $self->api_version . '/tags';
	},
);

sub list_p {
	my ( $self, $args ) = @_;

	$args //= {};
	my $params = $args->{params};

	return $self
		->api_request_p({
			params => $params,
			handle_response_cb => sub { $self->_get_tags( @_ ) },
		})
	;
}

sub create_p {
	my ( $self, $args ) = @_;

	$args //= {};
	my $content = $args->{content};

	return $self
		->api_request_p({
			method => 'POST',
			content => { json => $content },
			handle_response_cb => sub { $self->_get_tags( @_ ) },
		})
	;
}

sub link_entities_p {
	my ( $self, $args ) = @_;

	$args //= {};
	my $content = $args->{content};
	my $path_params = $args->{path_params} // {};

	$path_params->{fragment} = 'entities';
	$self->ordered_path_params([qw/ fragment entity_type entity_id /]);

	return $self
		->api_request_p({
			method => 'POST',
			path_params => $path_params,
			content => { json => $content },
			handle_response_cb => sub { $self->_get_tags( @_ ) },
		})
	;
}

sub list_tagged_entities_p {
	my ( $self, $args ) = @_;

	$args //= {};
	my $params = $args->{params};
	my $path_params = $args->{path_params} // {};

	$path_params->{fragment} = 'entities';
	$self->ordered_path_params([qw/ external_id fragment /]);

	return $self
		->api_request_p({
			method => 'GET',
			params => $params,
			path_params => $path_params,
			handle_response_cb => sub { $self->_get_tags( @_ ) },
		})
	;
}

sub update_p {
	my ( $self, $args ) = @_;

	$args //= {};
	my $req_content = $args->{content};
	my $path_params = $args->{path_params} // {};

	$self->ordered_path_params([qw/ external_id /]);

	return $self
		->api_request_p({
			method => 'PUT',
			path_params => $path_params,
			content => { json => $req_content },
			handle_response_cb => sub { $self->_get_tags( @_ ) },
		})
	;
}

sub delete_p {
	my ( $self, $args ) = @_;

	$args //= {};
	my $path_params = $args->{path_params} // {};

	$self->ordered_path_params([qw/ external_id /]);

	return $self
		->api_request_p({
			method => 'DELETE',
			path_params => $path_params,
			handle_response_cb => sub { $self->_get_tags( @_ ) },
		})
	;
}

sub delete_entity_link_p {
	my ( $self, $args ) = @_;

	$args //= {};
	my $params = $args->{params};
	my $path_params = $args->{path_params} // {};

	$path_params->{fragment} = 'entities';
	$self->ordered_path_params([qw/ external_id fragment /]);

	return $self
		->api_request_p({
			params => $params,
			method => 'DELETE',
			path_params => $path_params,
			handle_response_cb => sub { $self->_get_tags( @_ ) },
		})
	;
}

sub _get_tags {
	my ( $self, $response_json ) = @_;

	return $response_json if $response_json->{message};

	my $want_array = ref $response_json->{items} ? 1 : 0;

	return PayProp::API::Public::Client::Response::Tag->new(
		id => $response_json->{id},
		name => $response_json->{name},
	) unless $want_array;

	my @tags;
	for my $tag ( @{ $response_json->{items} // [] } ) {
		my $Tag = PayProp::API::Public::Client::Response::Tag->new(
			id => $tag->{id},
			name => $tag->{name},

			( $tag->{type} ? ( type => $tag->{type} ) : () ),
			( $tag->{links} ? ( links => $tag->{links} ) : () ),
		);

		push( @tags, $Tag );
	}

	return \@tags;
}

__PACKAGE__->meta->make_immutable;
