#!/usr/bin/env perl

use strict;
use warnings;

use Net::Twitter;
use Net::Twitter::Store;
use Getopt::Long;

my $config = {};

GetOptions( $config, "database=s", "query=s" );

die _usage() unless _valid($config);

my $deploy = -e $config->{database} ? 1 : 0;

my $cage = Net::Twitter::Store->new(
    dsn    => 'dbi:SQLite:' . $config->{database},
    deploy => $deploy,
);

my $bird = Net::Twitter->new( traits => [qw( API::Search )] );
$bird->username('login');
$bird->password('password');

my $count = 0;
foreach my $page ( 1 .. 15 ) {
    my $tweets =
      $bird->search( { q => $config->{query}, rpp => 100, page => $page } );
    next unless scalar( @{ $tweets->{results} } ) > 0;

    foreach my $tweet ( @{ $tweets->{results} } ) {
        $cage->store($tweet);
    }

    $count += scalar( @{ $tweets->{results} } );
}

print 'Finished: ', $count, ' tweets processed', $/;

sub _usage {
    return "Usage: $0 --database db.sqlite --query '#yapc2010'\n";
}

sub _valid {
    my $config = shift;

    if ( exists $config->{database} and exists $config->{query} ) {
        return 1;
    }
    else {
        return 0;
    }
}
