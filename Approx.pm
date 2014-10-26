package Tie::Hash::Approx;
use strict;
use vars qw($VERSION @ISA);

require Exporter;
require Tie::Hash;

use String::Approx('amatch');

@ISA     = qw(Exporter Tie::StdHash);
$VERSION = '0.02';

=pod

=begin testing

  use Tie::Hash::Approx;
  my %hash;
  my $x = tie %hash, 'Tie::Hash::Approx';

  ok( ref $x eq 'Tie::Hash::Approx', "tie'ing hash to Tie::Hash::Approx"); 

=end testing

=cut

sub FETCH {
    my $this = shift;
    my $key  = shift;

    return undef unless %{$this}; # return if the hash is empty

    # We return immediatly if an exact match is found
    return $this->{$key} if exists $this->{$key};

    # Otherwise, the fuzzy search kicks in
    my @results = amatch( $key, keys( %{$this} ) );


    # wantarray doesn't work on tied hash, unless
    # you're using a "tied(%hash)->FETCH('foo');"
    # construct
    if (wantarray) {
       return @{$this}{@results};
    }
    else {
      return $this->{ $results[0] };
    }
}

=pod

=begin testing

  %hash = (
    key  => 'value',
    kay  => 'another value',
    stuff => 'yet another stuff',
  );

  ok( $hash{key} eq 'value', 'exact match' );
  ok( $hash{staff} eq 'yet another stuff', 'approx match' );

=end testing

=begin testing

  @res{ tied(%hash)->FETCH('koy') }++;

  ok( exists($res{'value'}) && exists($res{'another value'}), 'wantarray approx match' );

=end testing

=cut

sub EXISTS {
    my $this = shift;
    my $key  = shift;

    return undef unless %{$this};

    return 1 if exists $this->{$key};
    return if amatch( $key, keys( %{$this} ) );
}

=pod

=begin testing

  ok( exists($hash{'key'}), 'exists exact match' );
  ok( exists($hash{'staff'}), 'exists approx match' );
  ok( !exists($hash{''}), 'exists empty match' );

=end testing

=cut

sub DELETE {
    my $this = shift;
    my $key  = shift;

    return delete $this->{$key} if exists $this->{$key};
    my @results = amatch( $key, keys( %{$this} ) );

    # This will delete *all* the keys matching! 
    delete @{$this}{ @results };
}

=pod

=begin testing

 delete $hash{koy};
 ok( !exists($hash{'key'}) && !exists($hash{'kay'}), 'deleting several approx matches');

 delete $hash{staff};
 ok( !exists($hash{'staff'}), 'deleting approx match');

=end testing

=cut

1;

__END__

=head1 NAME

Tie::Hash::Approx - Approximative match of hash keys using String::Approx

=head1 SYNOPSIS

  use Tie::Hash::Approx;

  my %hash;
  tie %hash, 'Tie::Hash::Approx';

  %hash = (
    key  => 'value',
    kay  => 'another value',
    stuff => 'yet another stuff',
  );

  print $hash{'key'};  # prints 'value'
  print $hash{'koy'};  # prints 'another value' or 'value'
  print $hash{'staff'}; # prints 'yet another stuff'

  print tied(%hash)->FETCH('koy'); # prints 'value' and 'another value'

  delete $hash{kee};   # deletes $h{key} and $h{kay}

=head1 DESCRIPTION

Following the idea of L<Tie::Hash::Regex>, this module is an attempt to
make fuzzy matches on hash keys. The module first tries to fetch the
exact key of the hash, and failing that, the key is passed to the
L<String::Approx>' C<amatch> function. Note that you can't (yet) pass
modifiers to C<amatch>.

To fetch multiple matching keys, you'll have to use something like:

 @all_matches = tied(%h)->FETCH('the key');

Note also the deleting a hash key will delete I<all> the approximate
matches, unless you provide the exact match of the key.

=head1 TODO

Specify the "fuzziness" of the match (cf. the modifiers option in String::Approx).

=head1 AUTHOR

Briac Pilpre < briac @ pilpre . com >

Thanks to Dave Cross for making Tie::Hash::Regex in the first place!

=head1 COPYRIGHT

Copyright 2001, Briac Pilpr�. All Rights Reserved. This module can
be redistributed under the same terms as Perl itself.

=head1 SEE ALSO

perl(1). perltie(1). Tie::Hash. String::Approx

=cut



