;VERSION 1 
sprinter:
    lda current_room_spr
    sta tmp 
    lda SPR_ATTR
    sta p_attr 
    lda SPR_X
    sta p_x 
    lda SPR_Y
    sta p_y 
    lda current_room_p1
    cmp current_room_spr
    bne :+ 
    lda status_bits_p1
    asl 
    bcs @check
    :
    lda current_room_p2
    cmp current_room_spr
    bne :+
    lda status_bits_p2 
    asl 
    bcs @check
    :
;******************************************************
    lda frame_counter
    lsr 
    bcs :+
    jsr move_enemy
    lda p_attr
    sta SPR_ATTR
    lda p_x 
    sta SPR_X
    jsr check_hit
    :
    ldy #$00
    :
    lda animation_count_spr,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda #SPR_DTILE
    sta animation_tile
    lda #SPR_ANIM_SPEED
    sta animation_speed
    lda SPR_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta SPR_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_spr,y 
    iny 
    cpy #$03
    bne :- 
    @check:
    ;*********************************************
    jsr check_players 
    jsr check_hit
    lda current_room_spr
    cmp current_room_p1
    bne :+ 
    lda status_bits_p1
    asl 
    bcs @attack
    : 
    lda current_room_spr
    cmp current_room_p2
    bne @end_check
    lda status_bits_p2 
    asl 
    bcs @attack
    @end_check:
    jmp next_object
   ;******************************************************************************************************************************
    @attack:
    jsr attack
    lda p_attr
    sta SPR_ATTR
    asl 
    asl 
    bcs @left 
    inc SPR_X 
    inc SPR_X 
    inc SPR_X 
    inc SPR_X 
    @left: 
    dec SPR_X 
    dec SPR_X 
    @end:
    ldy #$00
    :
    lda animation_count_spr,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda #SPR_FX_DTILE
    sta animation_tile
    lda #SPR_FX_ANIM_SPEED
    sta animation_speed
    lda SPR_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta SPR_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_spr,y 
    iny 
    cpy #$03
    bne :- 
    jsr check_hit
    jmp next_object