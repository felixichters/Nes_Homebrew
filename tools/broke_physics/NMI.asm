NMI:
    @save_registers:
        pha
        txa 
        pha
        tya 
        pha
    @do_NMI_stuff:
        lda #$02
        sta PPU_OAMDMA
        lda #%00011110
        sta PPU_MASK
        lda #$00
        sta PPU_SCROLL
        sta PPU_SCROLL

        inc frame_counter
        lda frame_counter
        cmp #$40
        bne :
        lda #$00
        sta frame_counter
        :
        
        jsr read_controller
    @get_registers:
        pla
        tay 
        pla
        tax 
        pla
        rti