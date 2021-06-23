;tmp = x coord pixel
load_doors:
lda #$00
sta tmp2
@load:
lda tmp1 
cmp tmp2 
beq @end
inc tmp2 
ldy tmp2
lda (doors_ptr_x),y
tax  
lda (doors_ptr_y),y 
tay  
 sty tmp4 
    stx tmp3 
    lda #$20 
    sta ppu_addr_high
    lda #$00
    sta ppu_addr_low 
    ldx #$00
    @calc_addr: 
        clc 
        adc #$20
        bne :+
        inc ppu_addr_high
        :
        inx 
        cpx tmp4 
        bne @calc_addr
    @get_addr:
        clc
        adc tmp3
        sta ppu_addr_low

lda #<door_up
sta room_ptr
lda #>door_up 
sta room_ptr+1 
jsr background_engine
jmp @load
@end:
rts 
