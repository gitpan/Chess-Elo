package Chess::Elo;

use 5.008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Chess::Elo ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	elo
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


# Preloaded methods go here.

our $factor  = 32;
our $divisor = 400;

sub elo {
  
  my ($A, $result, $B) = @_;

  my $Aexp = 10 ** ( ($B - $A) / $divisor ) ;
  

  my $A2 = 
    $A + $factor * ( $result - 
		     ( 1 / 
		       ( 1 + $Aexp )
		     )
		   )
      ;

  my $Bexp = 10 ** ( ($A - $B) / $divisor ) ;
  
  $result = 1 - $result;

  my $B2 = 
    $B + $factor * ( $result - 
		     ( 1 / 
		       ( 1 + $Bexp )
		     )
		   )
      ;

  ($A2, $B2)
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Chess::Elo - Perl module to calculate Chess "Elo" ratings

=head1 SYNOPSIS

  use Chess::Elo qw(:all);

  my ($alice,      $bob)   = (2100, 1200);
  my $result = 0; # alice lost to bob.. 0.5 == A draw B , 1 == A beat B
  my @alice_bob            = elo_rating ($alice, 0, $bob);
  use Data::Dumper; warn Dumper(\@alice_bob);

  # My, Alice took a hit on her rating :)
  # Bob is setting pretty 
  [
          '2068.17894295388',
          '1231.82105704612'
  ];
             

=head1 DESCRIPTION

This module provides a single function, C<elo> which allows one
to calculate individual ratings based on performance. Typically, a
player
is given an initial provisional rating of 1600 points. 
In all cases, one gains and loses
points as a function of the playing strength of both parties and the result
of their encounter.

The formula used is the same one used at magi-nation:

    http://www.magi-nation.com/Tournaments/ratingsfaq.htm

Or, quantitatively speaking:

    A2 = A1 + 32 (  G - ( 1 / ( 1 + 10 ** ( ( B1 -A1) / 400 ) ) ) )

=over 

=item A2 is Alice's post-game rating

=item A1 is Alice rating before the game against Bob

=item B1 is Bobs rating before the game against Alice

=item G is the game result, in this case:

              1, if A beats B

              0, if A loses to B

              0.5, if A draws to B

=back

=head1 METHODS

=head2 ($newA, $newB) = elo ( $current_elo_A, $result, $current_elo_B)

This function takes 3 arguments describing the result of a person with 
rating A competing with the person with rating B. The result argument
is from the perspective of person A, thus if A won $result is 1. If A
lost, $result is 0. If A drew, $result is 0.5;

=head2 EXPORT

None by default, C<elo> upon request.


=head1 SEE ALSO

=over

=item * The Perl Chess Mailing List:

L<http://www.yahoogroups.com/group/perl-chess>

=item * Wikipedia discussion on the Elo rating:

L<http://en.wikipedia.org/wiki/Elo_rating>

One part of this discussion deserves repetition:

 # 113 players have a rating of 2600 or above.
 # 16 players have a rating of 2700 or above.
 # 1 player (Garry Kasparov) has a rating of 2800 or above.

=item * Soccer teams rated by Elo:

L<http://www.eloratings.net>

=back

=head1 AUTHOR

Terrence Brannon, tbone@cpan.org

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Terrence Brannon

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
