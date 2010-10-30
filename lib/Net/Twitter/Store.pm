package Net::Twitter::Store;

use warnings;
use strict;
use Net::Twitter::Store::Schema;

=head1 NAME

Net::Twitter::Store - Store your valuable tweets

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Net::Twitter::Store;

    my $cage = Net::Twitter::Store->new(
      dsn => 'dbi:SQLite:my_tweets.sqlite', # get a valid dsn
      deploy => 1, # ask Net::Twitter::Store to deploy the schema in the database
    );

    $cage->store( $tweet );

=head1 FUNCTIONS

=head2 new

=cut

sub new {
    my ( $class, %args ) = @_;

    my $self   = {};
    my $schema = Net::Twitter::Store::Schema->connect( $args{dsn} );
    $schema->deploy() if $args{deploy};
    $self->{schema} = $schema;
    bless $self, $class;
    return $self;
}

=head2 store

=cut

sub store {
    my ( $self, $tweet ) = @_;

    eval {
        $self->{schema}->txn_do(
            sub {
                my $saved_tweet =
                  $self->{schema}->resultset('Document')
                  ->find_or_create(
                    { type => 'tweet', 'name' => $tweet->{id} } );
                $saved_tweet->insert;

                foreach my $key ( keys %{$tweet} ) {
                    next if $key eq 'id';
                    if ($tweet->{$key}) {
                        my $prop =
                            $self->{schema}->resultset('Property')->find_or_create(
                                {
                                    'property'    => $key,
                                    'value'       => $tweet->{$key},
                                    'document_id' => $saved_tweet->id,
                                }
                            );
                        $prop->insert;
                    }
                }
            }
        );
    };

    if ($@) {
        # i've got a problem
    }
    else {
        # okido
    }

}

=head1 AUTHOR

Emmanuel Di Pretoro, C<< <edipretoro at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-twitter-store at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-Twitter-Store>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Twitter::Store


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-Twitter-Store>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-Twitter-Store>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-Twitter-Store>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-Twitter-Store>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Emmanuel Di Pretoro, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;    # End of Net::Twitter::Store
