level_1:
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
    lda #$25
    sta ground_texture
    ldx #$23
    ldy #$A0
    jsr load_ground
    lda #$24 
    sta ground_texture
    ldx #$23
    ldy #$80
    jsr load_ground

        lda #$22
        sta ppu_addr_high
        lda #$E5
        sta ppu_addr_low
        lda #<room_1_1
        sta room_ptr
        lda #>room_1_1 
        sta room_ptr+1
        jsr background_engine

        lda #$21
        sta ppu_addr_high
        lda #$2F
        sta ppu_addr_low
        lda #<room_2_2
        sta room_ptr
        lda #>room_2_2 
        sta room_ptr+1
        jsr background_engine 

        lda #$22
        sta ppu_addr_high
        lda #$D6
        sta ppu_addr_low
        lda #<connection_1_1
        sta room_ptr
        lda #>connection_1_1 
        sta room_ptr+1
        jsr background_engine 

        lda #$21
        sta ppu_addr_high
        lda #$21
        sta ppu_addr_low
        lda #<room_3_3
        sta room_ptr
        lda #>room_3_3 
        sta room_ptr+1
        jsr background_engine 

        lda #$21
        sta ppu_addr_high
        lda #$E9
        sta ppu_addr_low
        lda #<connection_room_2_3
        sta room_ptr
        lda #>connection_room_2_3
        sta room_ptr+1
        jsr background_engine 

        lda #$20
        sta ppu_addr_high
        lda #$41
        sta ppu_addr_low
        lda #<room_4_4
        sta room_ptr
        lda #>room_4_4 
        sta room_ptr+1
        jsr background_engine 

        lda #$21
        sta ppu_addr_high
        lda #$05
        sta ppu_addr_low
        lda #<connection_1_1
        sta room_ptr
        lda #>connection_1_1
        sta room_ptr+1
        jsr background_engine 

        lda #$20
        sta ppu_addr_high
        lda #$4F
        sta ppu_addr_low
        lda #<room_4_4_2
        sta room_ptr
        lda #>room_4_4_2
        sta room_ptr+1
        jsr background_engine 
;load_doors******************************************
    lda #<doors_lvl1_1_x 
    sta doors_ptr_x
    lda #>doors_lvl1_1_x
    sta doors_ptr_x+1
    lda #<doors_lvl1_1_y
    sta doors_ptr_y
    lda #>doors_lvl1_1_y
    sta doors_ptr_y+1 
    lda #$06
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
    lda #$A8
    sta SPRITE_3_X
    lda #$1A
    sta SPRITE_3_Y
    lda #$00 
    sta SPRITE_3_ATTR
;stomper
    lda #$60
    sta SPRITE_13_Y
    lda #$98
    sta SPRITE_13_X
    lda #$01
    sta SPRITE_10_ATTR 
    lda #$02
    sta current_room_e4 
;vaccum
    lda #$37
    sta SPRITE_10_Y
    lda #$60
    sta SPRITE_10_X
    lda #$02
    sta SPRITE_13_ATTR 
    lda #$03
    sta current_room_e3  
;cat
    lda #$87
    sta SPRITE_7_Y
    lda #$82
    sta SPRITE_7_X
    lda #$03
    sta SPRITE_7_ATTR
    lda #$01
    sta current_room_e2
;set var *********************************** 
    ;collision map 
    lda #<collision_map_1_1                   ;hibyte der collisions map des ersten levels vorberieten
    sta collision_ptr                       ;...
    lda #>collision_map_1_1                   ;...    
    sta collision_ptr+1                     ;...
    lda #<every_frame_lvl1
    sta every_frame_ptr 
    lda #>every_frame_lvl1
    sta every_frame_ptr+1 

    lda #$03
    sta collectable_room

    lda #<palette_data_1_1
    sta palette_ptr
    lda #>palette_data_1_1
    sta palette_ptr+1
    
;load attributes***********************************
    lda #<attributes_level1_1
    sta attribute_ptr 
    lda #>attributes_level1_1
    sta attribute_ptr+1 
    jsr load_attributes
    jsr fade ;palette 
    inc animation_hold_p1
    jmp GAME_LOOP