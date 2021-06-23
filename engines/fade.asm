fade:
    lda #$3F
    sta PPU_ADDR
    ldx #$00
    stx PPU_ADDR
    ldy #$00
    :
    lda (palette_ptr),y
    sta PPU_DATA
    iny 
    cpy #$20 
    bne :- 
    wait_nmi
    lda #%10001000                        ;increment mode x1
    sta PPU_CTRL 
    show 
    rts 

;wait 
    ldx #$00
    :
    lda frame_status
    beq :- 
    lda #%10001000                        ;increment mode x1
    sta PPU_CTRL 
    lda #$00
    sta frame_status
    inx 
    cpx #$50
    bne :- 

    lda #$3F
    sta PPU_ADDR
    ldx #$00
    stx PPU_ADDR
    ldy #$00
    @loop:
    wait_nmi
    lda (palette_ptr),y 
    sta PPU_DATA
    lda #%10001000                        ;increment mode x1
    sta PPU_CTRL 
    iny 
    cpy #$20 
    bne @loop
    
    lda #%10001000                        ;increment mode x1
    sta PPU_CTRL 
    lda #%00010000
    ora PPU_MASK
    sta PPU_MASK
    rts 