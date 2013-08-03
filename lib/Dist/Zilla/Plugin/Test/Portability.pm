use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::Test::Portability;
# ABSTRACT: Release tests for portability
our $VERSION = '2.000005'; # VERSION
use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with 'Dist::Zilla::Role::FileMunger';



has options => (
  is      => 'ro',
  isa     => 'Str',
  default => '',
);


sub munge_file {
    my ($self, $file) = @_;
    return unless $file->name eq 'xt/release/portability.t';

    # 'name => val, name=val'
    my %options = split(/\W+/, $self->options);

    if ( keys %options ) {
        my $content = $file->content;

        my $optstr = join ', ', map { "$_ => $options{$_}" } sort keys %options;

        # insert options() above run_tests;
        $content =~ s/^(run_tests\(\);)$/options($optstr);\n$1/m;

        $file->content($content);
    }
    return;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=pod

=encoding utf-8

=head1 NAME

Dist::Zilla::Plugin::Test::Portability - Release tests for portability

=head1 VERSION

version 2.000005

=head1 SYNOPSIS

In C<dist.ini>:

    [Test::Portability]
    ; you can optionally specify test options
    options = test_dos_length = 1, use_file_find = 0

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following file:

  xt/release/portability.t - a standard Test::Portability::Files test

You can set options for the tests in the 'options' attribute:
Specify C<< name = value >> separated by commas.

See L<Test::Portability::Files/options> for possible options.

=head2 munge_file

Inserts the given options into the generated test file.

=for test_synopsis 1;
__END__

=head1 AVAILABILITY

The project homepage is L<http://metacpan.org/release/Dist-Zilla-Plugin-Test-Portability/>.

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see L<https://metacpan.org/module/Dist::Zilla::Plugin::Test::Portability/>.

=head1 SOURCE

The development version is on github at L<http://github.com/doherty/Dist-Zilla-Plugin-Test-Portability>
and may be cloned from L<git://github.com/doherty/Dist-Zilla-Plugin-Test-Portability.git>

=head1 BUGS AND LIMITATIONS

You can make new bug reports, and view existing ones, through the
web interface at L<https://github.com/doherty/Dist-Zilla-Plugin-Test-Portability/issues>.

=head1 AUTHORS

=over 4

=item *

Marcel Gruenauer <marcel@cpan.org>

=item *

Randy Stauner <rwstauner@cpan.org>

=item *

Mike Doherty <doherty@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Mike Doherty.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__DATA__
___[ xt/release/portability.t ]___
#!perl

use strict;
use warnings;

use Test::More;

eval 'use Test::Portability::Files';
plan skip_all => 'Test::Portability::Files required for testing portability'
    if $@;
run_tests();
