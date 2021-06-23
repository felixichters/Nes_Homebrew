background_engine:	
 @save_registers:
        pha
        txa 
        pha
        tya 
        pha
:
    BIT $2002
    BPL :-
	lda #%10001000                      		;increment mode x32
    sta PPU_CTRL
		ldy #$00								;counter vorbereiten
		lda (room_ptr),y						;breite laden
		sta width_room							;in breite 
		iny
		lda (room_ptr),y						;höhe laden
		sta height_room							;in höhe
		lda ppu_addr_high					    ;PPU adresse inint
		sta PPU_ADDR
		lda ppu_addr_low
		sta PPU_ADDR
		iny
		ldx #$00								;x für vertical count vorbereiten 
		stx col_counter
		stx line_counter
		@load_horizontally:
			lda (room_ptr),y					 ;lade acuumulator mit raum data an der stelle y  
			sta PPU_DATA						;in PPU laden 
			iny									;inkrementiere horiyontalen counter
			inc col_counter
			lda col_counter
			cmp width_room						;vergleiche horizantalen counter mit aktueller breite
			bne @load_horizontally				;wenn nicht gleich dann nochmal
			lda #$00
			sta col_counter
			ldx #$00
		@load_vertical:
			inc ppu_addr_low					;incrementiere startaddresse um 1 
			inx 								;incrementiere counter der 32 x hoch zählt
			lda ppu_addr_low					;lade PPU adresse in a für folgenden vergelich
			cmp #$FF							;vergleiche mit 0 (check overflow)
			beq :+								;wenn overflow springe zur nächsten funktion
			cpx #$20							;vergleiche x mit 32 (eine line)
			bne @load_vertical					;wenn nicht gleich, nochmal
			inc line_counter					;incrementiere line counter 
			lda ppu_addr_high				    ;PPU adresse neu initialisieren
			sta PPU_ADDR						;"
			lda ppu_addr_low					;"
			sta PPU_ADDR						;"
			lda line_counter					;lade a mit line counter für folgenden vergleich
			cmp height_room						;vergleiche line counter mit mit der momentanen höhe
			bne @load_horizontally				;wenn nicht gleich dann alles nochmal
			@get_registers:
       		pla
        	tay 
        	pla
        	tax 
        	pla
			rts
		:
			inc ppu_addr_high				    ;bei overflow high PPU adresse incrementieren
			jmp @load_vertical				;weitermachen