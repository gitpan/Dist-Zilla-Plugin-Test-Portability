use strict;
use warnings;
use Test::More 0.96 tests => 2;
use Test::Output;
use autodie;
use Test::DZil;
use Moose::Autobox;

my $tzil;

stderr_like(
    sub {
        $tzil = Builder->from_config(
            { dist_root => 'corpus/DZ1' },
            { add_files => {
                'source/dist.ini' => simple_ini('GatherDir', 'PortabilityTests')
                }
            },
        );
    },
    qr/^!!!.*deprecate/,
    'Got a deprecation warning'
);

$tzil->build;
END { # Remove (empty) dir created by building the dists
    require File::Path;
    File::Path::rmtree('tmp');
}

my @xtests = map $_->name =~ m{^xt/} ? $_->name : (), $tzil->files->flatten;
ok(
    (grep { $_ eq 'xt/release/portability.t' } @xtests),
    'portability.t exists'
) or diag explain \@xtests;
