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
    sta enemy_addr 
    jmp (enemy_ptr)                         ;gegner handlung
next_enemy:
    inc tmp 
    ldy tmp  
    cpy tmp1 
    bne select_enemy  
    rts 