#!/usr/bin/env perl

use strict;
use warnings;

use Net::Twitter;
use Net::Twitter::Store;
use Getopt::Long;
use Storable;
use Pod::Usage;
use Data::Dump;

my $config =
  { credentials => File::Spec->catfile( $ENV{HOME}, '.twitter_credentials' ), };

GetOptions( $config, "credentials=s", "database=s", "help" ) or pod2usage(2);

pod2usage(1) if $config->{help};
pod2usage(1) if not exists $config->{database};

my $deploy = -e $config->{database} ? 0 : 1;

my $cage = Net::Twitter::Store->new(
    dsn    => 'dbi:SQLite:' . $config->{database},
    deploy => $deploy,
);

my %credentials = %{ retrieve( $config->{credentials} ) };

my $bird = Net::Twitter->new( traits => [qw( API::REST OAuth )], %credentials );

foreach my $page ( 1 .. 5 ) {
    eval {
        my $statuses =
          $bird->friends_timeline( { count => 200, page => $page, since_id => $cage->last_tweet_id } );
        if (scalar(@$statuses) < 200) {
            $page = 6;
        }

        for my $status (@$statuses) {
            $cage->store($status);
        }
    };
    if ( my $err = $@ ) {
        die $@ unless blessed $err && $err->isa('Net::Twitter::Error');

        warn "HTTP Response Code: ", $err->code, "\n",
          "HTTP Message......: ", $err->message, "\n",
          "Twitter error.....: ", $err->error,   "\n";
    }
}

print "We have now ", $cage->tweets_total, " tweets. Enjoy!!!", $/;

__END__

=pod

=head1 NAME

store.pl - Store your valuable tweets and your friends' timeline

=head1 SYNOPSIS

timeline.pl --database tweets.sqlite --credentials twitter_keys [--help]

=cut

