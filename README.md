[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# NOTE: All files are not pushed here yet!

This repository contains config files and some scripts for my "deskcade" project that is a 
Raspberry Pi based tabletop MAME arcade. If you plan to build a deskcade, you can see how I did it.
These config files might not be suitable for your project without modification because of differences 
of hardware eg. display and controllers.

I used AdvanceMAME in my project. It can be downloaded from [advancemame.it](http://www.advancemame.it/download)
I also used Press Start 2P font for Advance menu. It looks like old JAMMA game font and can be downloaded
freely from [1001freefonts.com](https://www.1001freefonts.com/press_start_2p.font)

# NOTE: This is not suitable for beginners. If you want to do similar, you should have knowledge
how to make a buildroot image and how to configure Linux. For beginners it's better just use some ready made
game emulator distribution like [RetroPie](https://retropie.org.uk/) or [PiPlay](https://piplay.org/)

## Directories:

### buildroot
  - Contains OS related things eg. [buildroot](https://buildroot.org/) config etc.

### script
  - Contains several utilities for setup and maintenance.

### config 
  - Contains my advmame config files from /home/pi/.advance These are of course just for information and might not be suitable for your project.

### util
  - Everything to put under /home/pi/.advance/util directory. The directory contains scripts that are run by fake emulator "util".

