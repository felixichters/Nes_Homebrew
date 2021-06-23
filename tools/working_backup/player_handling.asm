;ÜBERARBEITEN!!!!!!!!!!!!!!!!!!!!!!
;tmp = tile counter left 
;tpm1 = tile counter right 
;tmp2 = input left 
;tmp3 = input right 
;tmp4 = buttons 
check_players:
    lda #<SPRITE_1_Y
    sta sprite_ptr
    lda #>SPRITE_1_Y
    sta sprite_ptr+1
    lda tile_count_left_p1
    sta tmp
    lda tile_count_right_p1
    sta tmp1
    lda input_left_p1
    sta tmp2
    lda input_right_p1
    sta tmp3
    lda buttons1
    sta tmp4

    jsr player_handling

    lda tmp 
    sta tile_count_left_p1
    lda tmp1 
    sta tile_count_right_p1
    lda tmp2 
    sta input_left_p1
    lda tmp3
    sta input_right_p1
    rts 
    
check_p2:

player_handling:
    lda frame
    bne :+
    rts
    : 
    lda tmp4
    cmp #$00
    bne @check_right
    @standing:
       lda #$01
       ldy #$01
       sta (sprite_ptr),y
       dec frame
       rts

    @check_right:                       ;walk right                
        lda #BUTTON_RIGHT
        and tmp4
        beq @check_left
        lda #$00
        sta tmp
        sta tmp2
        ldy #$03
        lda (sprite_ptr),y
        tax 
        inx
        inx
        ldy #$00
        lda (sprite_ptr),y
        tay
        jsr collision
        bne :+        
        ldy #$03 
        lda (sprite_ptr),y 
        tax 
        inx 
        txa 
        sta (sprite_ptr),y 
        :
        inc tmp3
        ldx tmp3
        cpx #$04 
        bne @check_left
        ldx #$00
        stx tmp3
        ldy tmp1
        cpy #$03
        bne :+
        ldy #$00
        sty tmp1
        : 
        lda #%00000001
        ldy #$02
        sta (sprite_ptr),y
        ldy tmp1 
        lda sprite_p1_walking,y 
        ldy #$01
        sta (sprite_ptr),y
        inc tmp1

    @check_left:                        ;walk left
        lda #BUTTON_LEFT
        and tmp4
    	beq @check_down

        lda #$00
        sta tmp1
        sta tmp3
        ldy #$03
        lda (sprite_ptr),y
        tax 
        dex
        ldy #$00
        lda (sprite_ptr),y
        tay 
        jsr collision
        bne :+
        ldy #$03
        lda (sprite_ptr),y 
        tax 
        dex 
        txa 
        sta (sprite_ptr),y 
        :
        inc tmp2
        ldx tmp2
        cpx #$04
        bne @check_down
        ldx #$00
        stx tmp2
        ldy tmp
        cpy #$03
        bne :+
        ldy #$00
        sty tmp
        :
        lda #%01000001
        ldy #$02
        sta (sprite_ptr),y
        ldy tmp 
        lda sprite_p1_walking,y 
        ldy #$01
        sta (sprite_ptr),y 
        inc tmp
        
    @check_down:                            
    @check_up:                              ;check door 
        lda #BUTTON_UP
        and tmp4
        beq @end

        ldy #$03 
        lda (sprite_ptr),y 
        tax 
        ldy #$00
        lda (sprite_ptr),y 
        sta current_y

        jsr door_engine 
        
        ldy #$00 
        sta (sprite_ptr),y 
        jmp @end

    @check_start:                         ;pause 
    @check_select:                        ;?
    @check_b_and_left:                    ;dash links
    @check_b_and_right:                   ;dash rechts 
    @check_a:                             ;sprigen 
    @end:
        dec frame
        rts 