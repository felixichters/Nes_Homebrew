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
        lda #$00
        sta PPU_SCROLL
        sta PPU_SCROLL
        lda #$01 
        sta frame_status
    @get_registers:
        pla
        tay 
        pla
        tax 
        pla
        rti