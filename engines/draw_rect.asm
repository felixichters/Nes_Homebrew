;x/tmp = breite/horizontal
;y/tmp1= höhe/vertikal
;tmp2 = tile 
draw_rect:
        pha
        txa 
        pha
        tya 
        pha

wait_nmi
    
    stx tmp
    sty tmp1 
    lda #%10001100                        ;increment mode x32
    sta PPU_CTRL
    lda ppu_addr_high
    sta PPU_ADDR
    lda ppu_addr_low
    sta PPU_ADDR
    ldx #$00 
    inc tmp1 
    :
    lda tmp2 
    sta PPU_DATA
    inx 
    cpx tmp1 
    bne :- 
    lda #%10001000                        ;increment mode x1
    sta PPU_CTRL
    ldy #$00
    lda #$F6 
    sta PPU_DATA
    inc tmp2 
    :
    lda tmp2 
    sta PPU_DATA
    iny 
    cpy tmp
    bne :- 
    lda #%10001000                        ;increment mode x1
    sta PPU_CTRL
    lda ppu_addr_high
    sta PPU_ADDR
    lda ppu_addr_low
    sta PPU_ADDR
    ldx #$00 
    lda #$F6 
    sta PPU_DATA
    inc tmp2 
    :
    lda tmp2 
    sta PPU_DATA
    inx 
    cpx tmp
    bne :- 
    lda #%10001100                        ;increment mode x32
    sta PPU_CTRL
    ldy #$00
    lda #$F6 
    sta PPU_DATA
    dec tmp1 
    inc tmp2 
    :
    lda tmp2 
    sta PPU_DATA
    iny 
    cpy tmp1  
    bne :- 

       		pla
        	tay 
        	pla
        	tax 
        	pla
			rts