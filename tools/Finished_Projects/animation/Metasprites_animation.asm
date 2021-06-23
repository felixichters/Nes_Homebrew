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
.segment "STARTUP"
.segment "CODE"
;Init Code *******************************************************************************
	.include "RESET.asm"
	.include "Constants.asm"
	.include "Palette.asm"
	Pointer_init_MS_1:
		LDA #<SPRITE_1_Data						;pointer inint
		STA sprite_ptr							;"
		LDA #>SPRITE_1_Data						;"
		STA sprite_ptr+1						;"
		LDX #$00								;counter für pointer&adresse vorbereiten
		JSR Load_Sprites						;lade sprites
		         
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
			PHA									;Push Y auf den Stack
		
		@do_NMI_stuff:
		INC frame_counter
		LDX frame_counter
		CPX #$40
		BNE :+
		LDA #$00
		STA frame_counter
		:
		
		JSR get_controller_input
		JSR Player_handling
		LDA #$02
		STA $4014
		@get_registers:
			PLA 								;hole Y von STAck
			TAY									;Spichere Y
			PLA									;hole X von STAck
			TAX									;Speichere X
			PLA									;hole A von STAck
			RTI									;interrupt ende 
	
	.include "load_sprites.asm"
	.include "Controller.asm"
	;.include "Collision.asm"
	.include "Player_engine.asm"
	
	SPRITE_1_Data:
		.byte $F0,$01,$01,$03
	SPRITE_1_walking:
		.byte $01,$02,$03,$04,$05,$06,$07

	SPRITE_1_jumping:
		.byte $07,$07,$07,$07
	
	SPRITE_1_standing:
		.byte $02
			
	PALETTE_DATA:
		.byte $3F,$3F,$3F,$3F,  $3F,$00,$30,$30, $3F,$00,$30,$30,  $3F,$00,$30,$30 				;background data
		.byte $3F,$11,$14,$17,  $3F,$11,$14,$17, $3F,$11,$14,$17,  $3F,$11,$14,$17 	 	 		;sprite data
		
.segment "VECTORS"
	.word NMI									;V-Blank interrupt
	.word RESET 								;Reset interrupt
.segment "CHARS"
	.incbin "CHR.chr"
;------------------------------------------------------------------- 
