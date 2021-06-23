;x = player x left 
;y = player y left/top
;tmp = object x left 
;tmp1 = object y left 
;tmp2 = x8 / x16 
sprite_collision: 
    txa 
    clc 
    adc tmp2 
    sec
    sbc tmp 
    asl 
    bcs @end
    stx tmp3  
    lda tmp 
    clc 
    adc tmp2 
    sec 
    sbc tmp3 
    asl 
    bcs @end 
    tya 
    clc 
    adc tmp2 
    sec 
    sbc tmp1 
    asl 
    bcs @end 
    sty tmp3 
    lda tmp1 
    clc 
    adc tmp2 
    sec 
    sbc tmp3 
    asl 
    bcs @end

    lda #$00
    sta tmp 
    rts 
    ;collision 
    @end:
    lda #$10
    sta tmp   
    rts 
    
;Object0Right > Object1Left
;Object0Left < Object1Right
;Object0Bottom > Object1Top
;Object0Top < Object1Bottom