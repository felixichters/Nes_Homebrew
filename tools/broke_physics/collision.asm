collision:
    txa
    pha
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    sta tmp5
    tya 
    lsr
    lsr
    lsr
    asl
    asl
    clc  
    adc tmp5
    tay

    txa 
    lsr
    lsr
    lsr
    and #%00000111
    tax  
    lda (collision_ptr),y
    and bitmask,x
    pla 
    tax 
    rts