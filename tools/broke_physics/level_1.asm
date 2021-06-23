level_1:
;lade palletete   
lda #$3F
sta PPU_ADDR
ldx #$00
stx PPU_ADDR
@load:
    lda palette_data,x                                                                                                                      
    sta PPU_DATA
    inx
    cpx #$20
    bne @load

@load_bg:
    jsr load_ground                    
    ;rooms
    lda #<room_1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    sta room_ptr
    lda #>room_1
    sta room_ptr+1                                                                        
    lda #$22
    sta ppu_addr_high
    lda #$F0
    sta ppu_addr_low
    jsr background_engine

    lda #<room_1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    sta room_ptr
    lda #>room_1
    sta room_ptr+1                                                                        
    lda #$22
    sta ppu_addr_high
    lda #$30
    sta ppu_addr_low
    jsr background_engine

    lda #<room_1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    sta room_ptr
    lda #>room_1
    sta room_ptr+1                                                                        
    lda #$21
    sta ppu_addr_high
    lda #$70
    sta ppu_addr_low
    jsr background_engine
    
@load_doors:
    lda #<doors_lvl1_x 
    sta doors_ptr_x
    lda #>doors_lvl1_x
    sta doors_ptr_x+1
    lda #<doors_lvl1_y
    sta doors_ptr_y
    lda #>doors_lvl1_y
    sta doors_ptr_y+1 
    lda #$04
    sta tmp1 
    jsr load_doors 

;load sprites 
    lda #$01                                ;lade alle sprite attribute für spieler 
    sta SPRITE_1_TILE                       ;...
    lda #$00                                ;...
    sta SPRITE_1_ATTR                       ;...
    ldx #$01                                ;...                                                                                                                                                                                                              
    stx SPRITE_1_X                          ;...
    ldy #$D7                                ;...
    sty SPRITE_1_Y                          ;...
;load enemys 
;    lda #<enemys_lvl1_hi                    ;lade hight byte des hibytes der pointer für die gegner in lvl 1 
;    sta enemy_hi_ptr                            ;speichere in pointer 
;    lda #>enemys_lvl1_hi                    ;...
;    sta enemy_hi_ptr+1                          ;...
;    lda #<enemys_lvl1_lo                    ;...
;    sta enemy_lo_ptr                            ;...
;    lda #>enemys_lvl1_lo                    ;...
;    sta enemy_lo_ptr+1                          ;...
;    lda #<enemys_room_1
;    sta enemy_room_ptr
;    lda #>enemys_room_1 
;    sta enemy_room_ptr+1 
;load enemy sprites 
;    lda #$01                                ;lade alle sprite attribute für gegner 
;    sta SPRITE_3_TILE                       ;...
;    lda #$00                                ;...
;    sta SPRITE_3_ATTR                       ;...
;    ldx #$10                                ;...                                                                                                                                                                                                              
;    stx SPRITE_3_X                          ;...
;    ldy #$A5                                ;...
;    sty SPRITE_3_Y                          ;...
;set var 
    ;collision map 
    lda #<collision_map_1                   ;hibyte der collisions map des ersten levels vorberieten
    sta collision_ptr                       ;...
    lda #>collision_map_1                   ;...    
    sta collision_ptr+1                     ;...
    rts                                     ;return 