#! /usr/bin/env nix-shell
#! nix-shell -i perl --packages perlPackages.JSON

use strict;
use warnings;

use JSON;

use Term::ANSIColor;
use File::Slurp;
use Time::Piece;

# Decode the lock files
my $old_lock = decode_json `git show HEAD:flake.lock`;
my $new_lock = decode_json( read_file('flake.lock') );

print "\n";

foreach my $key ( keys %{ $new_lock->{nodes} } ) {
    if (   exists $old_lock->{nodes}{$key}
        && exists $new_lock->{nodes}{$key}{locked}
        && defined $old_lock->{nodes}{$key}{locked}{type}
        && defined $old_lock->{nodes}{$key}{locked}{rev}
        && $new_lock->{nodes}{$key}{locked}{type} eq "github" )
    {
        my $new = $new_lock->{nodes}{$key}{locked};
        my $old = $old_lock->{nodes}{$key}{locked};

        # Compare 'rev' values
        if ( $new->{rev} ne $old->{rev} ) {
            my $old_modified_date = localtime( $old->{lastModified} );
            my $days_since_modified =
              int( ( $new->{lastModified} - $old->{lastModified} ) /
                  ( 60 * 60 * 24 ) );

            print color('bold'), "Updated input '$key':", color('reset'), "\n";
            print "Last modified: "
              . $old_modified_date->strftime("%d-%m-%Y")
              . " ($days_since_modified days ago)" . "\n";
            print "Compare: "
              . color('blue')
              . "https://github.com/$new->{owner}/$new->{repo}/compare/$old->{rev}...$new->{rev}?diff=unified&w="
              . color("reset") . "\n\n";
        }
    }
}
