clear_screen:
    ldy #$00
    lda #$FF
    @clear_sprites:
        sta $0200,y 
        iny                         
        cpy #$FF 
        bne @clear_sprites
    @clear_background:
        lda #$00
        sta tmp1 
        lda #$20 
        sta tmp
        lda #%10001100                        ;increment mode x32
        sta PPU_CTRL 
        :
        lda #$00 
        sta PPU_SCROLL
        sta PPU_SCROLL
        ldx tmp 
        ldy tmp1 
        jsr load_ground
        inc tmp1 
        lda tmp1 
        cmp #$20 
        bne :- 
        lda #%10001000                        ;increment mode x32
        sta PPU_CTRL 
        ldy #$00 
        lda #$23 
        sta PPU_ADDR
        lda #$C0 
        sta PPU_ADDR
    @load_attributes: 
        lda #$00 
        sta PPU_DATA 
        iny
        cpy #$40
        bne @load_attributes
        rts 