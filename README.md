[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# NOTE: All files are not pushed here yet!

This repository contains config files and some scripts for my "deskcade" project that is a 
Raspberry Pi based tabletop MAME arcade. If you plan to build a deskcade, you can see how I did it.
These config files might not be suitable for your project without modification because of differences 
of hardware eg. display and controllers.

I used AdvanceMAME in my project. It can be downloaded from [advancemame.it](http://www.advancemame.it/download)

Note: I used Press Start 2P font for Advance menu. It looks like old JAMMA game font and can be downloaded
freely from [1001freefonts.com](https://www.1001freefonts.com/press_start_2p.font)

## Directories:

### buildroot
  - Contains things to create buildroot image and other OS related files. 

### script
  - Contains several utilities for setup and maintenance.

### config 
  - Contains my advmame config files. These are of course just for information and might not be suitable for your project.

### util
  - Everything to put under .advance/util directory. The directory contains scripts that are run by fake emulator "util".

