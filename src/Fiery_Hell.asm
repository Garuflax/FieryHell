; Integrating the memory architecture of the NES system. This defines the later structure of the NES-ROM

.INCLUDE "nes_memory.inc"
.INCLUDE "nes.inc"

* Fill all unused data with $ 00.
.EMPTYFILL $00

; We now switch to address $ 00 (absolute: $ 00) from BANK 0 to SLOT 0. HEADER
.BANK 0 SLOT 0
.ORG $0000

* Byte 0-Byte 2: string ‘NES’ to identify the file as an iNES file
.DB "NES"
* Byte 3: value $1A = 26 , also used to identify file format
.DB $1A
* Byte 4: Number of 16 KB PRG-ROM banks. The PRG-ROM (Program ROM) is the area of ROM used to store the program code.
.DB 2
* Byte 5: Number of 8 KB CHR-ROM / VROM banks. The names CHR-ROM (Character ROM) and VROM are used synonymously to refer to the area of ROM used to store graphics information, the pattern tables.
.DB 1
* Byte 6: ROM Control Byte 1:
/* Bit 0 - Indicates the type of mirroring used by the game where 0 indicates horizontal mirroring, 1 indicates vertical mirroring.
 Bit 1 - Indicates the presence of battery-backed RAM at memory locations $6000-$7FFF.
 Bit 2 - Indicates the presence of a 512-byte trainer at memory locations $7000-$71FF.
 Bit 3 - If this bit is set it overrides bit 0 to indicate four-screen mirroring should be used.
 Bits 4-7 - Four lower bits of the mapper number. */
.DB 0
* Byte 7: ROM Control Byte 2:
/* Bits 0-3 - Reserved for future usage and should all be 0.
 Bits 4-7 - Four upper bits of the mapper number. */
.DB 0
* Byte 8: Number of 8 KB PRG-RAM banks. For compatibility with previous versions of the iNES format, assume 1 page of PRG-RAM when this is 0.
.DB 0
* Byte 9-Byte15: Reserved for future usage and should all be 0.

* Defines:
.EQU player_min_x $8
.EQU player_min_y $8
.EQU player_max_x $F0
.EQU player_max_y $E0
.EQU player_start_x $70
.EQU player_start_y $70
.EQU fireball_min_x $00
.EQU fireball_min_y $00
.EQU fireball_max_x $F8
.EQU fireball_max_y $E8
.EQU size_of_fireball $2
.EQU fireball_amount $20
.EQU fireball_speed $02
.EQU song_size $100
.EQU game_length $C0

.EQU buttons $0
.EQU current_note $1
.EQU current_song1 $2
.EQU current_song2 $4
.EQU note_pulse $6
.EQU pulse_limit $7
.EQU frame_done $8
.EQU x_player $9
.EQU y_player $A
.EQU song_limit $B
.EQU up_index $C
.EQU down_index $D
.EQU right_index $E
.EQU left_index $F
.EQU up_fireballs $10 ; Array of 8 (x,y) coordinates of fireballs (16 Bytes)
.EQU down_fireballs $20
.EQU right_fireballs $30
.EQU left_fireballs $40
.EQU temp0 $50
.EQU temp1 $51
.EQU temp2 $52
.EQU temp3 $53


.BANK 1 SLOT 3
.ORG $0000

* Palette colours can be found: http://wiki.nesdev.com/w/index.php/PPU_palettes
*                                           BACKGROUND                                      |                                 SPRITES
* Colour:    RED                 GREEN               BLUE                WHITE               RED                 GREEN               BLUE                WHITE
palette: .DB $0F, $06, $16, $26, $0F, $09, $19, $29, $0F, $02, $12, $22, $0F, $00, $10, $30, $0F, $06, $16, $26, $0F, $09, $19, $29, $0F, $02, $12, $22, $0F, $00, $10, $30
* Menu background: Separated in four parts so it is simpler to pass it to the PPU
nameTable00: .DSB 17, 1 .DSB 7, 0 .DSB 1, 1 .DSB 7, 0 .DB 1, 0, 0, 'F' , 'E' , 'Y' , 0, 0
.DSB 1, 1 .DSB 7, 0 .DB 1, 0, 0, 0, 'L' , 0, 0, 0
.REPEAT 9
	.DSB 1, 1 .DSB 7, 0
.ENDR
.DB 1, 0, 0, 'R' , 0, 'R' , 0, 0
.REPEAT 9
	.DSB 1, 1 .DSB 7, 0
.ENDR
.DB 1, 'F' , 'N' , 'L' , 'R' , 0, '2' , 0, 1
.DSB 7, 0 .DSB 16, 1
nameTable01: .DSB 17, 1 .DSB 7 0 .DSB 1, 1 .DSB 7, 0 .DB 1, 0, 0, 0, 0, 0 , 0, 0
.DSB 1, 1 .DSB 7, 0 .DB 1, 0, 0, 0, 'L' , 0, 0, 0
.REPEAT 9
	.DSB 1, 1 .DSB 7, 0
.ENDR
.DB 1, 0, 0, 'E' , 'S' , 'T' , 0, 0
.REPEAT 9
	.DSB 1, 1 .DSB 7, 0
.ENDR
.DB 1, 'A' , 'D' , 'I' , 'I' , 0, '0' , 0, 1
.DSB 7, 0 .DSB 16, 1
nameTable02: .DSB 16, 1 .DSB 7 0 .DSB 1, 1 .DSB 7, 0 .DB 1, 0, 0, 0 , 'I' , 'R' , 0, 0
.DSB 1, 1 .DSB 7, 0 .DB 1, 0, 0, 0, 'H' , 0, 0, 0
.REPEAT 9
	.DSB 1, 1 .DSB 7, 0
.ENDR
.DB 1, 0, 0, 0 , 'S' , 'T' , 0, 0
.REPEAT 9
	.DSB 1, 1 .DSB 7, 0
.ENDR
.DB 1, 0, 'C' , 'O' , 'N' , 0 , 0, '2' , 1
.DSB 7, 0 .DSB 17, 1
nameTable03: .DSB 16, 1 .DSB 7 0 .DSB 1, 1 .DSB 7, 0 .DB 1, 0, 0, 0 , 0, 0, 0, 0
.DSB 1, 1 .DSB 7, 0 .DB 1, 0, 0, 0, 'E' , 0, 0, 0
.REPEAT 9
	.DSB 1, 1 .DSB 7, 0
.ENDR
.DB 1, 0, 0, 'P' , 'S' , 'A' , 0, 0
.REPEAT 9
	.DSB 1, 1 .DSB 7, 0
.ENDR
.DB 1, 0, 'U' , 0, 'A' , 0 , 0, '0' , 1
.DSB 7, 0 .DSB 17, 1
attributeTable0: .DSB 9, $00 .DSB 6, $A5 .DSB 33, $00 .DSB 1, $C0 .DSB 6, $F0 .DSB 1, $30 .DSB 8, 0

*01230123012301230123012301230123
*################################ RED
*################################ RED
*##                            ## RED
*##                            ## RED
*##          F I E R Y         ## GREEN
*##                            ## GREEN
*##            HELL            ## BLUE
*##                            ## BLUE
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##         PRESS START        ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##                            ## RED
*##  FACUNDO LINARI      2020  ## WHITE
*##                            ## WHITE
*################################ RED
*################################ RED

nameTable20: .DB $05, $04, $04, $04, $04, $04, $04, $04, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $05, $04, $04, $04, $04, $04, $04, $04
nameTable21: .DB $04, $04, $04, $04, $04, $04, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $04, $04, $04, $04, $04
nameTable22: .DB $04, $04, $04, $04, $04, $04, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $04, $04, $04, $04, $04
nameTable23: .DB $04, $04, $04, $04, $04, $04, $04, $05, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $04, $04, $04, $04, $04, $05
attributeTable2: .DSB 64, $FF

up_pattern:
    .DB $10, $00, $00, $00, $30, $00, $00, $00, $50, $00, $00, $00, $70, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $18, $08, $38, $00, $28, $60, $00, $00, $48, $00, $00, $40, $00, $00, $00, $00
    .DB $58, $00, $58, $68, $78, $00, $70, $60, $68, $00, $80, $00, $78, $88, $98, $00
    .DB $90, $80, $B0, $00, $A0, $C0, $00, $00, $B8, $00, $00, $00, $A8, $00, $00, $00
    .DB $88, $00, $88, $78, $80, $00, $90, $98, $A0, $00, $88, $00, $98, $00, $70, $00
    .DB $68, $00, $58, $80, $00, $00, $70, $00, $60, $00, $50, $78, $00, $00, $80, $88
    .DB $90, $00, $00, $80, $A0, $00, $00, $98, $90, $A8, $E0, $00, $00, $00, $00, $00
    .DB $D8, $C0, $B0, $B8, $A8, $98, $A0, $90, $68, $88, $60, $40, $50, $30, $20, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
down_pattern:
    .DB $E8, $00, $00, $00, $C8, $00, $00, $00, $A8, $00, $00, $00, $88, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $E0, $F0, $C0, $00, $D0, $98, $00, $00, $B0, $00, $00, $B8, $00, $00, $00, $00
    .DB $A0, $00, $A0, $90, $80, $00, $88, $98, $90, $00, $78, $00, $80, $70, $60, $00
    .DB $68, $78, $48, $00, $58, $38, $00, $00, $40, $00, $00, $00, $50, $00, $00, $00
    .DB $70, $00, $70, $80, $78, $00, $68, $60, $58, $00, $70, $00, $60, $00, $88, $00
    .DB $90, $00, $A0, $78, $00, $00, $88, $00, $98, $00, $A8, $80, $00, $00, $78, $70
    .DB $68, $00, $00, $78, $58, $00, $00, $60, $68, $50, $18, $00, $00, $00, $00, $00
    .DB $20, $38, $48, $40, $50, $60, $58, $68, $90, $70, $98, $B8, $A8, $C8, $D8, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
right_pattern:
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $18, $A0, $20, $A8, $28, $B0, $30, $B8, $58, $C8, $60, $D0, $68, $D8, $70, $E0
    .DB $90, $C0, $88, $B8, $80, $A8, $78, $A0, $38, $78, $48, $88, $78, $C8, $98, $E0
    .DB $10, $40, $20, $50, $28, $58, $18, $48, $20, $68, $30, $88, $40, $A8, $50, $C8
    .DB $60, $D0, $48, $C0, $40, $B8, $28, $A8, $18, $88, $20, $90, $60, $B0, $70, $D0
    .DB $20, $60, $18, $58, $30, $70, $28, $68, $10, $70, $18, $78, $08, $80, $10, $78
    .DB $08, $80, $28, $70, $38, $60, $48, $50, $08, $58, $10, $68, $18, $78, $20, $88
    .DB $10, $00, $00, $00, $C0, $00, $00, $00, $40, $00, $00, $00, $90, $00, $70, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
left_pattern:
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $D0, $48, $C8, $40, $C0, $38, $B8, $30, $90, $20, $88, $18, $80, $10, $78, $08
    .DB $58, $28, $60, $30, $68, $40, $70, $48, $B0, $70, $A0, $60, $70, $20, $50, $08
    .DB $D8, $A8, $C8, $98, $C0, $90, $D0, $A0, $C8, $80, $B8, $60, $A8, $40, $98, $20
    .DB $88, $18, $A0, $28, $A8, $30, $C0, $40, $D0, $60, $C8, $58, $88, $38, $78, $18
    .DB $C8, $88, $D0, $90, $B8, $78, $C0, $80, $D8, $78, $D0, $70, $E0, $68, $D8, $70
    .DB $E0, $68, $C0, $78, $B0, $88, $A0, $98, $E0, $90, $D8, $80, $D0, $70, $C8, $60
    .DB $D8, $00, $00, $00, $28, $00, $00, $00, $A8, $00, $00, $00, $58, $00, $78, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

win_message: .DSB 33, 1 .DSB 10, 0 .DB "GAME OVER"
.DSB 11, 0 .DSB 2, 1 .DSB 30, 0 .DSB 33, 1

irq: ; So many interrupts are generated so it is impossible to return to the main code. I won't be using APU's IRQs because of this
jmp irq ; Halt
rti

nmi:
pha
;lda #$00
;sta frame_done
jsr draw_player
jsr draw_fireballs
lda #$02
sta OAMDMA.W
lda #$01
sta frame_done
pla
rti

*At power-up:
 ;
 ;   P = $34 (IRQ disabled)
 ;   A, X, Y = 0
 ;   S = $FD
 ;   $4017 = $00 (frame irq enabled)
 ;   $4015 = $00 (all channels disabled)
 ;   $4000-$400F = $00
 ;   $4010-$4013 = $00 
 ;   All 15 bits of noise channel LFSR = $0000. The first time the LFSR is clocked from the all-0s state, it will shift in a 1.
 ;   2A03G: APU Frame Counter reset. (but 2A03letterless: APU frame counter powers up at a value equivalent to 15)
 ;
 ;   Internal memory ($0000-$07FF) has unreliable startup state.

*After reset
 ;
 ;   A, X, Y were not affected
 ;   S was decremented by 3 (but nothing was written to the stack)
 ;   The I (IRQ disable) flag was set to true (status ORed with $04)
 ;   The internal memory was unchanged
 ;   APU mode in $4017 was unchanged
 ;   APU was silenced ($4015 = 0)
 ;   APU triangle phase is reset to 0 (i.e. outputs a value of 15, the first step of its waveform)
 ;   APU DPCM output ANDed with 1 (upper 6 bits cleared)
 ;   2A03G: APU Frame Counter reset. (but 2A03letterless: APU frame counter retains old value)

reset:
    sei
    cld

    ldx #0
    stx PPUCTRL.W ; disable NMI
    stx PPUMASK.W ; disable rendering
    dex ; X = 0xFF
    txs ; Set up stack
    ldx #$40
    stx JOYPAD2.W  ; disable APU frame
    ldx #$FF

    bit PPUSTATUS.W
@vblankwait1:
    bit PPUSTATUS.W
    bpl @vblankwait1

    inx ; X = 0
    txa ; A = X

@clearmem:
    sta $000,x
    sta $100,x
    sta $300,x
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x

    inx
    bne @clearmem

    lda #$FF ; A = 0xFF

@clearspritemem:
    sta $200,x

    inx
    bne @clearspritemem

    ; Configure Sound
    lda #%00000011
    sta APUSTATUS.W ;enable square 1 and square 2
 
    lda #%10111111 ;Duty 10, Volume F
    sta APUPULSE1ENV.W

    lda #%01111111 ;Duty 01, Volume F
    sta APUPULSE2ENV.W

@vblankwait2:
    bit PPUSTATUS.W
    bpl @vblankwait2

start:
    lda #$20
    sta PPUADDR.W
    stx PPUADDR.W ; PPUADDR = 0x2000
    ldy #240
@loadNameTable0:
    lda nameTable00.W, x
    sta PPUDATA.W
    lda nameTable01.W, x
    sta PPUDATA.W
    lda nameTable02.W, x
    sta PPUDATA.W
    lda nameTable03.W, x
    sta PPUDATA.W
    inx
    dey
    bne @loadNameTable0

    ldx #64

@loadAttributeTable0:
    lda attributeTable0.W, y
    sta PPUDATA.W
    iny
    dex
    bne @loadAttributeTable0

    lda #$28
    sta PPUADDR.W
    stx PPUADDR.W ; PPUADDR = 0x2800

    ldy #240
@loadNameTable2:
    lda nameTable20.W, x
    sta PPUDATA.W
    lda nameTable21.W, x
    sta PPUDATA.W
    lda nameTable22.W, x
    sta PPUDATA.W
    lda nameTable23.W, x
    sta PPUDATA.W
    inx
    dey
    bne @loadNameTable2

    ldx #64

@loadAttributeTable2:
    lda attributeTable2.W, y
    sta PPUDATA.W
    iny
    dex
    bne @loadAttributeTable2

    lda #$3F
    sta PPUADDR.W
    stx PPUADDR.W ; PPUADDR = 0x3F00

    ldy #32

@init_palette:
    lda palette.W, x
    sta PPUDATA.W
    inx
    dey
    bne @init_palette

@init_video:

    bit PPUSTATUS.W
@vblankwait:
    bit PPUSTATUS.W
    bpl @vblankwait

    lda #0 
    sta PPUSCROLL.W
    sta PPUSCROLL.W

    lda #$88
    sta PPUCTRL.W ; Set the address of the 'pattern tables' and generate NMI
    ;cli ; Clear the interrupt disable flag allowing normal interrupt requests to be serviced. I won't be using APUs IRQ
go_menu:
    jsr play_menu_song

    lda #0
    sta frame_done
@wait:
    lda frame_done
    beq @wait

    lda #0 
    sta PPUSCROLL.W
    sta PPUSCROLL.W

    lda #$88
    sta PPUCTRL.W

    lda #$0E
    sta PPUMASK.W ; turn on the sign of background
menu_loop:
    lda frame_done
    beq menu_loop
	jsr do_note
    jsr read_joy
    lda #0
    sta frame_done
    lda buttons
    and #$10 
    beq menu_loop

go_game:

    jsr play_game_song

    lda #0
    sta frame_done
    @wait:
    lda frame_done
    beq @wait

    lda #0 
    sta PPUSCROLL.W
    sta PPUSCROLL.W

    lda #$8A
    sta PPUCTRL.W ; Change name table

    lda #$1E
    sta PPUMASK.W ; turn on the sign of background and sprites

    jsr init_player
    jsr init_fireballs
    

game_loop:
	lda frame_done
    beq game_loop
    jsr do_note
    jsr read_joy
    lda buttons
    and #$20
    bne go_menu
    lda current_note
    cmp #game_length
    beq go_end
    jsr create_fireball
    jsr update_player
    jsr update_fireballs
    jsr check_collision
    bcs go_lose
    lda #0
    sta frame_done
    jmp game_loop

go_lose:
    jsr play_lose_song
    lda #$08
    sta $201 ; Replace player sprite
lose_loop:
    lda frame_done
    beq lose_loop
    jsr do_note
    jsr read_joy
    lda #0
    sta frame_done
    lda buttons
    and #$C0 
    beq lose_loop
    jmp go_menu

go_end:
    jsr play_end_song

    lda #$0A
    sta PPUCTRL.W ; Turn off nmis at start of vertical blanking interval

    bit PPUSTATUS.W

    @vblankwait:
    bit PPUSTATUS.W
    bpl @vblankwait

    lda #$29
    ldx #$80
    sta PPUADDR.W
    stx PPUADDR.W ; PPUADDR = 0x2980
    ldy #$80
    ldx #$00
@print_win_message:
    lda win_message.W, x
    sta PPUDATA.W
    inx
    dey
    bne @print_win_message

    lda #$2B
    ldx #$D8
    sta PPUADDR.W
    stx PPUADDR.W ; PPUADDR = 0x2BD8
    ldy #8
    lda #$FF
@update_attribute_table:
	sta PPUDATA.W
	dey
	bne @update_attribute_table

	lda #0 
    sta PPUSCROLL.W
    sta PPUSCROLL.W

    lda #$8A
    sta PPUCTRL.W

    lda #$0E
    sta PPUMASK.W ; turn on the sign of background

end_loop:
    lda frame_done
    beq end_loop
    jsr do_note
    jsr read_joy
    lda #0
    sta frame_done
	jmp end_loop

.BANK 2 SLOT 4
.ORG $3FFA
.DW nmi, reset, irq

.ORG $0000

; At the same time that we strobe bit 0, we initialize the ring counter
read_joy:
    lda #$01
    ; While the strobe bit is set, buttons will be continuously reloaded.
    ; This means that reading from JOYPAD1 will only return the state of the
    ; first button: button A.
    sta JOYPAD1.W
    sta buttons
    lsr A          ; now A is 0
    ; By storing 0 into JOYPAD1, the strobe bit is cleared and the reloading stops.
    ; This allows all 8 buttons (newly reloaded) to be read from JOYPAD1.
    sta JOYPAD1.W
@loop:
    lda JOYPAD1.W
    lsr A          ; bit 0 -> Carry
    rol buttons  ; Carry -> bit 0; bit 7 -> Carry
    bcc @loop
    rts

init_player:
    pha
    lda #$00
    sta $201 ; Tile to use for sprite
    lda #$02
    sta $202 ; Palette, priority and flipping 
    lda #player_start_x
    sta x_player ; starting X
    lda #player_start_y
    sta y_player ; starting Y
    pla
    rts

init_fireballs:
    pha
    txa
    pha
    tya
    pha
    clc
    lda #(fireball_amount >> 1)
    sta temp0
    lda #$00
    tax
    tay
    sta up_index
    sta down_index
    sta right_index
    sta left_index

@init_vertical:
    lda #$FF
    sta up_fireballs, X
    inx
    sta up_fireballs, X
    inx
    lda #$07
    sta $205, Y
    lda #$00
    sta $206, Y
    tya
    adc #$04
    tay
    dec temp0
    bne @init_vertical

    lda #(fireball_amount >> 1)
    sta temp0
    
@init_horizontal:
    lda #$FF
    sta up_fireballs, X
    inx
    sta up_fireballs, X
    inx
    lda #$07
    sta $205, Y
    lda #$01
    sta $206, Y
    tya
    adc #$04
    tay
    dec temp0
    bne @init_horizontal
    
    pla
    tay
    pla
    tax
    pla
    rts

draw_player:
    pha
    tya
    pha
    ldy x_player
    sty $203
    ldy y_player
    dey
    sty $200
    pla
    tay
    pla
    rts

draw_fireballs:
    pha
    txa
    pha
    tya
    pha

    lda #fireball_amount
    sta temp0
    lda #$00
    tax
    tay
@loop:
    lda up_fireballs, Y
    sta $207, X
    iny
    lda up_fireballs, Y
    sta $204, X
    dec $204, X
    iny
    inx
    inx
    inx
    inx
    dec temp0
    bne @loop

    pla
    tay
    pla
    tax
    pla
    rts

update_player:
    pha
    lda buttons
    and #$08 
    bne @up
    lda buttons
    and #$04 
    bne @down
    @horizontal:
    lda buttons
    and #$02 
    bne @left
    lda buttons
    and #$01 
    bne @right
    jmp @end
    @up:
    lda y_player
    cmp #player_min_y
    beq @horizontal
    dec y_player
    jmp @horizontal
    @down:
    lda y_player
    cmp #player_max_y
    beq @horizontal
    inc y_player
    jmp @horizontal
    @left:
    lda x_player
    cmp #player_min_x
    beq @end
    dec x_player
    jmp @end
    @right:
    lda x_player
    cmp #player_max_x
    beq @end
    inc x_player
    @end:
    pla
    rts

update_fireballs:
    pha
    txa
    pha
    tya
    pha

    lda #(fireball_amount >> 2)
    sta temp0
    lda #$FF
    ldx #$00

@update_up:
    cmp up_fireballs, X
    beq @@next
    .REPEAT fireball_speed
    dec up_fireballs + 1, X
    .ENDR
    ldy up_fireballs + 1, X
    cpy #fireball_min_y
    bne @@next
    sta up_fireballs, X
    sta up_fireballs + 1, X
@@next:
    inx
    inx
    dec temp0
    bne @update_up

    lda #(fireball_amount >> 2)
    sta temp0
    lda #$FF

@update_down:
    cmp up_fireballs, X
    beq @@next
    .REPEAT fireball_speed
    inc up_fireballs + 1, X
    .ENDR
    ldy up_fireballs + 1, X
    cpy #fireball_max_y
    bne @@next
    sta up_fireballs, X
    sta up_fireballs + 1, X
@@next:
    inx
    inx
    dec temp0
    bne @update_down

    lda #(fireball_amount >> 2)
    sta temp0
    lda #$FF

@update_right:
    cmp up_fireballs, X
    beq @@next
    .REPEAT fireball_speed
    inc up_fireballs, X
    .ENDR
    ldy up_fireballs, X
    cpy #fireball_max_x
    bne @@next
    sta up_fireballs, X
    sta up_fireballs + 1, X
@@next:
    inx
    inx
    dec temp0
    bne @update_right

    lda #(fireball_amount >> 2)
    sta temp0
    lda #$FF

@update_left:
    cmp up_fireballs, X
    beq @@next
    .REPEAT fireball_speed
    dec up_fireballs, X
    .ENDR
    ldy up_fireballs, X
    cpy #fireball_min_x
    bne @@next
    sta up_fireballs, X
    sta up_fireballs + 1, X
@@next:
    inx
    inx
    dec temp0
    bne @update_left

    pla
    tay
    pla
    tax
    pla
    rts

create_fireball:
    pha
    txa
    pha
    tya
    pha

    lda note_pulse
    bne @end

    ldx current_note
    dex
    lda up_pattern.W, X
    beq @down
    ldy up_index
    sta up_fireballs, Y
    lda #fireball_max_y
    sta up_fireballs + 1, Y
    inc up_index
    inc up_index
@down:
    lda down_pattern.W, X
    beq @right
    ldy down_index
    sta down_fireballs, Y
    lda #fireball_min_y
    sta down_fireballs + 1, Y
    inc down_index
    inc down_index
@right:
    lda right_pattern.W, X
    beq @left
    ldy right_index
    sta right_fireballs + 1, Y
    lda #fireball_min_x
    sta right_fireballs, Y
    inc right_index
    inc right_index
@left:
    lda left_pattern.W, X
    beq @setup_fix_indexes_loop
    ldy left_index
    sta left_fireballs + 1, Y
    lda #fireball_max_x
    sta left_fireballs, Y
    inc left_index
    inc left_index
@setup_fix_indexes_loop:
    lda #(size_of_fireball * fireball_amount >> 2)
    ldy #$00
    ldx #$04
@fix_indexes:
    cmp up_index - 1, X
    bne @@continue
    sty up_index - 1, X
@@continue:
    dex
    bne @fix_indexes
@end:
    pla
    tay
    pla
    tax
    pla
    rts

check_collision:
    pha
    txa
    pha
    tya
    pha

    clc
    lda x_player
    adc #$03
    sta temp0
    sta temp1
    ;inc temp1 ; Remove comment to make game easier
    lda y_player
    adc #$03
    sta temp2
    sta temp3
    ;inc temp3 ; Remove comment to make game easier


    ldx #(fireball_amount * size_of_fireball)
@loop:
    lda temp0
    cmp up_fireballs - size_of_fireball, X
    bcc @next
    lda temp2
    cmp up_fireballs - size_of_fireball + 1, X
    bcc @next
    lda up_fireballs - size_of_fireball, X
    adc #06
    cmp temp1
    bcc @next
    lda up_fireballs - size_of_fireball + 1, X
    adc #06
    cmp temp3
    bcc @next
    jmp @collides
@next:
    dex
    dex
    bne @loop

    clc
    jmp @end
@collides:
    sec
@end:
    pla
    tay
    pla
    tax
    pla
    rts

reset_song:
    pha
    lda #0
    sta note_pulse
    sta current_note
    pla
    rts

play_menu_song:
    pha
    jsr reset_song
    lda #$20
    sta pulse_limit
    lda #(menu_song1 & $FF)
    sta current_song1
    lda #(menu_song1 >> 8)
    sta (current_song1 + 1)
    lda #(menu_song2 & $FF)
    sta current_song2
    lda #(menu_song2 >> 8)
    sta (current_song2 + 1)
    pla
    rts

play_game_song:
    pha
    jsr reset_song
    lda #$10
    sta pulse_limit
    lda #(game_song1 & $FF)
    sta current_song1
    lda #(game_song1 >> 8)
    sta (current_song1 + 1)
    lda #(game_song2 & $FF)
    sta current_song2
    lda #(game_song2 >> 8)
    sta (current_song2 + 1)
    pla
    rts

play_lose_song:
    pha
    jsr reset_song
    lda #$08
    sta pulse_limit
    lda #(lose_song1 & $FF)
    sta current_song1
    lda #(lose_song1 >> 8)
    sta (current_song1 + 1)
    lda #(lose_song2 & $FF)
    sta current_song2
    lda #(lose_song2 >> 8)
    sta (current_song2 + 1)
    pla
    rts

play_end_song:
    pha
    jsr reset_song
    lda #$10
    sta pulse_limit
    lda #(end_song1 & $FF)
    sta current_song1
    lda #(end_song1 >> 8)
    sta (current_song1 + 1)
    lda #(end_song2 & $FF)
    sta current_song2
    lda #(end_song2 >> 8)
    sta (current_song2 + 1)
    pla
    rts

do_note:
    pha
    tya
    pha
    ldy note_pulse
    cpy pulse_limit
    bne @end
    ldy current_note
    lda (current_song1),Y
    tay
    lda periodTableHi.W,Y
    sta APUPULSE1HIGH.W
    lda periodTableLo.W,Y
    sta APUPULSE1LOW.W
    ldy current_note
    lda (current_song2),Y
    tay
    lda periodTableHi.W,Y
    sta APUPULSE2HIGH.W
    lda periodTableLo.W,Y
    sta APUPULSE2LOW.W
    inc current_note
    ldy #$FF
    sty note_pulse
    @end:
    inc note_pulse
    pla
    tay
    pla
    rts

menu_song1:
    .DB $2B, $2B, $2D, $2D, $29, $29, $29, $29, $27, $27, $29, $27, $26, $26, $26, $29
    .DB $2B, $2B, $2D, $2D, $2E, $2E, $30, $30, $32, $30, $2E, $30, $2D, $2D, $2D, $2D
    .DB $2B, $2B, $2D, $2D, $29, $29, $29, $29, $2B, $2B, $29, $2B, $2D, $2D, $2D, $2E
    .DB $32, $32, $33, $33, $35, $35, $37, $37, $3A, $3A, $3C, $3C, $3E, $3E, $3E, $3E
    .DB $3F, $3F, $3E, $3E, $39, $39, $3C, $3C, $3A, $3A, $39, $39, $37, $37, $37, $37
    .DB $3F, $3F, $3E, $3E, $39, $39, $3C, $3C, $3A, $3A, $3C, $3C, $3E, $3E, $3E, $3E
    .DB $3F, $3F, $3E, $3E, $39, $39, $3C, $3C, $3A, $3C, $3A, $39, $37, $37, $37, $37
    .DB $3F, $3F, $3F, $3E, $41, $41, $41, $3C, $3A, $3A, $3A, $3A, $3A, $3A, $3C, $3E
    .DB $3F, $3F, $3F, $3E, $41, $41, $3F, $45, $48, $45, $46, $42, $43, $3E, $3A, $37
    .DB $33, $35, $37, $39, $3C, $3A, $39, $37, $36, $37, $39, $36, $37, $32, $2E, $2B
    .DB $27, $26, $2B, $2D, $29, $30, $2E, $2D, $30, $32, $2D, $2D, $2B, $2B, $2B, $29
    .DB $27, $27, $27, $27, $27, $27, $27, $27, $29, $29, $29, $29, $29, $29, $29, $29
    .DB $26, $26, $26, $26, $26, $26, $26, $26, $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2B
    .DB $27, $27, $27, $27, $27, $27, $27, $27, $29, $29, $29, $29, $29, $29, $29, $29
    .DB $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2B, $29, $27, $26, $29, $27, $26, $24
    .DB $27, $29, $27, $26, $24, $22, $24, $24, $26, $26, $26, $27, $2A, $2A, $2A, $2D
menu_song2:
    .DB $1F, $1F, $1F, $1F, $1D, $1D, $1D, $1D, $1B, $1B, $1B, $1B, $1A, $1A, $1A, $1A
    .DB $1F, $1F, $1F, $1F, $1D, $1D, $1D, $1D, $1B, $1B, $1B, $1B, $1A, $1A, $1A, $1A
    .DB $1F, $1F, $1F, $1F, $1D, $1D, $1D, $1D, $1B, $1B, $1B, $1B, $1A, $1A, $1A, $1A
    .DB $1F, $1F, $1F, $1F, $1D, $1D, $1D, $1D, $1B, $1B, $1B, $1B, $1A, $1A, $1A, $1A
    .DB $1B, $1B, $1B, $1B, $1D, $1D, $1D, $1D, $16, $16, $16, $16, $1F, $1F, $1F, $1F
    .DB $1B, $1B, $1B, $1B, $1D, $1D, $1D, $1D, $16, $16, $16, $16, $1A, $1A, $1A, $1A
    .DB $1B, $16, $1B, $16, $1D, $18, $1D, $18, $16, $1D, $16, $1D, $1F, $1A, $1F, $1A
    .DB $1B, $16, $1B, $16, $1D, $18, $1D, $18, $16, $1D, $16, $1D, $16, $1D, $16, $1D
    .DB $1B, $00, $1B, $00, $1D, $00, $1D, $00, $1E, $00, $1E, $00, $1F, $00, $1F, $00
    .DB $1B, $00, $1B, $00, $1D, $00, $1D, $00, $1E, $00, $1E, $00, $1F, $00, $1F, $00
    .DB $1B, $00, $1B, $00, $1D, $00, $1D, $00, $1E, $00, $1E, $00, $1F, $00, $1F, $00
    .DB $1B, $00, $1F, $00, $22, $00, $26, $00, $1D, $00, $21, $00, $24, $00, $27, $00
    .DB $1A, $00, $1D, $00, $21, $00, $24, $00, $1F, $00, $22, $00, $26, $00, $29, $00
    .DB $1B, $00, $1F, $00, $22, $00, $26, $00, $1D, $00, $21, $00, $24, $00, $27, $00
    .DB $1A, $00, $1E, $00, $21, $00, $26, $00, $1F, $1F, $1F, $1F, $1D, $1D, $1D, $1D
    .DB $1B, $1B, $1B, $1B, $1D, $1D, $1D, $1D, $1A, $1A, $1A, $1A, $1E, $1E, $1E, $1E
game_song1:
    .DB $2A, $2A, $2A, $2A, $2D, $2D, $2D, $2D, $30, $30, $30, $30, $33, $33, $33, $33
    .DB $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33
    .DB $2B, $29, $2E, $2E, $2D, $32, $32, $32, $30, $30, $30, $2E, $2E, $2E, $2E, $2E
    .DB $30, $00, $30, $32, $33, $33, $32, $30, $31, $31, $34, $34, $32, $36, $39, $39
    .DB $37, $35, $3E, $3E, $3C, $41, $41, $41, $3F, $3F, $3F, $3E, $3E, $3E, $3E, $3E
    .DB $3C, $00, $3C, $3A, $3C, $3C, $3E, $3F, $40, $40, $3D, $3D, $3E, $3E, $39, $39
    .DB $37, $37, $35, $3A, $3A, $3A, $39, $39, $36, $36, $35, $39, $39, $39, $3A, $3C
    .DB $3E, $3E, $3E, $3C, $41, $41, $41, $3F, $3E, $42, $45, $45, $45, $45, $45, $45
    .DB $43, $3E, $3A, $3E, $3A, $37, $3A, $37, $32, $37, $32, $2E, $32, $2E, $2B, $2B
    .DB $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2B
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
game_song2:
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $1F, $26, $1F, $26, $1F, $26, $1F, $26, $22, $29, $22, $29, $22, $29, $22, $29
    .DB $24, $2B, $24, $2B, $24, $2B, $24, $2B, $21, $28, $21, $28, $26, $2D, $26, $2D
    .DB $1F, $26, $1F, $26, $1F, $26, $1F, $26, $22, $29, $22, $29, $22, $29, $22, $29
    .DB $24, $2B, $24, $2B, $24, $2B, $24, $2B, $21, $28, $21, $28, $26, $2D, $26, $2D
    .DB $1F, $26, $1F, $26, $1F, $26, $1F, $26, $1E, $26, $1E, $26, $1E, $26, $1E, $26
    .DB $1D, $26, $1D, $26, $1D, $26, $1D, $26, $1A, $26, $1A, $26, $1A, $26, $1A, $26
    .DB $1F, $00, $00, $00, $1F, $00, $00, $00, $1F, $00, $00, $00, $1F, $00, $1F, $1F
    .DB $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
lose_song1:
    .DB $37, $37, $37, $36, $35, $35, $35, $34, $33, $33, $33, $32, $31, $31, $31, $30
    .DB $2F, $2F, $2F, $2F, $2F, $2F, $2E, $2E, $2E, $2E, $2E, $2E, $2E, $2E, $2E, $2E
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $2E, $2E, $2E, $00, $2E, $2E, $2E, $00, $32, $32, $32, $00, $35, $35, $37, $37
    .DB $37, $37, $35, $35, $35, $35, $35, $35, $35, $35, $35, $35, $35, $35, $35, $35
    .DB $3A, $3A, $3A, $00, $3A, $3A, $3A, $00, $37, $37, $37, $00, $35, $35, $37, $37
    .DB $37, $37, $3A, $3A, $37, $37, $35, $35, $37, $37, $37, $00, $32, $32, $32, $00
    .DB $2E, $2E, $2E, $00, $2E, $2E, $2E, $00, $32, $32, $32, $00, $35, $35, $37, $37
    .DB $37, $37, $3A, $3A, $3A, $3A, $3A, $3A, $3A, $3A, $3A, $3A, $3A, $3A, $3A, $3A
    .DB $3C, $3C, $3C, $00, $3C, $3C, $3C, $00, $3C, $3C, $3C, $00, $39, $39, $3A, $3A
    .DB $3A, $3A, $3A, $3A, $3A, $3A, $3A, $3A, $46, $46, $46, $46, $46, $46, $46, $46
    .DB $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46
    .DB $47, $47, $47, $46, $45, $45, $45, $44, $43, $43, $43, $42, $41, $41, $41, $40
    .DB $3F, $3F, $3F, $3E, $3D, $3D, $3D, $3C, $3B, $3B, $3B, $3A, $39, $39, $39, $38
lose_song2:
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $22, $22, $22, $29, $2B, $2B, $2B, $29, $22, $22, $22, $29, $2B, $2B, $2B, $29
    .DB $22, $22, $22, $29, $2B, $2B, $2B, $29, $22, $22, $22, $29, $2B, $2B, $2B, $29
    .DB $1B, $1B, $1B, $22, $24, $24, $24, $22, $1B, $1B, $1B, $22, $24, $24, $24, $22
    .DB $22, $22, $22, $29, $2B, $2B, $2B, $29, $22, $22, $22, $29, $2B, $2B, $2B, $29
    .DB $1B, $1B, $1B, $22, $24, $24, $24, $22, $22, $22, $22, $29, $2B, $2B, $2B, $29
    .DB $22, $22, $22, $29, $2B, $2B, $2B, $29, $22, $22, $22, $29, $2B, $2B, $2B, $29
    .DB $1B, $1B, $1B, $22, $24, $24, $24, $22, $1B, $1B, $1B, $22, $24, $24, $24, $22
    .DB $1D, $1D, $1D, $24, $26, $26, $26, $24, $1D, $1D, $1D, $24, $26, $26, $26, $24
    .DB $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
end_song1:
    .DB $33, $33, $00, $33, $33, $37, $3A, $3A, $3A, $37, $37, $37, $39, $39, $39, $3C
    .DB $3C, $3C, $3C, $3C, $3C, $3C, $3C, $00, $3C, $3C, $3C, $3E, $3E, $3E, $3E, $3E
    .DB $3E, $3E, $3E, $3E, $3B, $3B, $3B, $37, $37, $37, $37, $37, $37, $35, $35, $35
    .DB $33, $33, $00, $33, $33, $35, $37, $37, $37, $35, $35, $00, $35, $35, $35, $33
    .DB $33, $33, $35, $35, $35, $33, $33, $33, $32, $32, $32, $32, $32, $32, $32, $32
    .DB $32, $30, $30, $30, $2F, $2F, $30, $32, $32, $32, $32, $32, $32, $32, $32, $32
    .DB $3F, $3F, $3F, $3E, $3E, $3E, $3C, $3C, $3C, $3A, $3A, $3A, $41, $41, $41, $3F
    .DB $3F, $3F, $3E, $3E, $3E, $3C, $3C, $3C, $3E, $3E, $3E, $3E, $3E, $3E, $3E, $3E
    .DB $3E, $3C, $3C, $3C, $3B, $3B, $3C, $3E, $3E, $3E, $3E, $3E, $3E, $3F, $3F, $00
    .DB $3F, $3F, $3F, $3E, $3E, $3E, $3C, $3C, $3C, $3A, $3A, $3A, $41, $41, $41, $3F
    .DB $3F, $3F, $41, $41, $41, $43, $43, $00, $43, $43, $43, $43, $43, $43, $43, $43
    .DB $43, $48, $48, $4A, $47, $47, $47, $47, $47, $47, $47, $47, $47, $45, $45, $47
    .DB $43, $43, $43, $41, $41, $41, $3F, $3F, $3F, $3E, $3E, $3E, $3C, $3C, $3C, $3A
    .DB $3A, $3A, $39, $39, $39, $37, $37, $00, $37, $37, $37, $37, $37, $37, $37, $37
    .DB $37, $37, $37, $37, $37, $37, $37, $37, $37, $37, $37, $37, $00, $00, $00, $00
    .DB $32, $00, $00, $00, $2F, $00, $00, $00, $2B, $00, $00, $00, $32, $00, $00, $00
end_song2:
    .DB $1B, $1F, $22, $1B, $1F, $22, $1B, $1F, $22, $1B, $1F, $22, $1D, $21, $24, $1D
    .DB $21, $24, $1D, $21, $24, $1D, $21, $24, $1F, $24, $26, $1F, $24, $26, $1F, $24
    .DB $26, $1F, $24, $26, $1F, $23, $26, $1F, $23, $26, $1F, $23, $26, $1F, $23, $26
    .DB $1B, $1F, $22, $1B, $1F, $22, $1B, $1F, $22, $1B, $1F, $22, $1D, $21, $24, $1D
    .DB $21, $24, $1D, $21, $24, $1D, $21, $24, $1F, $24, $26, $1F, $24, $26, $1F, $24
    .DB $26, $1F, $24, $26, $1F, $23, $26, $1F, $23, $26, $1F, $23, $26, $1F, $23, $26
    .DB $1B, $1F, $22, $1B, $1F, $22, $1B, $1F, $22, $1B, $1F, $22, $1D, $21, $24, $1D
    .DB $21, $24, $1D, $21, $24, $1D, $21, $24, $1F, $24, $26, $1F, $24, $26, $1F, $24
    .DB $26, $1F, $24, $26, $1F, $23, $26, $1F, $23, $26, $1F, $23, $26, $1F, $23, $26
    .DB $1B, $1F, $22, $1B, $1F, $22, $1B, $1F, $22, $1B, $1F, $22, $1D, $21, $24, $1D
    .DB $21, $24, $1D, $21, $24, $1D, $21, $24, $1F, $24, $26, $1F, $24, $26, $1F, $24
    .DB $26, $1F, $24, $26, $1F, $23, $26, $1F, $23, $26, $1F, $23, $26, $1F, $23, $26
    .DB $1B, $1B, $1B, $1B, $1B, $1B, $1B, $1B, $1B, $1B, $1B, $1B, $1D, $1D, $1D, $1D
    .DB $1D, $1D, $1D, $1D, $1D, $1D, $1D, $1D, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F
    .DB $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $00, $00, $00, $00
    .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
periodTableLo:
  .DB $f1, $7f, $13, $ad, $4d, $f3, $9d, $4c, $00, $b8, $74, $34
  .DB $f8, $bf, $89, $56, $26, $f9, $ce, $a6, $80, $5c, $3a, $1a
  .DB $fb, $df, $c4, $ab, $93, $7c, $67, $52, $3f, $2d, $1c, $0c
  .DB $fd, $ef, $e1, $d5, $c9, $bd, $b3, $a9, $9f, $96, $8e, $86
  .DB $7e, $77, $70, $6a, $64, $5e, $59, $54, $4f, $4b, $46, $42
  .DB $3f, $3b, $38, $34, $31, $2f, $2c, $29, $27, $25, $23, $21
  .DB $1f, $1d, $1b, $1a, $18, $17, $15, $14
periodTableHi:
  .DB $07, $07, $07, $06, $06, $05, $05, $05, $05, $04, $04, $04
  .DB $03, $03, $03, $03, $03, $02, $02, $02, $02, $02, $02, $02
  .DB $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
  .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .DB $00, $00, $00, $00, $00, $00, $00, $00

* CHR-ROM
.BANK 3 SLOT 5
* Pattern Table 0 (4KB)
.ORG $0000
.DSW 8, $0000 ; EMPTY
.DSB 8, $FF 
.DSB 8, $00 ; STRONG SQUARE
.DSB 8, $00 
.DSB 8, $FF ; LIGHT SQUARE
.DSW 8, $FFFF ; WHITE SQUARE
.DB $00, $3C, $3C, $3C, $7E, $FF, $FF, $FF, $00, $00, $18, $18, $18, $3C, $7E, $7E ; SPIKE1
.DB $00, $00, $18, $18, $18, $3C, $7E, $7E, $00, $3C, $3C, $3C, $7E, $FF, $FF, $FF ; SPIKE2
.DB $00, $08, $04, $00, $18, $60, $00, $00, $00, $0C, $0C, $00, $38, $70, $00, $00 ; CRACK1
.DB $00, $00, $C0, $20, $00, $02, $0C, $00, $00, $00, $E0, $60, $00, $06, $0E, $00 ; CRACK2
.DSW 320 , $0000
.DB $00, $3C, $24, $24, $24, $24, $24, $3C, $00, $3C, $24, $24, $24, $24, $24, $3C ; 0
.DB $00, $04, $04, $04, $04, $04, $04, $04, $00, $04, $04, $04, $04, $04, $04, $04 ; 1
.DB $00, $3C, $04, $04, $3C, $20, $20, $3C, $00, $3C, $04, $04, $3C, $20, $20, $3C ; 2
.DB $00, $3C, $04, $04, $3C, $04, $04, $3C, $00, $3C, $04, $04, $3C, $04, $04, $3C ; 3
.DB $00, $24, $24, $24, $3C, $04, $04, $04, $00, $24, $24, $24, $3C, $04, $04, $04 ; 4
.DB $00, $3C, $20, $20, $3C, $04, $04, $3C, $00, $3C, $20, $20, $3C, $04, $04, $3C ; 5
.DB $00, $3C, $20, $20, $3C, $24, $24, $3C, $00, $3C, $20, $20, $3C, $24, $24, $3C ; 6
.DB $00, $3C, $04, $04, $04, $04, $04, $04, $00, $3C, $04, $04, $04, $04, $04, $04 ; 7
.DB $00, $3C, $24, $24, $3C, $24, $24, $3C, $00, $3C, $24, $24, $3C, $24, $24, $3C ; 8
.DB $00, $3C, $24, $24, $3C, $04, $04, $3C, $00, $3C, $24, $24, $3C, $04, $04, $3C ; 9
.DSW 56 , $0000
.DB $00, $3C, $24, $24, $3C, $24, $24, $24, $00, $3C, $24, $24, $3C, $24, $24, $24 ; A
.DB $00, $38, $24, $24, $3C, $24, $24, $38, $00, $38, $24, $24, $3C, $24, $24, $38 ; B
.DB $00, $3C, $40, $40, $40, $40, $40, $3C, $00, $3C, $40, $40, $40, $40, $40, $3C ; C
.DB $00, $70, $48, $44, $44, $44, $48, $70, $00, $70, $48, $44, $44, $44, $48, $70 ; D
.DB $00, $7E, $40, $40, $7C, $40, $40, $7E, $00, $7E, $40, $40, $7C, $40, $40, $7E ; E
.DB $00, $7E, $40, $40, $7C, $40, $40, $40, $00, $7E, $40, $40, $7C, $40, $40, $40 ; F
.DB $00, $3C, $40, $40, $4C, $44, $44, $3C, $00, $3C, $40, $40, $4C, $44, $44, $3C ; G
.DB $00, $24, $24, $24, $3C, $24, $24, $24, $00, $24, $24, $24, $3C, $24, $24, $24 ; H
.DB $00, $1C, $08, $08, $08, $08, $08, $1C, $00, $1C, $08, $08, $08, $08, $08, $1C ; I
.DB $00, $38, $08, $08, $08, $08, $48, $30, $00, $38, $08, $08, $08, $08, $48, $30 ; J
.DB $00, $84, $88, $90, $C0, $90, $88, $84, $00, $84, $88, $90, $C0, $90, $88, $84 ; K
.DB $00, $20, $20, $20, $20, $20, $20, $3C, $00, $20, $20, $20, $20, $20, $20, $3C ; L
.DB $00, $22, $36, $2A, $2A, $22, $22, $22, $00, $22, $36, $2A, $2A, $22, $22, $22 ; M
.DB $00, $42, $62, $72, $5A, $4E, $46, $42, $00, $42, $62, $72, $5A, $4E, $46, $42 ; N
.DB $00, $18, $24, $42, $42, $42, $24, $18, $00, $18, $24, $42, $42, $42, $24, $18 ; O
.DB $00, $38, $24, $24, $38, $20, $20, $20, $00, $38, $24, $24, $38, $20, $20, $20 ; P
.DB $00, $18, $24, $42, $42, $4A, $24, $1A, $00, $18, $24, $42, $42, $4A, $24, $1A ; Q
.DB $00, $38, $24, $24, $38, $30, $28, $24, $00, $38, $24, $24, $38, $30, $28, $24 ; R
.DB $00, $1C, $20, $20, $1C, $02, $02, $1C, $00, $1C, $20, $20, $1C, $02, $02, $1C ; S
.DB $00, $3E, $08, $08, $08, $08, $08, $08, $00, $3E, $08, $08, $08, $08, $08, $08 ; T
.DB $00, $42, $42, $42, $42, $42, $42, $3C, $00, $42, $42, $42, $42, $42, $42, $3C ; U
.DB $00, $42, $42, $24, $24, $24, $18, $18, $00, $42, $42, $24, $24, $24, $18, $18 ; V
.DB $81, $81, $C3, $42, $59, $59, $24, $24, $81, $81, $C3, $42, $59, $59, $24, $24 ; W
.DB $00, $42, $42, $24, $18, $18, $24, $42, $00, $42, $42, $24, $18, $18, $24, $42 ; X
.DB $00, $22, $14, $14, $08, $08, $08, $08, $00, $22, $14, $14, $08, $08, $08, $08 ; Y
.DB $00, $7E, $06, $0C, $18, $30, $60, $7E, $00, $7E, $06, $0C, $18, $30, $60, $7E ; Z
.DSW 1320, $A5A5
* Pattern Table 1 (4KB)
.DB $3C, $7E, $DB, $FF, $DB, $E7, $7E, $3C, $00, $3C, $7E, $7E, $7E, $7E, $3C, $00 ; Smile
.DB $FF, $FF, $C3, $C3, $C3, $C3, $FF, $FF, $00, $00, $3C, $3C, $3C, $3C, $00, $00 ; Win Spot 1
.DB $FF, $FF, $FF, $E7, $E7, $FF, $FF, $FF, $FF, $81, $81, $99, $99, $81, $81, $FF ; Win Spot 2
.DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $C3, $C3, $C3, $C3, $FF, $FF ; Win Spot 3
.DB $00, $7E, $7E, $7E, $7E, $7E, $7E, $00, $FF, $FF, $FF, $E7, $E7, $FF, $FF, $FF ; Win Spot 4
.DB $00, $00, $3C, $3C, $3C, $3C, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; Win Spot 5
.DB $FF, $81, $81, $99, $99, $81, $81, $FF, $00, $7E, $7E, $7E, $7E, $7E, $7E, $00 ; Win Spot 6
.DB $00, $18, $3C, $7E, $7E, $3C, $18, $00, $00, $00, $18, $3C, $3C, $18, $00, $00 ; Ball
.DB $C3, $66, $3C, $18, $18, $3C, $66, $C3, $00, $00, $00, $00, $00, $00, $00, $00 ; Dead
.DSW 1976, $5A5A