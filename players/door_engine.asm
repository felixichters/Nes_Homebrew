door_engine:
    lda #$00
    sta tmp4 
    lda current_room
    asl 
    tay 
    :
    lda (doors_ptr_x),y 
    asl 
    asl 
    asl 
    sta tmp 
    lda (doors_ptr_y),y
    tax 
    inx 
    txa 
    asl 
    asl  
    asl 
    sta tmp1 
    lda #$08
    sta tmp2 
    ldx p_x 
    ldy p_y 
    jsr sprite_collision
    lda tmp 
    beq @collide
    lda current_room
    asl 
    tay 
    iny 
    inc tmp4
    lda tmp4 
    cmp #$02 
    bne :- 
    lda #$00 
    sta tmp4 
    rts 
    @collide:
    lda #$00 
    sta acc_x 
    sta acc_y 
    lda current_room                          ;aktuller raum in y speichern
    asl                                       ;shift links um aktuelle tür runter in dem aktuellem raum zu bekommen 
    tay                                       ;lade y mit tür die getestet werden soll
    lda tmp4 
    lsr 
    bcc @door_down 
    ;door up 
    inc current_room
    iny 
    iny                                       ;incremntiere aktuele tür damit die nächste tür die obere ist 
    lda (doors_ptr_y),y                       ;lade a mit der oberen tür 
    asl 
    asl 
    asl 
    clc 
    adc #$07
    sta p_y 
    lda (doors_ptr_x),y 
    asl 
    asl 
    asl 
    sta p_x 
    rts 
    @door_down:
    inc debug
    dec current_room
    dey                                       ;wenn gleich dann dec tür 
    lda (doors_ptr_y),y                       ;lade die tür y coord der tür unter der aktuellen tür (return wert)
    asl 
    asl 
    asl 
    clc 
    adc #$07
    sta p_y 
    lda (doors_ptr_x),y 
    asl 
    asl 
    asl 
    sta p_x 
    rts  