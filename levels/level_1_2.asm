level_1:
jmp hier 
jsr wait 
lda #$CF 
sta ground_texture
jsr clear_screen

    lda #<lamuella                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    sta room_ptr
    lda #>lamuella
    sta room_ptr+1                                                                        
    lda #$21
    sta ppu_addr_high
    lda #$8C
    sta ppu_addr_low
    jsr background_engine

    lda #%10001000                        ;increment mode x1
    sta PPU_CTRL 
    lda #$3F
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
    lda #$3F                                                                                                                      
    sta PPU_DATA
    lda #$30 
    sta PPU_DATA
    lda #$31 
    sta PPU_DATA
    lda #$32
    sta PPU_DATA
    ldx #$00 
    :
    lda frame_status
    beq :- 
    lda #%10001000                        ;increment mode x1
    sta PPU_CTRL 
    lda #$00
    sta frame_status
    inx 
    cpx #$FF 
    bne :- 
    lda #%10001000 
    sta PPU_CTRL
    lda #$00
    sta ground_texture
    hide 

    hier:
    jsr clear_screen
;load background*******************************
    lda #%10001100                        ;increment mode x1
    sta PPU_CTRL 

    ldx #$20
    ldy #$01
    lda #$1D
    sta ground_texture
    jsr load_ground

    ldx #$20
    ldy #$02
    jsr load_ground

    ldx #$20
    ldy #$03
    jsr load_ground

    ldx #$20
    ldy #$04
    jsr load_ground

    ldx #$20
    ldy #$1D
    jsr load_ground

    ldx #$20
    ldy #$1C
    jsr load_ground

    ldx #$20
    ldy #$1D
    jsr load_ground

    ldx #$20
    ldy #$1E
    jsr load_ground

    ldx #$20
    ldy #$1F
    jsr load_ground

    lda #%10001000                        ;increment mode x1
    sta PPU_CTRL 

    ldx #$23
    ldy #$A0
    jsr load_ground

    ldx #$20
    ldy #$20
    jsr load_ground

        ldx #$20
    ldy #$00
    jsr load_ground

    lda #%10001100                        ;increment mode x1
    sta PPU_CTRL 

    ldx #$20
    ldy #$00
    lda #$0D
    sta ground_texture
    jsr load_ground
    
        lda #$22
        sta ppu_addr_high
        lda #$E0
        sta ppu_addr_low
        lda #<room_1
        sta room_ptr
        lda #>room_1  
        sta room_ptr+1
        jsr background_engine 

        lda #$22
        sta ppu_addr_high
        lda #$21
        sta ppu_addr_low
        lda #<room_2
        sta room_ptr
        lda #>room_2
        sta room_ptr+1
        jsr background_engine   

        lda #$21
        sta ppu_addr_high
        lda #$61
        sta ppu_addr_low
        lda #<room_3
        sta room_ptr
        lda #>room_3
        sta room_ptr+1
        jsr background_engine 

        lda #$20
        sta ppu_addr_high
        lda #$C3 
        sta ppu_addr_low
        lda #<room_4
        sta room_ptr
        lda #>room_4
        sta room_ptr+1
        jsr background_engine 

        lda #$20
        sta ppu_addr_high
        lda #$A3
        sta ppu_addr_low
        lda #<room_5_ground
        sta room_ptr
        lda #>room_5_ground
        sta room_ptr+1
        jsr background_engine 

        lda #$20
        sta ppu_addr_high
        lda #$23
        sta ppu_addr_low
        lda #<room_5
        sta room_ptr
        lda #>room_5
        sta room_ptr+1
        jsr background_engine

        lda #$23
        sta PPU_ADDR
        lda #$A0
        sta PPU_ADDR
        lda #$1D
        sta PPU_DATA

;load_doors******************************************
    lda #<doors_lvl1_x 
    sta doors_ptr_x
    lda #>doors_lvl1_x
    sta doors_ptr_x+1
    lda #<doors_lvl1_y
    sta doors_ptr_y
    lda #>doors_lvl1_y
    sta doors_ptr_y+1 
    lda #$08
    sta tmp1 
    jsr load_doors 
;set coords ******************************************
    lda #$10
    sta SPRITE_1_X 
    lda #$D8
    sta SPRITE_1_Y
    lda #$00
    sta SPRITE_1_ATTR 
    
    lda #$18
    sta SPRITE_2_X 
    lda #$D8
    sta SPRITE_2_Y
    lda #$00
    sta SPRITE_2_ATTR 

    lda #$44
    sta collectable_tile
    lda #$80
    sta SPRITE_3_X
    lda #$10 
    sta SPRITE_3_Y
    lda #$00 
    sta SPRITE_3_ATTR
;stomper
    lda #$47
    sta SPRITE_13_Y
    lda #$61
    sta SPRITE_13_X
    lda #$01 
    sta SPRITE_10_ATTR 
    lda #$03
    sta current_room_e4 
;vaccum
    lda #$1F
    sta SPRITE_10_Y
    lda #$60
    sta SPRITE_10_X
    lda #$02
    sta SPRITE_13_ATTR 
    lda #$04
    sta current_room_e3  
;cat
    lda #$98
    sta SPRITE_7_Y
    lda #$80
    sta SPRITE_7_X
    lda #$03
    sta SPRITE_7_ATTR
    lda #$01
    sta current_room_e2
;set var *********************************** 
    ;collision map 
    lda #<collision_map_1                   ;hibyte der collisions map des ersten levels vorberieten
    sta collision_ptr                       ;...
    lda #>collision_map_1                   ;...    
    sta collision_ptr+1                     ;...
    lda #<every_frame_lvl1 
    sta every_frame_ptr 
    lda #>every_frame_lvl1
    sta every_frame_ptr+1 

    lda #$04 
    sta collectable_room

    lda #<palette_data_1
    sta palette_ptr
    lda #>palette_data_1
    sta palette_ptr+1
    
;load attributes***********************************
    lda #<attributes_level1
    sta attribute_ptr 
    lda #>attributes_level1
    sta attribute_ptr+1 
    jsr load_attributes
    jsr fade ;palette 
    inc animation_hold_p1
    jmp GAME_LOOP