#!/usr/bin/perl

# usage:
# conda-env-compare.pl env-name-1 env-name2
#
# This program compares 2 given conda environments (by name) and prints out 3 tables:
# 1. Different version numbers
# 2. Packages in one env but not the other
# 3. Packages with the same versions
#
# Tested to work with conda 4.5.12
#
# troubleshooting: make sure:
# 1. you have 'conda activate YOURENVNAME' setup working
# 2. you can run: conda list -n YOURENVNAME

use strict;
use warnings;

#use Data::Dumper;

my @env = @ARGV;

die "usage:\n\n$0 env1-name env2-name\n" unless @env == 2;

my $ver1 = vers($env[0]);
my $ver2 = vers($env[1]);

compare($ver1, $ver2);

sub vers {
    my $env = shift;
    my %vers = ();

    my $max_chan_len = 20;
    my $out = qx[bash -c "source ~/.bashrc; conda list -n $env"];
    for (split /\n/, $out) {
        next if /^#/;
        my ($name, $ver, $source, $chan) = split /\s+/;
        $name =~ s/_/-/g;
        $name = lc $name;
        if ($source eq "<pip>") {
            $source = "pip";
        }
        else {
            $chan ||= "anaconda";
            my $len = length $chan;
            # truncate long channels
            $chan = substr($chan, 0, $max_chan_len) . ($len >  $max_chan_len && '...' || '');
            $source .= "/$chan";
        }

        # special cases:
        # 2018.1.10 and 2018.01.10 should match (strip superfluous leading 0's)
        $ver =~ s/(?<!\d)0(\d)(\.|$)/$1$2/g;
        #$ver =~ s/^(\d\d\d\d)\.(0?\d)\.(0?\d)/$1.$2.$3/

        #print "$name, $ver, $source";
        $vers{$name} = [$ver, $source];
    }
    die "Error: Non-existing or empty environment: $env\n" if keys %vers == 0;
    return \%vers;
}

sub compare {
    my ($ver1, $ver2) = @_;
    my %combined = map { $_ => 1 } keys(%$ver1), keys(%$ver2);
    #print(join " ", keys %combined);
    my @miss = ();
    my @diff = ();
    my @same = ();

    my @max_len = (5,5,5);
    for (keys %combined) {
        #print "$_\n";
        $ver1->{$_} ||= ['','',''];
        $ver2->{$_} ||= ['','',''];

        # calculate max width of version and source columns
        for my $i (0..1) {
            #print "$_ $i", $ver1->{$_}[$i], "\n";
            $max_len[$i] = length($ver1->{$_}[$i]) if length($ver1->{$_}[$i]) > $max_len[$i];
            $max_len[$i] = length($ver2->{$_}[$i]) if length($ver2->{$_}[$i]) > $max_len[$i];
        }
        # calculate max width of package names
        $max_len[2] = length($_) if length($_) > $max_len[2];

        if ($ver1->{$_}[0] eq '' or $ver2->{$_}[0] eq '') {
            push @miss, $_;
        }
        elsif ($ver1->{$_}[0] ne $ver2->{$_}[0]) {
            push @diff, $_;
        }
        else {
            push @same, $_;
        }
    }

    print "Comparing installed packages in environments: $env[0] and $env[1]\n";

    report("Differ",  \@diff, $ver1, $ver2, \@max_len);
    report("Missing", \@miss, $ver1, $ver2, \@max_len);
    report("Same",    \@same, $ver1, $ver2, \@max_len);
}

sub report {
    my ($type, $keys, $ver1, $ver2, $max_len) = @_;

    my $banner = " Match: $type ";
    my $total_len = $max_len->[2]+$max_len->[0]+$max_len->[0]+$max_len->[1]+$max_len->[1]+4;
    my $margin_len = int (($total_len - length $banner) / 2);

    # when env name is wider than the version column
    my $compensate = 0;
    $compensate += length($env[0]) - $max_len->[0] if length($env[0]) > $max_len->[0];
    $compensate += length($env[1]) - $max_len->[0] if length($env[1]) > $max_len->[0];
    my $mid_col = $max_len->[1] - $compensate;

    print "\n\n" . "*" x $margin_len . " Match: $type ". "*" x $margin_len . "\n";
    printf "%$max_len->[2]s %$max_len->[0]s %$max_len->[0]s %${mid_col}s %$max_len->[1]s\n", "environment", $env[0], $env[1], $env[0], $env[1];
    printf "%$max_len->[2]s %$max_len->[0]s %$max_len->[0]s %$max_len->[1]s %$max_len->[1]s\n", "package name", "version", "version", "source", "source";
    printf "%s\n", "-" x $total_len;
    for (sort @$keys) {
        printf "%$max_len->[2]s %$max_len->[0]s %$max_len->[0]s %$max_len->[1]s %$max_len->[1]s\n",
            $_, $ver1->{$_}[0], $ver2->{$_}[0], $ver1->{$_}[1], $ver2->{$_}[1];
    }

}
