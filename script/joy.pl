#!/usr/bin/perl

#
# This script prints out joystick data for util/var/volume.pl if you need to edit it.
#

use strict;
use Fcntl;

# Settings
my $joydev      = "/dev/input/js0";

# Start reading joystick device. In the beginning there are 64 bytes of crap, so slurp them away.
my $buf;
sysopen(my $joy, $joydev, O_NONBLOCK|O_RDONLY);
binmode $joy;
sysread($joy,$buf,64);
$buf = "";

# Read the joystick state in loop
while (1) {
    sysread($joy,$buf,8);

    if ($buf) {
        my $data = substr(unpack("H*",$buf),8,8);
        print $data ."\n";
    }

    # Sleep 50 milliseconds
    select(undef,undef,undef,0.05);
}

__END__
