.segment "HEADER"
	.byte "NES", $1A
	.byte $02         							; 1 or 2 for NROM-128 or NROM-256 respectively
	.byte $01         							; 8 KiB CHR ROM
	.byte $00       							; Mapper 0; $00 or $01 for horizontal or vertical mirroring respectively
	.byte $08       							; Mapper 0; NES 2.0
	.byte $00      				   				; No submapper
	.byte $00       							; PRG ROM not 4 MiB or larger
	.byte $00     								; No PRG RAM
	.byte $00     								; No CHR RAM
	.byte $01     								; 0 or 1 for NTSC or PAL respectively
	.byte $00     								; No special PPU
												;-----------------------------------------
.segment "ZEROPAGE"
	PPU_address_low: .res 1						;PPU addresse für $2006(bg)
	PPU_address_high: .res 1 					;"
	line_counter: .res 1						;line counter für background lade funktion(bg)
	height_room: .res 1							;höhe des raums (bg)
	width_room: .res 1 							;breite des raums(bg)
	nt_pointer: .res 2 							;nametable pointer (2bytes)(bg)
	col_counter: .res 1							;spalten counter 
	tmp: .res 1									
	buttons: .res 1 											;----------------------------------------
.segment "STARTUP"
												;---------------------------------------
.segment "CODE"
;--------------------------------------------------------------------------------------
	RESET:
		sei 									;setze interrupt-flag
		cld 									;dezimal ausschalten
			
		lda #$40								;64dec laden
		sta $4017								;nach 4017 (frame counter control(APU)) speichern
		
		ldx #$FF								;x = FF 
		txs										;x auf stack
		inx										;x->00
		
		stx $2000								;PPUCTRL alles auf 0 (NMI usw. ausschalten)
		stx $2001								;PPUMASK ales auf 0 (background und sprite sausschalten)
	
		stx $4010								;IRQ ausschalten (APU)
	
		jsr wait_vblank
		txa										;schreibe 00 in accumulator
		
	clearmemory:
		sta $0000, X 							; $0000 => $00FF (1byte)
		sta $0100, X 							; $0100 => $01FF
		sta $0300, X							;...
		sta $0400, X
		sta $0500, X
		sta $0600, X
		sta $0700, X
		lda #$FF
		sta $0200, X 							; $0200 => $02FF
		lda #$00
		inx
		bne clearmemory
		ldx #$00
		jsr wait_vblank
	;--------------------------------------------------------------------------------
	Constants:
		SPRITE1X = $0203
		SPRITE1Y = $0200
		
	palette_config:
		lda #$3F								;PPU adresse vorbereiten
		sta $2006
		lda #$00
		sta $2006
		
		lda #$00
		sta $2000
		ldx #$00
	load_palette:
		lda palette_data,x						;palette laden
		sta $2007
		inx
		cpx #$20								;32 palettten werte laden 
		bne load_palette
	
		jsr wait_vblank
		ldx #$00
		
	make_screen_1:
		lda #<room_1							;room 1 data low byte 
		sta nt_pointer						    ;low byte
		lda #>room_1							;room 1 data high byte 
		sta nt_pointer+1					    ;high byte
		lda #$20								;start adresse 2020
		sta PPU_address_high
		lda #$50
		sta PPU_address_low
		jsr load_background
		jsr load_sprites
		
	make_screen_2:
		lda #<room_2							;room 1 data low byte 
		sta nt_pointer						    ;low byte
		lda #>room_2							;room 1 data high byte 
		sta nt_pointer+1					    ;high byte
		lda #$22								;start adresse 2020
		sta PPU_address_high
		lda #$48
		sta PPU_address_low
		jsr load_background
		ldx #$00
		JSR wait_vblank
		
	load_attribute:
		lda #$23
		sta $2006
		lda #$C0
		sta $2006
		:
		lda attributes
		sta $2007
		inx
		cpx #$40
		bne :-
	
		ldx #$00
	load_sprites:
		lda sprite_data,x
		sta $0200,x
		inx 
		cpx #$04
		bne load_sprites
	
	run_game:
		cli          					 		;interrupts anschalten

		lda #%10001000    					    ;NMI anschalten
		sta $2000
   
		lda #%00011110      				    ;background anschalten, sprites anschalten
		sta $2001
		
		lda #$00							    ;scrolling aus 
		sta $2005							    ;x
		sta $2005							    ;y
	
	Controller: 
		LDA #$01
		STA $4016
		LDX #$00
		STX $4016
		
		@controller_loop:
			LDA $4016
			LSR 
			ROL buttons
			INX 
			CPX #$08
			BNE @controller_loop
			
			@check_a:
				LDA #%10000000
				AND buttons
				BEQ @check_b
				
			@check_b:
				LDA #%01000000
				AND buttons
				BEQ @check_up
				
			@check_up:
				LDA #%00001000
				AND buttons
				BEQ @check_down				
				DEC SPRITE1Y
				LDX SPRITE1X
				LDY SPRITE1Y
				JSR check_collision
				BEQ @check_down
				INC SPRITE1Y
			
			@check_down:
				LDA #%00000100
				AND buttons
				BEQ @check_left
				INC SPRITE1Y
				LDX SPRITE1X
				LDY SPRITE1Y
				JSR check_collision
				BEQ @check_left
				DEC SPRITE1Y
				
			@check_left:
				LDA #%00000010
				AND buttons
				BEQ @check_right
				DEC SPRITE1X
				LDX SPRITE1X
				LDY SPRITE1Y
				JSR check_collision
				BEQ @check_right
				INC SPRITE1X
				
			@check_right:
				LDA #%00000001
				AND buttons
				BEQ forever
				INC SPRITE1X
				LDX SPRITE1X
				LDY SPRITE1Y
				JSR check_collision
				BEQ forever
				DEC SPRITE1X
						
	forever: 
		jmp forever
	
	
	NMI:
		@save_registers:
			pha 
			txa 
			pha
			tya
			pha
		@sprite_DMA:
			lda #$02
			sta $4014
		@check_controller:
			JSR Controller
		@nmi_end:
			pla 
			tay
			pla
			tax
			pla
			rti

;----------------------------------------------------------------------------------------------
	load_background:	
		
		ldy #$00								;counter vorbereiten
		lda (nt_pointer),y						;breite laden
		sta width_room							;in breite 
		iny
		lda (nt_pointer),y						;höhe laden
		sta height_room							;in höhe
		
		lda PPU_address_high					;PPU adresse inint
		sta $2006
		lda PPU_address_low
		sta $2006 
		
		iny
		ldx #$00								;x für vertical count vorbereiten 
		stx col_counter
		stx line_counter
		@load_horizontally:
			lda (nt_pointer),y					;lade acuumulator mit raum data an der stelle y  
			sta $2007							;in PPU laden 
			iny									;inkrementiere horiyontalen counter
			inc col_counter
			lda col_counter
			cmp width_room						;vergleiche horizantalen counter mit aktueller breite
			bne @load_horizontally				;wenn nicht gleich dann nochmal
			jsr wait_vblank
			lda #$00
			sta col_counter
			ldx #$00
		@load_vertical:
		
			inc PPU_address_low					;incrementiere startaddresse um 1 
												;incrementiere counter der 32 x hoch zählt
			lda PPU_address_low					;lade PPU adresse in a für folgenden vergelich
			cmp #$00							;vergleiche mit 0 (check overflow)
			beq :+								;wenn overflow springe zur nächsten funktion
			inx
			cpx #$20							;vergleiche x mit 32 (eine line)
			bne @load_vertical					;wenn nicht gleich, nochmal
			
			inc line_counter					;incrementiere line counter 
			lda PPU_address_high				;PPU adresse neu initialisieren
			sta $2006							;"
			lda PPU_address_low					;"
			sta $2006							;"
			
			lda line_counter					;lade a mit line counter für folgenden vergleich
			cmp height_room						;vergleiche line counter mit mit der momentanen höhe
			bne @load_horizontally				;wenn nicht gleich dann alles nochmal
			rts
			
		:
			inc PPU_address_high				;bei overflow high PPU adresse incrementieren
			jmp @load_horizontally				;weitermachen
		
	
	check_collision:
		TXA 
		LSR
		LSR 
		LSR
		LSR 
		LSR
		LSR 
		STA tmp
		TYA 
		LSR 
		LSR 
		LSR
		ASL
		ASL
		CLC 
		ADC tmp
		TAY 										;BYte index
		 
		TXA 
		LSR 
		LSR 
		LSR 
		AND #%00000111 
		TAX 										;Bitsmask index 
		
		LDA collsion_map,Y 
		AND BitMask,X 
		
		RTS
		
		
	;sprite x = 3*right shift -> tile pos |000|00000 <-
	;bit mask an der stelle new tile pos = position 
	;-> byte in collision map herausfinden
	;3*right shift 
	;  
	sprite_data:
		.byte $00,$00,$01,$50
		
	room_1:
		.byte $0E,$05
		.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
		.byte $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 
		.byte $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 
		.byte $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 
		.byte $00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 
	
	room_2:
		.byte $0E,$05
		.byte $02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02
		.byte $02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02 
		.byte $02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02 
		.byte $02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02 
		.byte $02,$01,$01,$04,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02 
	
					
	;------------------------------------------------------------------------
	attributes:
		.byte %00000000						;attribute data
		
	;----------------------------------------------------------------------------------------------------------------------------------------
	palette_data:
		.byte $3F,$00,$30,$30,  $3F,$00,$30,$30 , $3F,$00,$30,$30,  $3F,$00,$30,$30 				;background data
		.byte $3F,$11,$14,$17,  $3F,$11,$14,$17, $3F,$11,$14,$17,  $3F,$11,$14,$17 				;sprite data
	
	wait_vblank:
		:
		bit $2002
		bpl :-
		rts
	
	
	collsion_map:
		.byte %00010000, %00000000, %00000000, %00000100
		.byte %00010000, %00000000, %00000000, %00000100
		.byte %00010000, %00000000, %11111111, %11111100
		.byte %00010000, %00000000, %00000000, %00001000
		.byte %00010000, %00000000, %00000000, %00001000
		.byte %11111111, %11111111, %11111111, %11111111
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		.byte %00010000, %00000000, %00000000, %00000000
		
	BitMask:
		.BYTE %10000000
		.BYTE %01000000
		.BYTE %00100000
		.BYTE %00010000
		.BYTE %00001000
		.BYTE %00000100
		.BYTE %00000010
		.BYTE %00000001
	;-----------------------------------------------------------------------------------------------------------------------------------------	
.segment "VECTORS"
	.word NMI									;V-Blank interrupt
	.word RESET 								;Reset interrupt
												;---------------------------------------
.segment "CHARS"
	.incbin"CHR.chr"							;CHR ROM include
												;-------------------------------------------