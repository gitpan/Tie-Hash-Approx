#!/usr/bin/perl -w

use Test::More no_plan;

package Catch;

sub TIEHANDLE {
    my($class) = shift;
    return bless {}, $class;
}

sub PRINT  {
    my($self) = shift;
    $main::_STDOUT_ .= join '', @_;
}

sub READ {}
sub READLINE {}
sub GETC {}

package main;

local $SIG{__WARN__} = sub { $_STDERR_ .= join '', @_ };
tie *STDOUT, 'Catch' or die $!;


#line 16 Approx.pm

  use Tie::Hash::Approx;
  my %hash;
  my $x = tie %hash, 'Tie::Hash::Approx';

  ok( ref $x eq 'Tie::Hash::Approx', "tie'ing hash to Tie::Hash::Approx"); 



#line 52 Approx.pm

  %hash = (
    key  => 'value',
    kay  => 'another value',
    stuff => 'yet another stuff',
  );

  ok( $hash{key} eq 'value', 'exact match' );
  ok( $hash{staff} eq 'yet another stuff', 'approx match' );


  @res{ tied(%hash)->FETCH('koy') }++;

  ok( exists($res{'value'}) && exists($res{'another value'}), 'wantarray approx match' );



#line 85 Approx.pm

  ok( exists($hash{'key'}), 'exists exact match' );
  ok( exists($hash{'staff'}), 'exists approx match' );
  ok( !exists($hash{''}), 'exists empty match' );



#line 106 Approx.pm

 delete $hash{koy};
 ok( !exists($hash{'key'}) && !exists($hash{'kay'}), 'deleting several approx matches');

 delete $hash{staff};
 ok( !exists($hash{'staff'}), 'deleting approx match');



