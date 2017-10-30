#!/usr/bin/perl

# This hack puts an information image on top of the framebuffer and then makes volume bars 
# with ANSI codes to the terminal.

use strict;
use Fcntl;

# Settings
my $joydev      = "/dev/input/js0";

my $joy_left    = "01800200";
my $joy_right   = "ff7f0200";
my $joy_button1 = "01000100";
my $joy_esc     = "0100010b";

# The actual code begins here -------------------------------------------------------------------

# This function draws volume bars on terminal with ANSI codes (jonnet ei muista).
# It assumes that terminal size is 128x48 as it is with default font and in mode 1024x768 pixels.
#
sub drawbar {
    my $volume = shift;
    my $volumebars = "";
    my $realrow = 1;
    for (my $row = $realrow; $row < 33; $row++) {
         my $col = 128-$row*3;
         my $bars = 34;

         $volumebars .= "\e[s\e[".(20+$realrow).";".($col)."H";
         my $chrs = "\x{2580}\x{2580}";
         $realrow++ if ($row % 2 == 0);

         for (my $bar = int($col/3); $bar < $bars; $bar++) {
              if (int($volume/3) < $bar) {
                  $volumebars .= "\e[7;37m";
              } elsif ($bar < 29) {
                  $volumebars .= "\e[7;32m";
              } elsif ($bar < 31) {
                  $volumebars .= "\e[7;33m";
              } else {
                  $volumebars .= "\e[7;31m";
              }
              if ($row % 2 == 1) {
                  $chrs = "  ";
              }
              $volumebars .= "$chrs\e[0m ";
              $chrs = "  ";
         }
    }
    print $volumebars . "\e[1;1H";
}

# If we are in X or ssh session set encoding of TTY to UTF-8
if (!$ENV{'DISPLAY'} && !$ENV{'SSH_CLIENT'} && !$ENV{'SSH_TTY'}) {
    close STDOUT;
    open STDOUT, ">:encoding(utf8)", "/dev/tty1";
}
binmode STDOUT, ":encoding(utf8)";

# set autoflush on
$|=1;

# clear screen and cursor off
print "\e[2J\e[?25l";

# put image on top of framebuffer
qx{cat volume.raw >/dev/fb0};

# check what is the volume in startup and draw the volume bars
my $vol = qx{amixer -M get PCM};
$vol =~ s/.*Playback .*\[(\d*)%\] \[.*\] \[.*\].*/$1/s;
my $initialvol = $vol;
drawbar($vol);

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

        # joystick left, decrease volume
        if ($data eq $joy_left) {
            $vol -= 3;
            if ($vol < 30) {$vol = 30}
            drawbar($vol);
            system("amixer","-q","-M","set","PCM",$vol."%");
        }
        # joystick right, increase volume
        if ($data eq $joy_right) {
            $vol += 3;
            if ($vol > 100) {$vol = 100}
            drawbar($vol);
            system("amixer","-q","-M","set","PCM",$vol."%");
        }
        # button1 pressed, play ding.wav
        if ($data eq $joy_button1) {
            system("aplay","-q","ding.wav");
        }
        # User wants to exit. Move cursor to home and enable it. 
        # If volume has changed since startup, save it to .asound.state
        if ($data eq $joy_esc) {
            print "\e[0m\e[?25h";
            if ($vol != $initialvol) {
                system("alsactl","--file",$ENV{HOME}."/.asound.state","store");
            }
            exit;
        }
    }

    # Sleep 50 milliseconds
    select(undef,undef,undef,0.05);
}

__END__
