#!/usr/bin/perl

use strict;
use Fcntl;

if (!$ENV{'DISPLAY'} && !$ENV{'SSH_CLIENT'} && !$ENV{'SSH_TTY'}) {
    close STDOUT;
    open STDOUT, ">:encoding(utf8)", "/dev/tty1";
}
binmode STDOUT, ":encoding(utf8)";

$|=1;
print "\e[2J\e[?25l";
qx{cat volume.raw >/dev/fb0};

my $vol = qx{amixer -M get PCM};
$vol =~ s/.*Playback .*\[(\d*)%\] \[.*\] \[.*\].*/$1/s;
my $initialvol = $vol;

sub drawbar {
    my $volumebars = "";
    my $realrow = 1;
    for (my $row = $realrow; $row < 33; $row++) {
         my $col = 128-$row*3;
         my $bars = 34;

         $volumebars .= "\e[s\e[".(20+$realrow).";".($col)."H";
         my $chrs = "\x{2580}\x{2580}";
         $realrow++ if ($row % 2 == 0);

         for (my $bar = int($col/3); $bar < $bars; $bar++) {
              if (int($vol/3) < $bar) {
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
drawbar ($vol);

my $buf;
sysopen(my $joy, "/dev/input/js0", O_NONBLOCK|O_RDONLY);
binmode $joy;
sysread($joy,$buf,64);
$buf = "";

while (1) {
    sysread($joy,$buf,8);

    if ($buf) {
        my $data = substr(unpack("H*",$buf),8,8);

        if ($data eq "ff7f0200") {
            $vol += 3;
            if ($vol > 100) {$vol = 100}
            drawbar($vol);
            system("amixer","-q","-M","set","PCM",$vol."%");
        }
        if ($data eq "01800200") {
            $vol -= 3;
            if ($vol < 30) {$vol = 30}
            drawbar($vol);
            system("amixer","-q","-M","set","PCM",$vol."%");
        }
        if ($data eq "01000100") {
            system("aplay","-q","ding.wav");
        }
        if ($data eq "0100010b") {
            print "\e[0m\e[?25h";
            if ($vol != $initialvol) {
                system("alsactl","--file",$ENV{HOME}."/.asound.state","store");
            }
            exit;
        }
    }

    select(undef,undef,undef,0.05);
}

