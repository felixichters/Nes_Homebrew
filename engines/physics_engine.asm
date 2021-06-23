physics_engine: 
    lda acc_x                           ;wenn beschleunigung = 0 dann keine x bewegung 
    beq @process_y
;move x***************************************************
    twos_comp acc_x 
    lda tmp                             ;lade zweier komplement 
    @process_x:
        sec                         
        sbc full_acc_x
        asl 
        bcs @accelerate_x               ;if acc < höchste beschleunigung, dann prüfen ob beschleunigt werden darf 
        jsr move_x 
        jmp @end_x
        @accelerate_x:
            lda acc_count_x             ;prüfe ob beschleunigt werden darf (alle x frames inkrementiert werden darf)
            cmp acc_hold_x 
            bne @no_acc 
            jsr move_x
            lda acc_hold_x 
            clc 
            adc acc_speed_x
            sta acc_hold_x
            @no_acc:
            inc acc_count_x 
    @end_x:
        jsr resistance                  
;********************************************************
    @process_y: 
        lda acc_y 
        beq @end                        ;wenn bescleunigung = 0 dann stehend 
        twos_comp acc_y 
        lda tmp 
        sec 
        sbc full_acc_y
        asl 
        bcc @move_y                     ;if beschleungigung = über beschleunigungsgrenze dann umgebremste bewegung 
        ;accelerate_y 
        lda acc_y 
        asl 
        bcs :+                          ;if minus beschleunigung -> springe zu minus bewegung 
        lda p_y 
        clc 
        adc speed_y
        sta p_y                         ;pixel koordinate + speed 
        :
        lda speed_y
        lsr 
        sta tmp 
        lda p_y 
        sec 
        sbc tmp 
        sta p_y
        @move_y:   
        jsr move_y
        
    @end:
        jsr gravitation
        rts
;*****************************************
resistance:
    lda acc_x 
    asl                                 ;msb in carry shiften (- oder +)
    bcs @left                           ;wenn carry gestzt ist dann richtung = links 
    dec acc_x                           ;verringeere die beschleunigung   
    dec acc_x  
    @left:
        inc acc_x                       ;verringere die beschleinigung 
    @end:
        rts                             ;ende 
gravitation:
    lda acc_y 
    clc 
    adc full_acc_y
    asl 
    bcs @end 
    dec acc_y 
    dec acc_y 
    @end:
        rts 
move_x:
    lda acc_x 
    asl 
    bcs @left 
    @right:
    lda p_x 
    clc 
    adc speed_x  
    tax
    ldy p_y  
    jsr collision
    bne :+
    stx p_x 
    jmp @end
    :
    dex 
    jsr collision
    bne :-
    stx p_x 
    lda #$00
    sta acc_x 
    jmp @end
    @left:
    lda p_x 
    sec
    sbc speed_x  
    tax
    ldy p_y  
    jsr collision
    bne :+
    stx p_x 
    jmp @end
    :
    inx  
    jsr collision
    bne :-
    stx p_x 
    lda #$00
    sta acc_x 
    @end:  
    rts
move_y:
    lda acc_y 
    asl 
    bcs @down_y 

    lda p_y 
    sec 
    sbc speed_y 
    tay 
    ldx p_x 
    jsr collision
    bne :+ 
    sty p_y 
    jmp @end 
    :
    iny 
    jsr collision
    bne :-
    sty p_y 
    lda #$00
    sta acc_y 
    jmp @end 
    @down_y:
    lda p_y 
    clc 
    adc speed_y
    tay
    ldx p_x 
    jsr collision
    bne :+
    sty p_y 
    jmp @end 
    :
    dey 
    jsr collision
    bne :-
    sty p_y 
    lda #$00
    sta acc_y  
    @end:
        rts 