#!/usr/bin/perl

#
# This ugly script strips extraneous data from advmame.xml and leaves only data for
# roms that you have. It speeds advmenu startup a lot if you don't have many games.
# 

use strict;

my $romd = "/home/pi/.advance/rom";
my $orig = "/home/pi/.advance/advmame.origxml";
my $new  = "/home/pi/.advance/advmame.xml";
my $rlst = "/home/pi/.advance/romlist.txt";

exit if ( !-d $romd);

# If origxml does not exist but xml does, then this must be first run and
# the xml file contains everything. Copy it to origxml for initializing.
if (!-e $orig and -e $new) {
    rename $new, $orig;
}

# First check if we have plaintext list of existing roms and if it is up to date.
# If not, update it.
my $roms;
my $romlist;
if (-e $rlst) {
    open my $fd, "<$rlst";
    $romlist = join("",<$fd>);
    close $fd;
}
my @romzips = sort glob($romd."/*.zip");
map {s/\.zip$//;s/.*\///} @romzips;
$roms = join("\n",@romzips) ."\n";
if ($roms ne $romlist) {
    open my $fd, ">$rlst";
    print $fd $roms;
} else {
    exit; # nothing to do
}

# This is ugly way to handle the xml but we want to have this minimal and
# a real xml parser library is not necessary with this easy task.

open my $fdi, "<$orig" or die $!;
open my $fdo, ">$new"  or die $!;

while (my $r = <$fdi>) {
    print $fdo $r;
    last if ($r =~ /<mame/);
}

my $buf;
my $game;
while (my $r = <$fdi>) {
    $buf .= $r;
    if ($r =~ /<\/game>/) {
        $game = $buf;
        $game =~ s/.*<game name="//s;
        $game =~ s/".*//s;
        if (-e $romd."/".$game.".zip") {
            print $fdo $buf;
        }
        $buf = $game = ""; 
    }
}
print $fdo "</mame>\n";

close $fdi;
close $fdo;

# If there are no real time clock and no ntp, Pi of course thinks it's 1970.
# Then increase timestamp of the xml file by one second that it is newer than
# original was. Otherwise advmenu generates a new xml on startup.

my @t = localtime();
if ($t[5] == 70) {
    my @s = stat($orig);
    utime $s[9]+1,$s[9]+1,$new;
}

__END__
