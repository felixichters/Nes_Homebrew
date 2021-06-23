;Ram andresse des Gegners = 0209(gegner sprites anfang) an der stelle Gegner nummer * 4 
enemy_engine:
    ldy current_room_p1                     ;lade aktuellen raum in dem sich der erste spieler befindet 
    lda (enemy_room_ptr),y                  ;lade a mit der anzahl der Gegner in dem aktuellem raum  
    sta tmp                                 ;speichere diese anzahl temporär 
    iny 
    lda (enemy_room_ptr),y 
    sta tmp1
    ldy tmp 
select_enemy:  
    lda (enemy_hi_ptr),y                    ;lade a mit der high adresse der gegner engine des gegners an der zugeteilten adresse 
    sta enemy_ptr                           ;speichere adresse  
    lda (enemy_lo_ptr),y                    ;...
    sta enemy_ptr+1                         ;...
    lda #$02 
    sta addr_ptr
    lda #$09
    sta addr_ptr+1
    lda tmp
    asl 
    asl 
    ;;;;;;;;;
    tay 
    lda (addr_ptr),y 
    sta tmp2 
    cmp p1_y 
    bne @p2 
    iny 
    iny 
    iny 
    lda (addr_ptr),y 
    sta tmp3 
    tax 
    @check_x:
        cpx p1_x 
        beq @attack 
        lda eye_direction
        cmp #$00
        bne :+
        dex 
        dex 
        :
        inx 
        ldy tmp2 
        jsr collision
        bne :-
        @p2:
        lda tmp2 
        cmp p2_y
        bne @end
        ldy tmp3 
        cmp p2_x
        beq @attack
        @end: 
        jmp next_enemy
    ;;;;;;;;;
    @attack: 
    jmp (enemy_ptr)                         ;gegner handlung
next_enemy:
    inc tmp 
    ldy tmp  
    cpy tmp1 
    bne select_enemy
    ldx #$00
    stx count 
;move enemys
    ldx count
    ldy $0209,x
    inc count 
    inc count 
    inc count
    lda eye_direction
    cmp #$01 
    beq @left 
    ldy count 
    inc $0209,y
    ldx $0209,y 
    jsr collision 
    bne @aniamte
    rts 
    
    @right:
    ldy count 
    dec $0209,y 
    ldx $0209,y 
    jsr collision 
    bne @animate
    rts 

    lda eye_direction
    cmp #$00
    beq @left 

    lda #$01
    sta $0209,x 
    @left 
    lda #%01000001
    sta $0209,x 
    @animate 
    rts 