clear_screen:
    ldx #$00
    ldy #$00
    lda #$00
    @clear_sprites:
        sta $0200,y 
        iny                         
        cpy #$40
        bne @clear_sprites
    @clear_background:
        lda #$20
        sta PPU_ADDR
        lda #$00
        sta PPU_ADDR
        @load:
            stx $2007
            iny 
            cpx #$03
            beq :+
            cpy #$00
            bne :-
            inx
            jmp @load
        :
            cpy #$80
            bne @load 
rts
