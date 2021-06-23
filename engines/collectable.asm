collectable: 
jmp @start
     @collectable_p1:
        ldx SPRITE_1_X
        ldy SPRITE_1_Y
        jsr win_check
        bne :+
        jmp RESET ;player 1 won 
        :
        lda status_bits_p2
        and #%00111000
        beq @end1
        ldx SPRITE_1_X 
        ldy SPRITE_1_Y 
        lda SPRITE_2_X 
        sta tmp 
        lda SPRITE_2_Y 
        sta tmp1 
        lda #$08 
        sta tmp2 
        jsr sprite_collision
        bne @end1 
        lda status_bits_p2              ;setze status bits für collectable eingesammelt 
        ora #%01000000
        sta status_bits_p2
        lda #%10111111
        and status_bits_p1
        sta status_bits_p1
        @end1:
        jmp @end 
    @collectable_p2:
        ldx SPRITE_2_X
        ldy SPRITE_2_Y
        jsr win_check
        bne :+
        jmp RESET ;player 2 won 
        :
        lda status_bits_p1
        and #%00111000
        beq @end 
        ldx SPRITE_2_X 
        ldy SPRITE_2_Y 
        lda SPRITE_1_X 
        sta tmp 
        lda SPRITE_1_Y 
        sta tmp1 
        lda #$08 
        sta tmp2 
        jsr sprite_collision
        bne @end 
        lda status_bits_p1              ;setze status bits für collectable eingesammelt 
        ora #%01000000
        sta status_bits_p1
        lda #%10111111
        and status_bits_p2
        sta status_bits_p2
        jmp @end 
    @start:
    lda status_bits_p1              ;check ob collectable eingesammelt 
    asl 
    asl 
    bcs @collectable_p1
    lda status_bits_p2 
    asl 
    asl 
    bcs @collectable_p2

    lda current_room_p1             ;check ob spieler sich im selben raum wie collectable befindet 
    cmp collectable_room
    bne @check_p2 
    ldx SPRITE_1_X
    ldy SPRITE_1_Y
    jsr collectable_collision
    bne @check_p2

    lda status_bits_p1              ;setze status bits für collectable eingesammelt 
    ora #%01000000
    sta status_bits_p1

    @check_p2:                      ;gleiche mit spieler 2 
    lda current_room_p2             ;check ob spieler sich im selben raum wie collectable befindet 
    cmp collectable_room
    bne @end 
    ldx SPRITE_2_X
    ldy SPRITE_2_Y
    jsr collectable_collision
    bne @end

    lda status_bits_p2              ;setze status bits für collectable eingesammelt 
    ora #%01000000
    sta status_bits_p2
    @end: 
    ldy #$00
    :
    lda animation_count_c,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda collectable_tile
    sta animation_tile
    lda #COLLECTABLE_ANI_SPEED
    sta animation_speed
    lda SPRITE_3_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta SPRITE_3_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_c,y 
    iny 
    cpy #$03
    bne :- 
    rts 

win_check:
        stx p_x 
        sty p_y 
        dex 
        dex 
        dex 
        dex 
        stx SPRITE_3_X
        ldx p_y 
        dex 
        dex 
        dex 
        dex 
        stx SPRITE_3_Y
        lda p_x 
        lsr 
        lsr 
        lsr 
        cmp #$00
        bne :+
        lda p_y 
        lsr 
        lsr 
        lsr 
        cmp #$1A
        :
        rts 
collectable_collision:
    ;collision check (hitbox) x/y 
    lda SPRITE_3_X 
    sta tmp 
    lda SPRITE_3_Y 
    sta tmp1 
    lda #$08 
    sta tmp2 
    jsr sprite_collision
    lda tmp  
    @end:
    rts 