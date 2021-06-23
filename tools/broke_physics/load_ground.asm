load_ground:           
    lda #$23  
    sta PPU_ADDR 
    lda #$80
    sta PPU_ADDR
    ldy #$00
    :
        lda ground,y 
        sta PPU_DATA
        iny
        cpy #$20
        bne :-    
        rts