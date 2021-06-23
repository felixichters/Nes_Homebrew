Vacuum:
    lda current_room_e3
    sta tmp 
    lda SPRITE_10_ATTR
    sta p_attr 
    lda SPRITE_10_X
    sta p_x 
    lda SPRITE_10_Y
    sta p_y
    lda current_room_p1
    cmp current_room_e3
    bne :+ 
    lda status_bits_p1
    asl 
    bcs @check
    :
    lda current_room_p2
    cmp current_room_e3
    bne :+
    lda status_bits_p2 
    asl 
    bcs @check
    :
    lda frame_counter
    lsr 
    bcc :+
    jsr move_enemy
    lda p_attr
    sta SPRITE_10_ATTR
    :
;******************************************************
    ldy #$00
    :
    lda animation_count_e3,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda #VAC_DTILE 
    sta animation_tile
    lda #VAC_ANIM_SPEED
    sta animation_speed
    lda SPRITE_10_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta SPRITE_10_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_e3,y 
    iny 
    cpy #$03
    bne :- 
    @check:
    ;*********************************************
    lda current_room_e3
    sta tmp 
    jsr check_players 
    lda current_room_p1
    jsr check_hit
    lda p_x 
    sta SPRITE_10_X
    lda p_y 
    sta SPRITE_10_Y
    lda p_attr
    sta SPRITE_10_ATTR

    lda current_room_p1
    cmp current_room_e3
    bne :+
    lda status_bits_p1
    asl 
    bcs @attack1
    :
    lda current_room_p2
    cmp current_room_e3
    bne @end_check
    lda status_bits_p2
    asl 
    bcs @attack2
    @end_check:
    lda p_x 
    sta SPRITE_10_X
    lda p_y 
    sta SPRITE_10_Y
    lda p_attr
    sta SPRITE_10_ATTR
    lda #$FF 
    sta SPRITE_11_X
    sta SPRITE_11_Y
    jmp next_object
   ;******************************************************************************************************************************
    @attack1:
    lda SPRITE_1_X
    sec 
    sbc SPRITE_10_X
    asl
    bcs @left
    dec SPRITE_1_X
    dec SPRITE_1_X
    dec SPRITE_1_X
    dec SPRITE_1_X
    @left:
    inc SPRITE_1_X
    inc SPRITE_1_X

    lda current_room_p2
    cmp current_room_e3
    bne @end
    lda status_bits_p2
    asl 
    bcc @end
    @attack2:
    lda SPRITE_2_X
    sec 
    sbc SPRITE_10_X
    asl
    bcs @left1
    dec SPRITE_2_X
    dec SPRITE_2_X
    dec SPRITE_2_X
    dec SPRITE_2_X
    @left1:
    inc SPRITE_2_X
    inc SPRITE_2_X
    @end:
    jsr attack
    lda p_attr
    sta SPRITE_10_ATTR
    ldx SPRITE_10_X 
    lda SPRITE_10_ATTR
    asl 
    asl 
    bcs :+
    txa 
    clc 
    adc #$10
    tax 
    :
    txa 
    sec 
    sbc #$08  
    sta SPRITE_11_X
    lda SPRITE_10_Y
    sta SPRITE_11_Y
    lda SPRITE_10_ATTR
    sta SPRITE_11_ATTR
    ldy #$00
    :
    lda animation_count_e3fx,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda #VAC_FX_DTILE
    sta animation_tile
    lda #VAC_ANIM_SPEED
    sta animation_speed
    lda SPRITE_11_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta SPRITE_11_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_e3fx,y 
    iny 
    cpy #$03
    bne :- 
    jmp next_object