;------------------------------------------------------------------- 
;NES ASM Project: Metasprites_animation 
;Generated at 01.10.2020 12:47:57,77 
;-------------------------------------------------------------------  

.segment "HEADER" 
	.BYTE "NES", $1A
	.BYTE $02         							; 1 or 2 for NROM-128 or NROM-256 respectively
	.BYTE $01         							; 8 KiB CHR ROM
	.BYTE $00       							; Mapper 0; $00 or $01 for horizontal or veRTIcal mirroring respectively
	.BYTE $08       							; Mapper 0; NES 2.0
	.BYTE $00      				   				; No submapper
	.BYTE $00       							; PRG ROM not 4 MiB or larger
	.BYTE $00     								; No PRG RAM
	.BYTE $00     								; No CHR RAM
	.BYTE $01     								; 0 or 1 for NTSC or PAL respectively
	.BYTE $00     								; No special PPU
	
.segment "ZEROPAGE"
	.include "variables.asm"
.segment "CODE"
;Init Code *******************************************************************************
	.include "RESET.asm"
	.include "Constants.asm"
	.include "Palette.asm"
	
	Pointer_init_MS_1:
		LDA #<METASPRITE_1
		STA MS_pointer
		LDA #>METASPRITE_1
		STA MS_pointer+1
		JSR Load_Sprites
		
	;Pointer_init_MS_2:	
	;	LDA #<METASPRITE_2
	;	STA MS_pointer
	;	LDA #>METASPRITE_2
	;	STA MS_pointer+1
	;	JSR Load_Sprites
		
	run_game:
		CLI          					 		;interrupts anschalten
		LDA #%10001000    					    ;NMI anschalten
		STA $2000
		LDA #%00011110      				    ;background anschalten, sprites anschalten
		STA $2001
		LDA #$00							    ;scrolling aus 
		STA $2005							    ;x "
		STA $2005								;y "
	
	
	;***********************************************************************************					
	forever: 
		jmp forever
	;**********************************************************************************
	
	NMI:
		@save_registers:						
			PHA 								;Push Accumulator auf den STAck					
			TXA 								;Transfer X nahc A
			PHA									;Push X auf den STAck
			TYA									;Transfer Y nach A 
			PHA									;Push Y auf den STAck
		
		@do_NMI_stuff:
		
		INC frame_counter
		LDX frame_counter
		CPX #$30
		BNE :+
		LDA #$00
		STA frame_counter
		:
		JSR Controller
		JSR Player_engine
		@get_registers:
			PLA 								;hole Y von STAck
			TAY									;Spichere Y
			PLA									;hole X von STAck
			TAX									;Speichere X
			PLA									;hole A von STAck
			RTI									;interrupt ende 
	
	
	.include "load_sprites.asm"
	.include "Controller.asm"
	.include "Collision.asm"
	
	
	METASPRITE_1:
		.byte $F5,$00,$01,$01,  $F5,$01,$01,$09													;Metasprite 1 Data(y,tile,palette,x)
		.byte $FD,$02,$01,$01,  $FD,$03,$01,$09													;"
		
	METASPRITE_1_walking:
		.byte $04,$05    												;animation Frame tiles 
		.byte $06,$07
		
		.byte $08,$09
		.byte $0A,$0B 
		
	METASPRITE_1_jumping:
	METASPRITE_2:
	METASPRITE_3:
		
.segment "VECTORS"
	.word NMI									;V-Blank interrupt
	.word RESET 								;Reset interrupt
.segment "CHARS"
	.incbin "CHR.chr"
;------------------------------------------------------------------- 
