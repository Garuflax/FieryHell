* DEFINES
* IO PPU REGISTERS
.DEFINE PPUCTRL $2000 ; Write Only
/*
7  bit  0
---- ----
VPHB SINN
|||| ||||
|||| ||++- Base nametable address
|||| ||    (0 = $2000; 1 = $2400; 2 = $2800; 3 = $2C00)
|||| |+--- VRAM address increment per CPU read/write of PPUDATA
|||| |     (0: add 1, going across; 1: add 32, going down)
|||| +---- Sprite pattern table address for 8x8 sprites
||||       (0: $0000; 1: $1000; ignored in 8x16 mode)
|||+------ Background pattern table address (0: $0000; 1: $1000)
||+------- Sprite size (0: 8x8 pixels; 1: 8x16 pixels)
|+-------- PPU master/slave select
|          (0: read backdrop from EXT pins; 1: output color on EXT pins)
+--------- Generate an NMI at the start of the
           vertical blanking interval (0: off; 1: on) */

.DEFINE PPUMASK $2001 ; Write Only
/*
7  bit  0
---- ----
BGRs bMmG
|||| ||||
|||| |||+- Greyscale (0: normal color, 1: produce a greyscale display)
|||| ||+-- 1: Show background in leftmost 8 pixels of screen, 0: Hide
|||| |+--- 1: Show sprites in leftmost 8 pixels of screen, 0: Hide
|||| +---- 1: Show background
|||+------ 1: Show sprites
||+------- Emphasize red
|+-------- Emphasize green
+--------- Emphasize blue */

.DEFINE PPUSTATUS $2002 ; Read Only
/*
7  bit  0
---- ----
VSO. ....
|||| ||||
|||+-++++- Least significant bits previously written into a PPU register
|||        (due to register not being updated for this address)
||+------- Sprite overflow. The intent was for this flag to be set
||         whenever more than eight sprites appear on a scanline, but a
||         hardware bug causes the actual behavior to be more complicated
||         and generate false positives as well as false negatives; see
||         PPU sprite evaluation. This flag is set during sprite
||         evaluation and cleared at dot 1 (the second dot) of the
||         pre-render line.
|+-------- Sprite 0 Hit.  Set when a nonzero pixel of sprite 0 overlaps
|          a nonzero background pixel; cleared at dot 1 of the pre-render
|          line.  Used for raster timing.
+--------- Vertical blank has started (0: not in vblank; 1: in vblank).
           Set at dot 1 of line 241 (the line *after* the post-render
           line); cleared after reading $2002 and at dot 1 of the
           pre-render line. */

.DEFINE OAMADDR $2003 ; Write Only
* Write the address of OAM you want to access here. Most games just write $00 here and then use OAMDMA. (DMA is implemented in the 2A03/7 chip and works by repeatedly writing to OAMDATA) 

.DEFINE OAMDATA $2004 ; Read/Write
* Write OAM data here. Writes will increment OAMADDR after the write; reads during vertical or forced blanking return the value from OAM at that address but do not increment.

.DEFINE PPUSCROLL $2005 ; Write*2
* This register is used to change the scroll position, that is, to tell the PPU which pixel of the nametable selected through PPUCTRL should be at the top left corner of the rendered screen. Typically, this register is written to during vertical blanking, so that the next frame starts rendering from the desired location, but it can also be modified during rendering in order to split the screen. Changes made to the vertical scroll during rendering will only take effect on the next frame.

.DEFINE PPUADDR $2006 ; Write*2
* Because the CPU and the PPU are on separate buses, neither has direct access to the other's memory. The CPU writes to VRAM through a pair of registers on the PPU. First it loads an address into PPUADDR, and then it writes repeatedly to PPUDATA to fill VRAM.
* Since a memory address usually consists of 16 bits, it must first the high byte are written to this address, then the low byte.

.DEFINE PPUDATA $2007 ; Read/Write
* VRAM read/write data register. After access, the video memory address will increment by an amount determined by bit 2 of $2000.

.DEFINE APUPULSE1ENV $4000 ; Write Only
/*
7  bit  0
---- ----
DDLE VVVV
|||| ||||
|||| ++++- Volume/Envelope
|||| 
|||+------ Envelope Disable (0: use internal counter for volume, 1: use Volume for volume)
||+------- Length Counter Disable (0: use Length Counter; 1: disable Length Counter)
++-------- Duty Cycle */

.DEFINE APUPULSE1SWEEP $4001 ; Write Only
/*
7  bit  0
---- ----
EPPP NSSS
|||| ||||
|||| |+++- Shift
|||| +---- Negate
|+++------ Period
+--------- Sweep unit enabled */

.DEFINE APUPULSE1LOW $4002 ; Write Only
/*
7  bit  0
---- ----
PPPP PPPP
|||| ||||
++++-++++- Low 8-bits of period */

.DEFINE APUPULSE1HIGH $4003 ; Write Only
/*
7  bit  0
---- ----
LLLL LPPP
|||| ||||
|||| |+++- High 3-bits of period
++++-++++- Length counter load */

.DEFINE APUPULSE2ENV $4004 ; Write Only
/*
7  bit  0
---- ----
DDLE VVVV
|||| ||||
|||| ++++- Volume/Envelope
|||| 
|||+------ Envelope Disable (0: use internal counter for volume, 1: use Volume for volume)
||+------- Length Counter Disable (0: use Length Counter; 1: disable Length Counter)
++-------- Duty Cycle */

.DEFINE APUPULSE2SWEEP $4005 ; Write Only
/*
7  bit  0
---- ----
EPPP NSSS
|||| ||||
|||| |+++- Shift
|||| +---- Negate
|+++------ Period
+--------- Sweep unit enabled */

.DEFINE APUPULSE2LOW $4006 ; Write Only
/*
7  bit  0
---- ----
PPPP PPPP
|||| ||||
++++-++++- Low 8-bits of period */

.DEFINE APUPULSE2HIGH $4007 ; Write Only
/*
7  bit  0
---- ----
LLLL LPPP
|||| ||||
|||| |+++- High 3-bits of period
++++-++++- Length counter load */

.DEFINE APUTRIANGLECTRL $4008 ; Write Only
/*
7  bit  0
---- ----
CRRR RRRR
|||| ||||
|+++-++++- Linear counter load
+--------- Length counter disable */

.DEFINE APUTRIANGLELOW $400A ; Write Only
/*
7  bit  0
---- ----
PPPP PPPP
|||| ||||
++++-++++- Low 8-bits of period */

.DEFINE APUTRIANGLEHIGH $400B ; Write Only
/*
7  bit  0
---- ----
LLLL LPPP
|||| ||||
|||| |+++- High 3-bits of period
++++-++++- Length counter load */

.DEFINE APUNOISEENV $400C ; Write Only
/*
7  bit  0
---- ----
..LE VVVV
|||| ||||
|||| ++++- Volume/Envelope Period
|||| 
|||+------ Envelope Disable (0: use internal counter for volume, 1: use Volume for volume)
||+------- Length Counter Disable (0: use Length Counter; 1: disable Length Counter) 
++-------- Unused */

.DEFINE APUNOISEPERIOD $400E ; Write Only
/*
7  bit  0
---- ----
S... PPPP
|||| ||||
|||| ++++- Noise Period
|+++------ Unused
+--------- Short mode */

.DEFINE APUNOISELENGTH $400F ; Write Only
/*
7  bit  0
---- ----
LLLL L...
|||| ||||
|||| |+++- Unused
++++-++++- Length counter load */

.DEFINE APUDMCFLAGS $4010 ; Write Only
/*
7  bit  0
---- ----
IL.. RRRR
|||| ||||
|||| ++++- Frequency
||++------ Unused
|+-------- Loop Flag
+--------- IRQ enabled Flag. If clear, the interrupt flag is cleared.   */

.DEFINE APUDMCLOAD $4011 ; Write Only
/*
7  bit  0
---- ----
.DDD DDDD
|||| ||||
|+++-++++- Direct load. The DMC output level is set to D, an unsigned value. If the timer is outputting a clock at the same time, the output level is occasionally not changed properly.
++-------- Unused   */

.DEFINE APUDMCADDR $4012 ; Write Only
/*
7  bit  0
---- ----
AAAA AAAA
|||| ||||
++++-++++- Sample address. Actual address is obtained by doing the following to given number A: $C000 + (A << 6) */

.DEFINE APUDMCLENGTH $4013 ; Write Only
/*
7  bit  0
---- ----
LLLL LLLL
|||| ||||
++++-++++- Sample length. Actual length is obtained by doing the following to given number L: (L << 4) +1 */

.DEFINE OAMDMA $4014 ; Write Only
* This port is located on the CPU. Writing $XX will upload 256 bytes of data from CPU page $XX00-$XXFF to the internal PPU OAM. This page is typically located in internal RAM, commonly $0200-$02FF, but cartridge RAM or ROM can be used as well.

.DEFINE APUSTATUS $4015 ; Read/Write
/*
7  bit  0
---- ----
IF.D NT21
|||| ||||
|||| |||+- Pulse 1 (0: disable; 1: enable)
|||| ||+-- Pulse 2 (0: disable; 1: enable)
|||| |+--- Triangle (0: disable; 1: enable)
|||| +---- Noise (0: disable; 1: enable)
|||+------ DMC (0: disable; 1: enable)
||+------- Unused
|+-------- Frame interrupt
+--------- DMC interrupt */

.DEFINE JOYPAD1 $4016 ; Read/Write
/*
7  bit  0
---- ----
.... ..ES
|||| ||||
|||| |||+- Reads data from joypad or causes joypad strobe when writing.
|||| |||   (0: Clear joypad strobe, 1: Reset joypad strobe)
|||| ||+-- Expansion controller status bit
|||| |+--- Microphone status bit
|||| +---- Zapper Sprite Detection
||||       (0: Sprite not in position, 1: Sprite in front of cross-hair)
|||+------ Zapper Trigger
|||        (0: Pulled, 1: Released (not held) )
+++------- Unused */

.DEFINE JOYPAD2 $4017 ; Read/Write
/*
7  bit  0
---- ----
MI.. ..ES
|||| ||||
|||| |||+- Reads data from joypad or causes joypad strobe when writing.
|||| |||   (0: Clear joypad strobe, 1: Reset joypad strobe)
|||| ||+-- Expansion controller status bit
|||| |+--- Unused
|||| +---- Zapper Sprite Detection
||||       (0: Sprite not in position, 1: Sprite in front of cross-hair)
|||+------ Zapper Trigger
|||        (0: Pulled, 1: Released (not held) )
||+------- Unused 
|+-------- IRQ disable
+--------- Mode (0: 4-step, 1: 5-step) */