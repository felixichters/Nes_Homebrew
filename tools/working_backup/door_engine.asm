door_engine:
    txa 
    lsr                                        ;shifte 3*rechts sprite coord = 16pixel
    lsr                                        ;... 
    lsr                                        ;...
    tax                                        ;lade x mit überarbeiteter x coord 

    ldy current_room_p1                       ;aktuller raum in y speichern
    tya                                       ;speichere aktuellen raum in tmp
    asl                                       ;shift links um aktuelle tür runter in dem aktuellem raum zu bekommen 
    tay                                       ;lade y mit tür die getestet werden soll

    lda (doors_ptr_x),y                       ;lade a mit der x coord von der tür im y index (aktuelle tür) 
                                          
    sta tmp5 
    cpx tmp5                                  ;vgl tür 1 coord im aktuellem raum mit spieler x coord 
    bne :+                                    ;wenn nicht gleich dann dann check nächte tür
    dey                                       ;wenn gleich dann dec tür 
    lda (doors_ptr_y),y                       ;lade die tür y coord der tür unter der aktuellen tür (return wert)
    asl 
    asl 
    asl 
    clc 
    adc #$07 
    dec current_room_p1                       ;dec aktuellen raum
    jmp @end                                  ;return
    :
    iny                                       ;incrementiere y(aktuelle tür +1 = zweite tür im raum) 
    lda (doors_ptr_x),y                       ;lade a mit der x coord der tür y  

    sta tmp5 
    cpx tmp5                                  ;vgl x spieler mit x tür 
    bne :+                                    ;wenn nicht dann keine tür collision
 
    iny                                       ;incremntiere aktuele tür damit die nächste tür die obere ist 
    lda (doors_ptr_y),y                       ;lade a mit der oberen tür 
    asl 
    asl 
    asl  
    clc 
    adc #$07 
    inc current_room_p1                       ;aktueller raum +1 
    jmp @end                                  ;return 
    :
    lda current_y                             ;keine tür also übergebe den aktuellen y wert 
@end:
    rts                                       ;return  