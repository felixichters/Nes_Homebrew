;level auswahl bildschirm vorbereiten
;user input verarbeiten
LEVEL_SELECTION:
    hide 
    jsr clear_screen
;load background*******************************
;load borders 
    ldy #$00 
    sty tmp 
    ldx #$20 
    stx tmp1 
    @scan_lines:
    lda #$F6
    sta ground_texture
    ldx tmp1
    ldy tmp
    jsr load_ground
    lda tmp 
    clc 
    adc #$20 
    sta tmp 
    cmp #$00 
    bne :+
    inc tmp1
    : 
    lda tmp1 
    cmp #$23 
    bne @scan_lines
    lda tmp 
    cmp #$A0 
    bne @scan_lines
;inside borders 
    lda #$F8
    sta ground_texture
    ldx #$20
    ldy #$20
    jsr load_ground
    lda #$F9
    sta ground_texture
    ldx #$23
    ldy #$40
    jsr load_ground
    lda #%10001100                        ;increment mode x32
    sta PPU_CTRL
    lda #$FB
    sta ground_texture
    ldx #$20
    ldy #$01
    jsr load_ground
    lda #$FA
    sta ground_texture
    ldx #$20
    ldy #$1E
    jsr load_ground
;0s     
    lda #%10001000                        ;increment mode x32
    sta PPU_CTRL
    lda #$00
    sta ground_texture
    ldx #$23
    ldy #$80
    jsr load_ground
    ldx #$23
    ldy #$60
    jsr load_ground
;outside borders
    lda #$F1
    sta ground_texture
    ldx #$23
    ldy #$A0 
    jsr load_ground
    lda #$F2
    sta ground_texture
    ldx #$20
    ldy #$00
    jsr load_ground
    lda #%10001100                        ;increment mode x32
    sta PPU_CTRL
    lda #$E6
    sta ground_texture
    jsr load_ground
    lda #$E8
    sta ground_texture
    ldx #$20
    ldy #$1F
    jsr load_ground
;load bg loop
    ldx #$00
    :
        lda ppu_h_lvl0,x 
        sta ppu_addr_high
        lda ppu_l_lvl0,x 
        sta ppu_addr_low
        lda hi_room_lvl0,x 
        sta room_ptr
        lda lo_roomm_lvl0,x 
        sta room_ptr+1
        jsr background_engine
        inx 
        cpx #$03 
        bne :-

    ldx #$00
    :
        lda single_tiles_hi,x 
        sta PPU_ADDR
        lda single_tiles_lo,x 
        sta PPU_ADDR
        lda single_tiles,x 
        sta PPU_DATA
        inx 
        cpx #$06
        bne :-
    ;start values
    ldx #$00
    lda #$00
    :
    sta $0210,x 
    inx 
    cpx #$50
    bne :-
    
    lda #CROSSHAIR_TILE1 
    sta SPRITE_1_TILE
    lda #CROSSHAIR_TILE2 
    sta SPRITE_2_TILE
    lda #CROSSHAIR_TILE3
    sta SPRITE_3_TILE
    lda #CROSSHAIR_TILE4 
    sta SPRITE_4_TILE
    lda #$01
    sta SPRITE_1_ATTR
    sta SPRITE_2_ATTR
    sta SPRITE_3_ATTR
    sta SPRITE_4_ATTR
    lda #$20
    sta SPRITE_1_X
    sta SPRITE_1_Y
    sta SPRITE_2_Y 
    lda #$28
    sta SPRITE_2_X
    sta SPRITE_3_Y 
    lda #$20
    sta SPRITE_3_X
    lda #$28
    sta SPRITE_4_Y 
    sta SPRITE_4_X

    lda #$E2 
    sta SPRITE_5_TILE
    lda #$E3 
    sta SPRITE_6_TILE
    lda #$F2 
    sta SPRITE_7_TILE
    lda #$F3 
    sta SPRITE_8_TILE

    lda #$EA 
    sta SPRITE_21_TILE
    lda #$EB
    sta SPRITE_22_TILE
    lda #$FA 
    sta SPRITE_23_TILE
    lda #$FB 
    sta SPRITE_24_TILE

    lda #$E8
    sta SPRITE_13_TILE
    lda #$E9 
    sta SPRITE_14_TILE
    lda #$F8 
    sta SPRITE_15_TILE
    lda #$F9 
    sta SPRITE_16_TILE

    lda #$E4
    sta SPRITE_17_TILE
    lda #$E5 
    sta SPRITE_18_TILE
    lda #$F4
    sta SPRITE_19_TILE
    lda #$F5 
    sta SPRITE_20_TILE

    lda #$E0
    sta SPRITE_9_TILE
    lda #$E1 
    sta SPRITE_10_TILE
    lda #$F0
    sta SPRITE_11_TILE
    lda #$F1 
    sta SPRITE_12_TILE


    lda #$21
    sta ppu_addr_high 
    lda #$6A
    sta ppu_addr_low
    ldx #$0A
    ldy #$03
    lda #$C0 
    sta tmp2 
    jsr draw_rect

    lda #$28
    sta ppu_addr_low
    ldx #$0E
    ldy #$07
    lda #$C0 
    sta tmp2 
    jsr draw_rect    

    lda #$20
    sta ppu_addr_high 
    lda #$E6
    sta ppu_addr_low
    ldx #$12
    ldy #$0B
    lda #$C0 
    sta tmp2 
    jsr draw_rect

    lda #$A4 
    sta ppu_addr_low
    ldx #$16
    ldy #$0F 
    lda #$C0 
    sta tmp2 
    jsr draw_rect
    lda #%10001000                        ;increment mode x32
    sta PPU_CTRL
    lda #$3F
    sta PPU_ADDR
    ldx #$00
    lda #$00
    sta PPU_ADDR
@load:
    lda palette_data_0,x                                                                                                                      
    sta PPU_DATA
    inx
    cpx #$20
    bne @load
    lda #<attributes_level0
    sta attribute_ptr 
    lda #>attributes_level0
    sta attribute_ptr+1 
    jsr load_attributes
    wait_nmi
    show
    lvl_select_loop:
    jsr read_controller
    jsr crosshair ;input handling 
    jsr planet_animation
    :
    lda frame_status 
    beq :-
    lda #$00
    sta frame_status
    inc frame_counter
    jmp lvl_select_loop