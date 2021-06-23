every_frame_engine:
    lda input_lock1
    beq :+
    dec input_lock1
    :
    lda input_lock2
    beq :+
    dec input_lock2
    :
    ldy #$00
    sty tmp9 
    lda (every_frame_ptr),y
    asl  
    sta tmp8                         ;anzahl gegner 
    process_every_frame:
    ldy tmp9 
    iny 
    lda (every_frame_ptr),y 
    sta every_frame_jmp_ptr
    iny 
    sty tmp9 
    lda (every_frame_ptr),y 
    sta every_frame_jmp_ptr+1
    jmp (every_frame_jmp_ptr)
    next_object:
    ldy tmp9 
    cpy tmp8
    bne process_every_frame
        lda status_bits_p1
    asl 
    asl 
    bcc :+
    lda current_room_p1
    sta collectable_room
    :
    lda status_bits_p2
    asl 
    asl 
    bcc :+
    lda current_room_p2
    sta collectable_room
    :

    rts 
    