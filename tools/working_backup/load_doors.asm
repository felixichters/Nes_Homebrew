;tmp = x coord pixel
load_doors:
lda #%10101010
sta tmp 
lda #$00
sta tmp2
@load:
lda tmp1 
cmp tmp2 
beq @end
inc tmp2 
ldy tmp2
lda (doors_ptr_x),y
sta tmp3 
lda (doors_ptr_y),y 
sta tmp4 
jsr pixel_to_nt
rol tmp 
bcs @up

@down:
lda #<door_down 
sta room_ptr
lda #>door_down 
sta room_ptr+1 
jsr background_engine 
jmp @load

@up:
lda #<door_up
sta room_ptr
lda #>door_up 
sta room_ptr+1 
jsr background_engine
jmp @load

@end:
    rts 

pixel_to_nt:
lda #$20 
sta ppu_addr_high
lda #$00 
ldx #$00
@calc_addr: 
    clc 
    adc #$20  
    inx 
    cpx tmp4 
    beq @get_addr
    cmp #$00
    bne @calc_addr 

@overflow:
    inc ppu_addr_high
    jmp @calc_addr

@get_addr:
    clc
    adc tmp3
    sta ppu_addr_low
    rts 

     