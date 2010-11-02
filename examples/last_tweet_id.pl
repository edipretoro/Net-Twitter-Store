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

GetOptions( $config, "database=s", "help" ) or pod2usage(2);

pod2usage(1) if $config->{help};
pod2usage(1) if not exists $config->{database};

my $deploy = -e $config->{database} ? 0 : 1;

my $cage = Net::Twitter::Store->new(
    dsn    => 'dbi:SQLite:' . $config->{database},
    deploy => $deploy,
);

print $cage->last_tweet_id(), $/;

__END__

=pod

=head1 NAME

store.pl - Store your valuable tweets and your friends' timeline

=head1 SYNOPSIS

timeline.pl --database tweets.sqlite --credentials twitter_keys [--help]

=cut

