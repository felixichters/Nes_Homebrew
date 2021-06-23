;VERSION 1 
eyethrower:
    lda current_room_et
    sta tmp 
    lda ET_ATTR
    sta p_attr 
    lda ET_X
    sta p_x 
    lda ET_Y
    sta p_y 
    lda current_room_p1
    cmp current_room_et
    bne :+ 
    lda status_bits_p1
    asl 
    bcs @check
    :
    lda current_room_p2
    cmp current_room_et
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
    sta ET_ATTR
    sta ET_FX_ATTR
    lda p_x 
    sta ET_X
    lda ET_Y
    lda #ET_FX_DTILE
    sta ET_FX_TILE
    :
    ldy #$00
    :
    lda animation_count_et,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda #ET_DTILE
    sta animation_tile
    lda #ET_ANIM_SPEED
    sta animation_speed
    lda ET_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta ET_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_et,y 
    iny 
    cpy #$03
    bne :- 
    @check:
    ;*********************************************
    jsr check_players 
    jsr check_hit
    lda current_room_et
    cmp current_room_p1
    bne :+ 
    lda status_bits_p1
    asl 
    bcs @attack
    : 
    lda current_room_et
    cmp current_room_p2
    bne @end_check
    lda status_bits_p2 
    asl 
    bcs @attack
    @end_check:
    jmp @end 
   ;******************************************************************************************************************************
    @attack:
    jsr throw
    jsr attack
    lda p_attr
    sta ET_ATTR 
    @end:
    lda ET_FX_X 
    sta p_x 
    lda ET_FX_Y 
    sta p_y 
    lda et_acc_y 
    sta acc_y
    lda et_acc_x 
    sta acc_x  
    lda #ET_ACC_Y
    sta full_acc_y
    lda #ET_ACC_X 
    sta full_acc_x
    lda #ET_SPEED_X
    sta speed_y
    lda #ET_SPEED_Y
    sta speed_x
    jsr physics_engine
    lda acc_x  
    sta et_acc_x 
    lda acc_y 
    sta et_acc_y  
    lda p_y 
    sta ET_FX_Y
    lda p_x 
    sta ET_FX_X 
    jsr check_hit
    jsr check_fx_collision_et
    lda et_acc_x
    beq @next_object
    ldy #$00
    :
    lda animation_count_et_fx,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda #ET_FX_DTILE
    sta animation_tile
    lda #ET_ANIM_SPEED
    sta animation_speed
    lda ET_FX_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta ET_FX_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_et_fx,y 
    iny 
    cpy #$03
    bne :- 
    @next_object:
    jmp next_object
    throw:
    lda ET_FX_X 
    cmp ET_X
    bne @end 
    lda ET_FX_Y 
    cmp ET_Y 
    bne @end 
    lda ET_ATTR
    asl 
    asl 
    bcs @left
    lda #ET_ACC_Y 
    sta et_acc_y
    lda #ET_ACC_Y
    sta et_acc_x 
    rts 
    @left:
    lda #ET_ACC_Y
    sta et_acc_y
    lda #ET_LACC_X 
    sta et_acc_x 
    @end: 
    rts   
    check_fx_collision_et:
    lda et_acc_y 
    cmp #$FE 
    bne :+
    ldx ET_FX_X
    ldy ET_FX_Y
    iny
    jsr collision
    beq :+
    lda ET_X 
    sta ET_FX_X
    sta p_x 
    lda ET_Y 
    sta ET_FX_Y 
    :
    rts 