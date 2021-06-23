.macro twos_comp addr 
    lda addr 
    sta tmp 
    asl 
    bcc :+
    lda tmp 
    eor #$FF 
    sta tmp 
    inc tmp 
    :
.endmacro

.macro wait_nmi
    :
    BIT $2002
    BPL :-
.endmacro

.macro show
    lda #%00011110
    ora PPU_MASK
    sta PPU_MASK
.endmacro

.macro hide 
    lda #%11100111
    and PPU_MASK
    sta PPU_MASK
.endmacro