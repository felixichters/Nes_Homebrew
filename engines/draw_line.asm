draw_line:    
    wait_nmi    
    stx PPU_ADDR 
    sty PPU_ADDR
    ldy #$00
    :
        lda ground_texture
        sta PPU_DATA
        iny
        cpy #$20
        bne :-    
        rts