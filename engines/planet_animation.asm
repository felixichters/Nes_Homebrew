planet_animation:
    lda #$01 
    sta SPRITE_1_ATTR
    sta SPRITE_2_ATTR
    sta SPRITE_3_ATTR
    sta SPRITE_4_ATTR
    ldy #$00
    ldx #$00
    :
    jsr planet
    iny 
    txa 
    clc 
    adc #$10
    tax
    cpy #$05
    bne :-
    rts 
    planet:
        lda planet_x,y
        sta SPRITE_5_X,x
        sta SPRITE_7_X,x
        clc 
        adc #$08
        sta SPRITE_6_X,x
        sta SPRITE_8_X,x
        lda planet_y,y
        sta SPRITE_5_Y,x
        sta SPRITE_6_Y,x
        clc 
        adc #$08
        sta SPRITE_7_Y,x
        sta SPRITE_8_Y,x        
        pha
        txa 
        pha
        tya 
        pha
        lda planet_x,y 
        sta tmp 
        lda planet_y,y  
        sta tmp1
        ldx SPRITE_1_X 
        ldy SPRITE_1_Y  
        lda #$10
        sta tmp2
        jsr sprite_collision
        pla
        tay 
        pla
        tax 
        pla 
        lda tmp 
        bne @end 
        @animate:
            lda #$02 
            sta SPRITE_1_ATTR
             sta SPRITE_2_ATTR
              sta SPRITE_3_ATTR
               sta SPRITE_4_ATTR
            inc SPRITE_5_X,x
            inc SPRITE_5_Y,x
            dec SPRITE_6_X,x 
            inc SPRITE_6_Y,x
            inc SPRITE_7_X,x
            dec SPRITE_7_Y,x
            dec SPRITE_8_Y,x
            dec SPRITE_8_X,x
            lda #BUTTON_B
            ora #BUTTON_A
            ora #BUTTON_START
            and buttons1 
            beq @end 
            lda levels_hi,y 
            sta addr_ptr
            lda levels_lo,y 
            sta addr_ptr+1 
            jsr level_1
            jsr addr_ptr 
            @end:
                rts