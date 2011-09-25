#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Wunderground::Api::Conditions' ) || print "Bail out!
";
}

diag( "Testing Wunderground::Api::Conditions $Wunderground::Api::Conditions::VERSION, Perl $], $^X" );
