package Test::Flatten;

use strict;
use warnings;
use Test::More ();
use Test::Builder ();
use Term::ANSIColor qw(colored);

our $VERSION = '0.03';

our $BORDER_COLOR  = [qw|cyan bold|];
our $BORDER_CHAR   = '-';
our $BORDER_LENGTH = 78;
our $CAPTION_COLOR = ['clear'];

our $ORG_SUBTEST = Test::More->can('subtest');

$ENV{ANSI_COLORS_DISABLED} = 1 if $^O eq 'MSWin32';

sub import {
    my $class = caller(0);
    no warnings 'redefine';
    no strict 'refs';
    *{"$class\::subtest"} = \&subtest;
    *Test::More::subtest = \&subtest;
}

sub builder { Test::More->builder }

sub subtest {
    my ($caption, $test) = @_;

    unless (ref $test eq 'CODE') {
        builder->croak("subtest()'s second argument must be a code ref");
    }

    builder->note(colored $BORDER_COLOR, $BORDER_CHAR x $BORDER_LENGTH);
    builder->note(colored $CAPTION_COLOR, $caption);
    builder->note(colored $BORDER_COLOR, $BORDER_CHAR x $BORDER_LENGTH);

    no warnings 'redefine';
    no strict 'refs';
    local *{ref(builder).'::done_testing'} = sub {}; # temporary disabled
    local $Test::Builder::Level = $Test::Builder::Level + 2;
    $test->();
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Test::Flatten - subtest output to a flatten

=head1 SYNOPSIS

in t/foo.t

  use Test::More;
  use Test::Flatten;

  subtest 'foo' => sub {
      pass 'OK';
  };
  
  subtest 'bar' => sub {
      pass 'ok';
      subtest 'baz' => sub {
          pass 'ok';
      };
  };

  done_testing;

run it

  $ prove -lvc t/foo.t
  t/foo.t .. 
  # ------------------------------------------------------------------------------
  # foo
  # ------------------------------------------------------------------------------
  ok 1 - ok
  # ------------------------------------------------------------------------------
  # bar
  # ------------------------------------------------------------------------------
  ok 2 - ok
  # ------------------------------------------------------------------------------
  # baz
  # ------------------------------------------------------------------------------
  ok 3 - ok
  1..3
  ok

oh, flatten!

=head1 DESCRIPTION

Test::Flatten is override Test::More::subtest.

The subtest I think there are some problems.

=over

=item 1. Caption is appears at end of subtest block.

  use Test::More;

  subtest 'foo' => sub {
      pass 'ok';
  };

  done_testing;

  # ok 1 - foo is end of subtest block.
  t/foo.t .. 
      ok 1 - ok
      1..1
  ok 1 - foo
  1..1
  ok

I want B<< FIRST >>.

=item 2. Summarizes the test would count.

  use Test::More;

  subtest 'foo' => sub {
      pass 'bar';
      pass 'baz';
  };

  done_testing;

  # total tests is 1
  t/foo.t .. 
      ok 1 - bar
      ok 2 - baz
      1..2
  ok 1 - foo
  1..1

I want B<< 2 >>.

=item 3. Forked test output will be broken. (Even with Test::SharedFork!)

  use Test::More;
  
  subtest 'foo' => sub {
      pass 'parent one';
      pass 'parent two';
      my $pid = fork;
      unless ($pid) {
          pass 'child one';
          pass 'child two';
          fail 'child three';
          exit;
      }
      wait;
      pass 'parent three';
  };
  
  done_testing;

  # success...?
  t/foo.t .. 
      ok 1 - parent one
      ok 2 - parent two
      ok 3 - child one
      ok 4 - child two
      not ok 5 - child three
      
      #   Failed test 'child three'
      #   at t/foo.t line 13.
      ok 3 - parent three
      1..3
  ok 1 - foo
  1..1
  ok

oh, really? I want B<< FAIL >> and sync count.

=back

Yes, We can!!

=head1 FUNCTIONS 

=over

=item C<< subtest($name, \&code) >>

This like Test::More::subtest.

=back

=head1 AUTHOR

xaicron E<lt>xaicron {at} cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2011 - xaicron

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<< Test::SharedFork >>

=cut
