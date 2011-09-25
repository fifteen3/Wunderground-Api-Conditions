#!/usr/bin/perl
#
# Wunderground::Api::Conditions tests
use strict;
use warnings;

use Test::More 'no_plan';
use Test::MockObject;
use JSON::PP;
use Data::Dumper;

BEGIN {
	use_ok ( 'Wunderground::Api::Conditions');
}
my $json = JSON::PP->new();
my $mock = Test::MockObject->new();
my $mockApiRes = Test::MockObject->new();
my $mockResponse;
{
	local $/ = undef;
	open ( my $fh , "<:utf8", "t/mock_response.json" ) or die $!; 
	$mockResponse = <$fh>;
	close($fh);
}
#a mock response from the api
$mockApiRes->mock( 'decoded_content' => sub { $mockResponse } );
$mock->mock( 'get' => sub { return $mockApiRes; } );
my $config = { key => '5592aba6028d7a8e', location => 'St. Catharines, ON', ua => $mock};
my $weather_conditions = Wunderground::Api::Conditions->new($config) ;
is ($weather_conditions->location, "St. Catharines, ON", "the location is set");
is_deeply($weather_conditions->current_conditions, $json->decode($mockResponse)->{'current_observation'}, 'the current obversation is returned as a hash' );
