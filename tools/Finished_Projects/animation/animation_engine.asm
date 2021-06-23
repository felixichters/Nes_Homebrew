        Player_handling:

        @init:
            LDA #<SPRITE_1_walking					;pointer inint
	    	STA animation_ptr						;"
	    	LDA #>SPRITE_1_walking					;"
	    	STA animation_ptr+1						;"
            lda #<SPRITE_1_TILE
            sta animation_addr_ptr
            lda #<SPRITE_1_TILE
            sta animation_addr_ptr+1
            lda #$06                                ;lade a mit dividator 2^4 
            sta divison                             ;specihere in division 
            lda #$04                                ;lade overflow tile 
            sta overflow_tile                       ;

            lda buttons 
            cmp #$00
            beq @standing

        @right:                         
            lda #%00000001
            and buttons
            beq :+
            inc SPRITE_1_X
            
            lda #%00000001
            sta SPRITE_1_ATTR
          
	    	ldy current_tile_P1_right               ;lade y mit aktuellem frame tile von rechts   
            sty current_animation_tile_counter         
	    	JSR animation   						;animation check
            sty current_tile_P1_right               ;speichere das aktulle tile in current tile player 1 
            jmp @left
            :
                ldy #$00
                sty current_tile_P1_right
                
                
        @left:
            lda #%00000010
            and buttons
            beq :+
            dec SPRITE_1_X

            lda #%01000001
            sta SPRITE_1_ATTR

            ldy current_tile_P1_left
            sty current_animation_tile_counter
            jsr animation
            sty current_tile_P1_left
            jmp @down
            :
                ldy #$00
                sty current_tile_P1_left

            
        @down:
            lda #%00000100
            and buttons
            beq @up
            inc SPRITE_1_Y
        @up:
            lda #%00001000
            and buttons
            beq @end
            dec SPRITE_1_Y
        
        @standing:
            lda #$00
            sta current_tile_P1_left
            sta current_tile_P1_right
            sta SPRITE_1_TILE

        @end:
            RTS



animation: 
    ldx #$00
    lda #$40                            ;lade a mit 60
    sta tmp                             ;speichere a in temporärem speicer 
    @check_is_valid_animation:
        lsr tmp                             ;60/2 -> 60/4 ....
        inx                                 ;incrementiere y (division counter)
        cpx divison                         ;vergleiche durchlaufsvariable mit division
        bne @check_is_valid_animation       ;wenn nicht gleich dann nochaml 
        :
        lda frame_counter                   ;lade a mit aktuellem frame 
        cmp tmp                             ;verglecihe aktuellen frame mit division
        beq @do_animation                   ;wenn gleich dann animation
        lda tmp                             ;lade a mit divivsion 
        clc                                 ;clear carry 
        adc tmp                             ;tmp+tmp
        sta tmp                             ;speichere neuen tmp wert in tmp 
        cmp #$40                            ;verglecihe tmp mit 64 
        bne :-                              ;wenn nicht gleich dann nochmal checlen 
        jmp @end                            ;wenn keiner der divisions werte gleich dem aktuellem frame war, dann ende

    @do_animation:
        ldy current_animation_tile_counter  ;lade a mit dem aktuellem animations frame status 
        lda (animation_ptr),y               ;lade a mit den animations tiles 
        sta $0201                           ;speicher a an die richtige adresse 
        iny                                 ;incremnetiere y 
        cpy overflow_tile
        bne @end 
        ldy #$00
    @end:
        rts                                 ;return 