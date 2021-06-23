wait: 
    lda #%10001000                        ;increment mode x1
    sta PPU_CTRL 
    wait_nmi
    lda #$3F
    sta PPU_ADDR
    ldx #$00
    lda #$00
    sta PPU_ADDR
@load:
    lda #$3F                                                                                                                      
    sta PPU_DATA
    inx
    cpx #$20
    bne @load
    rts 