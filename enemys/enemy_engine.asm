;tmp = room enemy 
check_players:
    ldx p_x 
    ldy p_y 
    lda tmp   
    cmp current_room_p2
    bne :+ 
    lda status_bits_p2
    asl 
    bcc :+
    rts 
    : 
    lda tmp            
    cmp current_room_p1                       ;raum-gegner = raum-spieler1 ?
    beq @check_p1 
    jmp @room_p2 
    @check_p1:
    lda status_bits_p1
    asl 
    bcc :+
    rts 
    :
    cpy SPRITE_1_Y 
    bne @end1 
    lda p_attr 
    asl 
    asl 
    bcs @left
    :
    inx   
    jsr collision
    bne @end1  
    cpx SPRITE_1_X
    bne :-
    ;attack
    lda p_attr 
    and #%10111111
    sta p_attr  
    lda status_bits_p1
    ora #%10000000
    sta status_bits_p1
    @end1: 
    jmp @room_p2
    @left:
    : 
    dex 
    jsr collision
    bne @room_p2 
    cpx SPRITE_1_X
    bne :-
    ;attack 
    lda p_attr 
    ora #%01000000
    sta p_attr  
    lda status_bits_p1
    ora #%10000000
    sta status_bits_p1
    @room_p2:
    lda tmp   
    cmp current_room_p2
    bne @end 
    @check_p2:
    cpy SPRITE_2_Y 
    bne @end
    lda p_attr 
    asl 
    asl 
    bcs @left2
    :
    inx   
    jsr collision
    bne @end2  
    cpx SPRITE_2_X
    bne :-
    ;attack
    lda p_attr 
    and #%10111111
    sta p_attr  
    lda status_bits_p2
    ora #%10000000
    sta status_bits_p2
    @end2: 
    rts
    @left2:
    : 
    dex 
    jsr collision
    bne @end 
    cpx SPRITE_2_X
    bne :-
    ;attack 
    lda p_attr 
    ora #%01000000
    sta p_attr  
    lda status_bits_p2
    ora #%10000000
    sta status_bits_p2
    rts
    @end:
    rts 
check_hit: 
    ldx SPRITE_1_X 
    ldy SPRITE_1_Y 
    lda status_bits_p1
    and #%00111000
    bne @p2
    jsr check 
    lda tmp 
    bne @p2
    lda #$00 
    sta SPRITE_1_X
    sta SPRITE_1_Y
    sta current_room_p1
    sta acc_x_p1
    lda #$07 
    sta status_bits_p1
    lda #$50 
    sta input_lock1
    @p2:
    ldx SPRITE_2_X 
    ldy SPRITE_2_Y 
    lda status_bits_p2
    and #%00111000  
    bne @end 
    jsr check
    lda tmp 
    bne @end
    lda #$00
    sta SPRITE_2_X
    sta SPRITE_2_Y
    sta current_room_p2
    sta acc_x_p2
    lda #$07 
    sta status_bits_p2
    lda #$50 
    sta input_lock2 
    @end:
    rts 
    check:
    txa  
    ldx p_x 
    inx  
    inx 
    stx tmp 
    ldx p_y
    inx 
    inx  
    stx tmp1
    tax 
    lda #$08 
    sta tmp2
    jsr sprite_collision
    rts  
attack:
lda status_bits_p1
asl 
bcs @p1 
lda status_bits_p2
asl 
bcs @p2 
rts 
@p1:
lda p_x 
sec 
sbc SPRITE_1_X
asl 
bcs @left
jmp @right  
@p2:
lda p_x 
sec 
sbc SPRITE_2_X
asl 
bcs @left
jmp @right  
@right:
lda #%01000000
ora p_attr
sta p_attr
rts 
@left:
lda #%10111111
and p_attr 
sta p_attr
rts 
move_enemy: 
    ldx p_x 
    ldy p_y 
    lda p_attr 
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
    jmp @end 
    @left:
    dex 
    jsr collision 
    beq @end 
    inx 
    lda p_attr
    and #%10111111
    sta p_attr 
    @end: 
    stx p_x 
    sty p_y 
    rts 
