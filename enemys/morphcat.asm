;VERSION 1 
morphcat:
    lda current_room_e2
    sta tmp 
    lda SPRITE_7_ATTR
    sta p_attr 
    lda SPRITE_7_X
    sta p_x 
    lda SPRITE_7_Y
    sta p_y 
    lda current_room_p1
    cmp current_room_e2
    bne :+ 
    lda status_bits_p1
    asl 
    bcs @check
    :
    lda current_room_p2
    cmp current_room_e2
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
    :
    ldy #$00
    :
    lda animation_count_e2,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda #MC_DTILE
    sta animation_tile
    lda #MC_ANIM_SPEED
    sta animation_speed
    lda SPRITE_7_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta SPRITE_7_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_e2,y 
    iny 
    cpy #$03
    bne :- 
    @check:
    ;*********************************************
    jsr check_players 
    jsr check_hit
    lda current_room_e2
    cmp current_room_p1
    bne :+ 
    lda status_bits_p1
    asl 
    bcs @attack
    : 
    lda current_room_e2
    cmp current_room_p2
    bne @end_check
    lda status_bits_p2 
    asl 
    bcs @attack
    @end_check:
    jmp @end 
   ;******************************************************************************************************************************
    @attack:
    ldx p_x 
    ldy p_y 
    iny 
    jsr collision
    beq :+
    jsr jumpto
    :
    jsr attack
    @end:
    lda acc_y_e2 
    sta acc_y
    lda acc_x_e2 
    sta acc_x  
    lda #MC_ACC_Y
    sta full_acc_y
    lda #MC_ACC_X 
    sta full_acc_x
    lda #MC_SPEED_Y
    sta speed_y
    lda #MC_SPEED_X
    sta speed_x
    lda acc_y 
    ldy p_y 
    ldx p_x 
    lda status_bits_p1
    asl 
    bcs @ph
        lda status_bits_p2
    asl 
    bcs @ph
    iny 
    jsr collision
    bne @noph
    @ph:
    jsr physics_engine 
    @noph:
    lda acc_x  
    sta acc_x_e2 
    lda acc_y 
    sta acc_y_e2  
    lda p_y 
    sta SPRITE_7_Y
    lda p_x 
    sta SPRITE_7_X 
    lda p_attr
    sta SPRITE_7_ATTR 
    jmp next_object
    
    jumpto:
    lda SPRITE_7_ATTR 
    asl 
    asl 
    bcs @left
    lda #MC_ACC_Y 
    sta acc_y_e2
    lda #MC_ACC_X
    sta acc_x_e2 
    rts 
    @left:
    lda #MC_ACC_Y
    sta acc_y_e2
    lda #MC_LACC_X 
    sta acc_x_e2 
    @end: 
    rts   