collision: 
    txa 
    pha 
    tya 
    pha 
    txa
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    sta tmp
    tya 
    lsr
    lsr
    lsr
    asl
    asl
    clc  
    adc tmp
    tay

    txa 
    lsr
    lsr
    lsr
    and #%00000111
    tax  
    lda (collision_ptr),y
    and bitmask,x
    sta tmp1
    pla 
    tay 
    pla 
    tax 
    lda tmp1  
    rts