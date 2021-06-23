load_attributes:
    ldy #$00 
    lda #$23 
    sta PPU_ADDR
    lda #$C0 
    sta PPU_ADDR
    @laod_attributes: 
       lda (attribute_ptr),y 
       sta PPU_DATA 
       iny
       cpy #$40
       bne @laod_attributes
       rts 