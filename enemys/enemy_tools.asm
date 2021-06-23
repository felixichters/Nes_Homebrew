move_enemy:
    sta p_attr 
    asl 
    asl
    bcs @left 
    inx 
    jsr collision
    beq :+
    dex 
    lda p_attr
    ora #%01000000
    sta p_attr 
    :
    rts 
    @left:
    dex 
    jsr collision 
    beq :+
    inx 
    lda p_attr
    and #%10111111
    sta p_attr 
    :
    rts 

check_enemy_p1:
    lda p_attr
    asl 
    asl 
    bcs @left 
    ldx p_x 
    ldy p_y 
    inx 
    :
    jsr collision
    bne @end 
    inx 
    cpy SPRITE_1_Y 
    bne :-
    cpx SPRITE_1_X
    bne :-
    jmp @attack 
    @left: 
    ldx p_x 
    ldy p_y 
    :
    jsr collision
    bne @end 
    dex 
    cpy SPRITE_1_Y 
    bne :-
    cpx SPRITE_1_X
    bne :-
    @attack:
        lda status_bits_p1
        ora #%10000000
        sta status_bits_p1
        rts 
    @end:
        lda status_bits_p1
        and #%01111111
        sta status_bits_p1
        rts 

check_enemy_p2:
 lda p_attr
    asl 
    asl 
    bcs @left 
    ldx p_x 
    ldy p_y 
    inx 
    :
    jsr collision
    bne @end 
    inx 
    cpy SPRITE_1_Y 
    bne :-
    cpx SPRITE_1_X
    bne :-
    jmp @attack 
    @left: 
    ldx p_x 
    ldy p_y 
    :
    jsr collision
    bne @end 
    dex 
    cpy SPRITE_1_Y 
    bne :-
    cpx SPRITE_1_X
    bne :-
    @attack:
        lda status_bits_p1
        ora #%10000000
        sta status_bits_p1
        rts 
    @end:
        lda status_bits_p1
        and #%01111111
        sta status_bits_p1
rts