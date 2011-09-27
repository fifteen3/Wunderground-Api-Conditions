#!/usr/bin/perl
#
# Wunderground::Api::Conditions tests
#
use strict;
use warnings;

use Test::More 'no_plan';
use Test::MockObject;
use Test::Exception;
use JSON::PP;
use Data::Dumper;

BEGIN {
    use_ok ( 'Wunderground::Api::Conditions');
}
my $json = JSON::PP->new();
my $mock = Test::MockObject->new();
my $mockApiRes = Test::MockObject->new();
my $mockResponse;

#load a fake response for mocking api call
{
    local $/ = undef;
    open ( my $fh , "<:utf8", "t/mock_response.json" ) or die $!;
    $mockResponse = <$fh>;
    close($fh);
}

#a mock response from the api
$mockApiRes->mock( 'decoded_content' => sub { $mockResponse } );
$mockApiRes->mock( 'is_success' => sub { return 1; }  );
$mock->mock( 'get' => sub { return $mockApiRes; } );

#Test that correct data structure is returned based on mocked response from API
{
    my $config = { key => 'foo', location => 'St. Catharines, ON', ua => $mock};
    my $weather_conditions = Wunderground::Api::Conditions->new($config) ;
    is ( $weather_conditions->location, "St. Catharines, ON", "the location is set" );
    is_deeply( $weather_conditions->current_conditions,
               $json->decode($mockResponse)->{'current_observation'},
               'the current obversation is returned as a hash' );
}

#Test that when a failed response is returned from the api that undef is returned
{
    my $config = { key => 'foo', location => 'St. Catharines, ON', ua => $mock};
    my $weather_conditions = Wunderground::Api::Conditions->new($config) ;
    $mockApiRes->mock( 'is_success' => sub { return 0; }  );
    is( $weather_conditions->current_conditions, undef, 'undef is returned when the api fails to respond');

}

#Test that key is not set function dies
{
    my $wc2 = Wunderground::Api::Conditions->new( key => 'foo' );
    dies_ok { $wc2->current_conditions; }  'current_conditions dies when location is not set';
}

#Test that key is not set function dies
{
    my $wc3 = Wunderground::Api::Conditions->new( location => 'foo' );
    dies_ok { $wc3->current_conditions; }  'current_conditions dies when key is not set';
}
