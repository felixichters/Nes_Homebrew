check_players: 
    lda buttons1
    sta buttons
    lda px_hold_p1
    sta px_hold 
    lda SPRITE_1_X
    sta p_x 
    lda SPRITE_1_Y 
    sta p_y 
    lda SPRITE_1_TILE 
    sta p_tile 
    lda SPRITE_1_ATTR 
    sta p_attr 
    lda px_hold_p1
    sta px_hold 
    lda tile_count_x_p1 
    sta tile_count_x
    lda tile_count_y_p1 
    sta tile_count_y 
    lda #$04
    sta animation_speed
    lda #<player_animation
    sta animation_ptr
    lda #>player_animation
    sta animation_ptr+1

    jsr input_handling

    lda acc_y
    sta acc_y_p1
    lda p_x 
    sta SPRITE_1_X
    lda p_y
    sta SPRITE_1_Y
    lda p_tile 
    sta SPRITE_1_TILE
    lda p_attr
    sta SPRITE_1_ATTR
    lda tile_count_x
    sta tile_count_x_p1
    lda px_hold
    sta px_hold_p1
    rts

input_handling:
lda buttons 
cmp #$00
bne @right 
@standing:
    ldx p_x
    stx px_hold 
    ldy #$00
    sty tile_count_x
    lda (animation_ptr),y 
    sta p_tile
    ldx frame_counter
    inx
    stx frame_hold
    lda #$00
    sta acc_x
@right:
    lda #BUTTON_RIGHT
    and buttons
    beq @left 
    ldx p_x 
    ldy p_y 
    jsr collision
    bne @left 
    lda acc_x 
    cmp #$02 
    beq @full_speed 
    lda frame_hold
    cmp frame_counter
    bne @end_right  
    lda frame_counter
    clc 
    adc #$04
    sta frame_hold
    inc p_x
    inc acc_x
    jmp @end_right 
    @full_speed:
        inc p_x  
    @end_right:
       ; jsr animate 
@left: 
    lda #BUTTON_LEFT
    and buttons 
    beq @up

@up:   
    lda #BUTTON_UP
    and buttons 
    beq @down 
    ldx p_x 
    lda p_y 
    sta current_y
    jsr door_engine 
    sta p_y 
@down:
    lda #BUTTON_DOWN
    and buttons 
    beq @a
@a:;jump
    lda #BUTTON_A
    and buttons 
    beq @b

@b:;dash
    lda #BUTTON_B
    and buttons 
    beq @start 
@start:
    lda #BUTTON_START
    and buttons 
    beq @select 
@select:
    lda #BUTTON_SELECT
    and buttons 
    beq @end 

@end:   
    rts

animate:
    ldx p_x 
    cpx px_hold
    bne @end 
    lda p_attr
    asl 
    asl 
    bcs :+

    lda p_x 
    clc 
    adc animation_speed
    jmp @animate

    :
    lda p_x 
    sec 
    sbc animation_speed

    @animate: 
    sta px_hold
    inc tile_count_x
    ldy tile_count_x
    cpy #MAX_TILES
    bne :+
    tya
    sec 
    sbc #MAX_TILES
    tay 
    sta tile_count_x
    : 
    lda (animation_ptr),y 
    sta p_tile 
    @end:
    rts 

physics_engine: