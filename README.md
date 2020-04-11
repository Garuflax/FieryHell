################################################################################
# FIERY HELL                                                                   #
################################################################################

A NES bullet hell rhythm game.

################################################################################
# RESOURCES                                                                    #
################################################################################

I used Patrick Vogt's Hello World as a starting point of the project.

Visit Patrick Vogt's page at http://patrickvogt.net/.

Thanks to Patrick Vogt.

Other resources:

+ Nintendo Entertainment System Documentation, Patrick Diskin, Version 1.0 August 2004
    * http://nesdev.com/NESDoc.pdf 

+ WLA-Documentation
    * http://www.villehelin.com/wla.html

+ NESDEV wiki
    * http://wiki.nesdev.com
    
+ 6502 ISA
    * http://obelisk.me.uk/6502/reference.html#RTS

################################################################################
# TOOLS                                                                        #
################################################################################

You will need a copy of the following tools to build and run this code:

+ an up to date version of wlaDX in your $PATH
+ some NES emulator (the makefile uses **higan**)
  
Then you should call 'make' to build the code and 'make run' to test it within
the emulator.

################################################################################
# OTHER                                                                        #
################################################################################

I didn't find a **sublime-syntax** for WLA so I made one myself.
The YAML file is in the *other* folder.