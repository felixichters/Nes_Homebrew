       Player_handling:
        lda buttons 
        cmp #$00
        beq @standing

        @check_right:                         
            lda #%00000001
            and buttons
            beq @check_left
            
            lda #$00
            sta tile_count_p1_left
            sta x_input_counter_left

            inc SPRITE_1_X
            inc x_input_counter_right

            ldx x_input_counter_right
            cpx #$04 
            bne @check_left

            ldx #$00
            stx x_input_counter_right

            ldy tile_count_p1_right
            cpy #$06
            bne :+
            ldy #$00
            sty tile_count_p1_right

            :
            lda #%00000001
            sta SPRITE_1_ATTR
            lda SPRITE_1_walking,y 
            sta $0201
            inc tile_count_p1_right

        @check_left:
            lda #%00000010
            and buttons
			beq @check_down
            
            lda #$00
            sta tile_count_p1_right
            sta x_input_counter_right

            dec SPRITE_1_X
            inc x_input_counter_left

            ldx x_input_counter_left
            cpx #$04 
            bne @check_down

            ldx #$00
            stx x_input_counter_left

            ldy tile_count_p1_left
            cpy #$06
            bne :+
            ldy #$00
            sty tile_count_p1_left

            :
            lda #%01000001
            sta SPRITE_1_ATTR
            lda SPRITE_1_walking,y 
            sta $0201
            inc tile_count_p1_left
        
        @check_down:
            lda #%00000100
            and buttons
            beq @check_up
            inc SPRITE_1_Y
        @check_up:
            lda #%00001000
            and buttons
            beq @end
            dec SPRITE_1_Y
        
        @standing:
            lda #$00
            sta SPRITE_1_TILE
        @end:
            RTS
