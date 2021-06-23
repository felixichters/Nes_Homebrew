read_controller:
    lda #$01                    ;lade a mit 00000001
    sta P1_POLL                 ;speichere a in p1 pol -> Controller data auslesen
    sta buttons2                ;speichere 00000001 in buttons für folgende bcc abfrage 
    lsr a                       ;a = 0
    sta P1_POLL                 ;Controler pollen
@loop:
    lda P1_POLL                 ;lade a mit aktuellem button
    and #%00000011              ;und 4 
    cmp #$01                    ;carry wird gesetzt wenn nicht 0
    rol buttons1                ;Carry -> buttons1 -> Carry
    lda P2_INPUT                ;gleich mit P2
    and #%00000011              ;"
    cmp #$01                    ;"
    rol buttons2                ;"
    bcc @loop                   ;wenn das letzte bit raus ist und eins ist dann Controller fertig 
    rts 
