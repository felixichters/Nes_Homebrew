;------------------------------------------------------------------- 
;Author: Felix
;NES NRom Project: CONTROL 
;Generated at 14.10.2020 23:45:20,25 
;-------------------------------------------------------------------  

.segment "HEADER" ;*******************************************************************************************************************
	.byte "NES", $1A
	.byte $02         							; 1 or 2 for NROM-128 or NROM-256 respectively
	.byte $01         							; 8 KiB CHR ROM
	.byte $00       							; Mapper 0; $00 or $01 for horizontal or veRTIcal mirroring respectively
	.byte $08       							; Mapper 0; NES 2.0
	.byte $00      				   				; No submapper
	.byte $00       							; PRG ROM not 4 MiB or larger
	.byte $00     								; No PRG RAM
	.byte $00     								; No CHR RAM
	.byte $01     								; 0 or 1 for NTSC or PAL respectively
	.byte $00     								; No special PPU

.segment "ZEROPAGE";*******************************************************************************************************************
	.include "ZEROPAGE_VARIABLES.asm"

.segment "STARTUP";*******************************************************************************************************************
	.include "RESET.asm"						;reset/startup interruptionsroutine

.segment "CODE";************************************************************************************************************************
	.include "CONSTANTS.asm"					;konstanten wie Adressen
	.include "FIRST_SCREEN.asm"					;ersten Bildschirm vorbereiten  
	.include "LEVEL_SELECTION.asm"				;level auswahl über user input 
	.include "GAME_LOOP.asm"					;main game loop (engine etc.)
	.include "NMI.asm"							;V-Blank interruptionsroutine
	.include "FUNCTIONS.asm"
.segment "RODATA"
	.include "DATA.asm"				     		;arrays 
.segment "VECTORS";*******************************************************************************************************************
	.word NMI									;V-Blank interrupt
	.word RESET 								;Reset interrupt

.segment "CHARS";*******************************************************************************************************************
	.incbin "chr.chr"
;------------------------------------------------------------------- 
