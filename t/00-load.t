#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok( 'Net::Twitter::Store' );
	use_ok( 'Net::Twitter::Store::Schema' );
}

diag( "Testing Net::Twitter::Store $Net::Twitter::Store::VERSION, Perl $], $^X" );
