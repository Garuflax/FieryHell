################################################################################
# VARIABLES                                                                    #
################################################################################

CLEANABLE_OBJS = Fiery_Hell.nes Fiery_Hell.o

ASSEMBLER = wla-6502
LINKER = wlalink
EMU = higan

################################################################################
# RULES                                                                        #
################################################################################

.PHONY: all run clean

all: Fiery_Hell.nes

run: Fiery_Hell.nes
	$(EMU) Fiery_Hell.nes

debug: Fiery_Hell.nes
	mame nes -cart Fiery_Hell.nes -debug

Fiery_Hell.nes: Fiery_Hell.link src/Fiery_Hell.asm
	 cd src && $(ASSEMBLER) -o ../Fiery_Hell.o Fiery_Hell.asm && cd ..
	 $(LINKER) -r Fiery_Hell.link Fiery_Hell.nes

clean:
	-rm $(CLEANABLE_OBJS)
