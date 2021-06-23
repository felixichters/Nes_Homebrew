;VERSION 1 
stomper:
    lda current_room_stomp
    sta tmp 
    lda STOMP_ATTR
    sta p_attr 
    lda STOMP_X
    sta p_x 
    lda STOMP_Y
    sta p_y 
    lda current_room_p1
    cmp current_room_stomp
    bne :+ 
    lda status_bits_p1
    asl 
    bcs @check
    :
    lda current_room_p2
    cmp current_room_stomp
    bne :+
    lda status_bits_p2 
    asl 
    bcs @check
    :
;******************************************************
    ldy #$00
    :
    lda animation_count_stomp,y
    sta animation_count,y 
    iny 
    cpy #$03
    bne :- 
    lda #$28 
    sta animation_tile
    lda #$04
    sta animation_speed
    lda STOMP_TILE
    sta p_tile 
    jsr animation
    lda p_tile 
    sta STOMP_TILE
    ldy #$00
    :
    lda animation_count,y
    sta animation_count_stomp,y 
    iny 
    cpy #$03
    bne :- 
    @check:
    ;*********************************************
    lda current_room_stomp 
    cmp current_room_p1
    beq :+
    lda current_room_stomp 
    cmp current_room_p2
    bne @end_check
    :
    jsr check_players 
    jsr check_hit
    lda status_bits_p1
    asl 
    bcs @attack
    lda status_bits_p2 
    asl 
    bcs @attack
    @end_check:
    jmp @end 
   ;******************************************************************************************************************************
    @attack:
    
    @end:
  
    jmp next_object
