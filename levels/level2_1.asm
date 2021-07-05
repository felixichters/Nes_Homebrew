lelvel2_1:
jsr wait 
lda #$CF 
sta ground_texture
jsr clear_screen
IN_MODE_1
    lda #$00
    sta frame_status
    :
    inx 
    cpx #$FF 
    bne :- 
IN_MODE_1
    lda #$00
    sta ground_texture
    hide 
    jsr clear_screen
;load background*******************************
IN_MODE_32
    ldx #$20
    ldy #$01
    lda #$1D
    sta ground_texture
    jsr load_ground

    ldx #$20
    ldy #$02
    jsr load_ground


IN_MODE_1
    ldx #$23
    ldy #$A0
    jsr load_ground

    ldx #$20
    ldy #$20
    jsr load_ground

        ldx #$20
    ldy #$00
    jsr load_ground

;load_doors******************************************
    lda #<doors_lvl2_x 
    sta doors_ptr_x
    lda #>doors_lvl2_x
    sta doors_ptr_x+1
    lda #<doors_lvl2_y
    sta doors_ptr_y
    lda #>doors_lvl2_y
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
    lda #<collision_map_2                   ;hibyte der collisions map des ersten levels vorberieten
    sta collision_ptr                       ;...
    lda #>collision_map_2                   ;...    
    sta collision_ptr+1                     ;...
    lda #<every_frame_lvl2 
    sta every_frame_ptr 
    lda #>every_frame_lvl2
    sta every_frame_ptr+1 

    lda #$04 
    sta collectable_room

    lda #<palette_data_2
    sta palette_ptr
    lda #>palette_data_2
    sta palette_ptr+1
    
;load attributes***********************************
    lda #<attributes_level2
    sta attribute_ptr 
    lda #>attributes_level2
    sta attribute_ptr+1 
    jsr load_attributes
    jsr fade ;palette 
    inc animation_hold_p1
    jmp GAME_LOOP