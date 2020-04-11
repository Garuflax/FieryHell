/*NES MEMORY consists of 8 256-byte pages ($0000-$07FF)
Zero-Page or "Direct Page" $0000-$00FF.
Stack Page $0100-$01FF.
OAM Page $0200-$02FF.
Normal RAM $0300-$07FF.
*/


* Defining the memory architecture of the NES
.MEMORYMAP
* Define the Zero-Page as the Standard-Slot
DEFAULTSLOT 1
* Slot for iNES-Header
SLOTSIZE $10
SLOT 0 $0
* Slot for Zero-Page (256B)
SLOTSIZE $100
SLOT 1 $0
* Slot for Normal RAM (1.5KB)
SLOTSIZE $500
SLOT 2 $300 
* LOWER BANK PRG-ROM (16KB)
SLOTSIZE $4000
SLOT 3 $8000
* UPPER BANK PRG-ROM (16KB)
SLOTSIZE $4000
SLOT 4 $C000
* CHR-ROM (8KB)
SLOTSIZE $2000
SLOT 5 $0
.ENDME

* Our compiled NES-ROM consists of
;  -1x iNES-Header (16B)
;  -2x PRG-ROM (16KB)
;  -1x CHR-ROM (8KB)
.ROMBANKMAP
; 4 banks
BANKSTOTAL 4
; iNES-Header
BANKSIZE $10
BANKS 1
; PRG-ROM
BANKSIZE $4000 
BANKS 2
; CHR-ROM
BANKSIZE $2000 
BANKS 1
.ENDRO