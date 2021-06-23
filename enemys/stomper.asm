;VERSION 1 
stomper:
    lda current_room_e4
    sta tmp 
    lda SPRITE_13_ATTR
    sta p_attr 
    lda SPRITE_13_X
    sta p_x 
    lda SPRITE_13_Y
    sta p_y 
    lda current_room_p1
    cmp current_room_e4
    bne :+ 
    lda status_bits_p1
    asl 
    bcs @check
    :
    lda current_room_p2
    cmp current_room_e4
    bne :+
    lda status_bits_p2 
    asl 
    bcs @check
    :
;******************************************************
    ldy #$00
    :
    lda animation_count_e4,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda #STOMP_DTILE 
    sta animation_tile
    lda #STOMP_ANIM_SPEED
    sta animation_speed
    lda SPRITE_13_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta SPRITE_13_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_e4,y 
    iny 
    cpy #$03
    bne :- 
    @check:
    ;*********************************************
    jsr check_players 
    jsr check_hit
    lda current_room_e4
    cmp current_room_p1
    bne :+ 
    lda status_bits_p1
    asl 
    bcs @attack
    : 
    lda current_room_e4
    cmp current_room_p2
    bne @end_check
    lda status_bits_p2 
    asl 
    bcs @attack
    @end_check:
    jmp @end 
   ;******************************************************************************************************************************
    @attack:
    jsr jump
    jsr attack
    lda p_attr
    sta SPRITE_13_ATTR
    @end:
    lda #$00 
    sta acc_x 
    lda acc_y_e4 
    sta acc_y 
    lda #STOMP_ACC_Y
    sta full_acc_y
    lda #STOMP_SPEED_Y 
    sta speed_y
    jsr physics_engine
    lda acc_y 
    sta acc_y_e4
    lda p_y 
    sta SPRITE_13_Y
    jsr move_fx
    jsr check_fx_collision
    jmp next_object
    
    jump:
    lda SPRITE_14_Y
    cmp #$FF 
    bne @end 
    lda SPRITE_15_Y
    cmp #$FF 
    bne @end 
    ldx SPRITE_13_X
    ldy SPRITE_13_Y
    iny 
    jsr collision
    beq @end 
    lda SPRITE_13_X 
    sta SPRITE_14_X
    sta SPRITE_15_X
    lda #STOMP_ACC_Y
    sta acc_y_e4
    lda #$00 
    sta status_e4
    @end: 
    rts     
    check_fx_collision:
    ldx SPRITE_14_X
    ldy SPRITE_14_Y
    jsr collision
    beq :+
    lda #$FF 
    sta SPRITE_14_Y
    lda SPRITE_13_X 
    sta SPRITE_14_X
    lda #$01 
    ora status_e4
    sta status_e4
    :
    ldx SPRITE_15_X
    ldy SPRITE_15_Y
    jsr collision
    beq :+
    lda #$FF 
    sta SPRITE_15_Y
    lda SPRITE_13_X
    sta SPRITE_15_X 
    lda #$02 
    ora status_e4
    sta status_e4
    :
    rts 
    move_fx:
    ldx SPRITE_13_X
    ldy SPRITE_13_Y
    iny 
    jsr collision
    beq @end 
    lda status_e4
    lsr 
    bcs :+
    lda SPRITE_13_Y 
    sta SPRITE_14_Y 
    inc SPRITE_14_X
    :
    lda status_e4
    lsr 
    lsr 
    bcs :+
    lda SPRITE_13_Y 
    sta SPRITE_15_Y 
    dec SPRITE_15_X
    :
    ldy #$00
    :
    lda animation_count_e4fx,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda #STOMP_FX_DTILE 
    sta animation_tile
    lda #$03
    sta animation_speed
    lda SPRITE_14_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta SPRITE_14_TILE
    sta SPRITE_15_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_e4fx,y 
    iny 
    cpy #$03
    bne :- 
    lda SPRITE_13_ATTR
    and #%00000011
    sta SPRITE_15_ATTR
    lda SPRITE_13_ATTR
    ora #%01000000
    sta SPRITE_14_ATTR
    lda SPRITE_14_X
    sta p_x 
    lda SPRITE_14_Y
    sta p_y 
    jsr check_hit
    lda SPRITE_15_Y
    sta p_y 
    lda SPRITE_15_X
    sta p_x 
    jsr check_hit
    @end: 
    rts 