check_players: 
    lda buttons1
    sta buttons
    lda acc_x_p1
    sta acc_x 
    lda acc_y_p1 
    sta acc_y 
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
    lda tile_count_p1 
    sta tile_count
    lda #$04
    sta animation_speed
    lda #$01 
    sta default_tile

    jsr input_handling

    lda acc_x 
    sta acc_x_p1
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
    lda tile_count
    sta tile_count_p1
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
    sty tile_count
    lda default_tile  
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
    lda #%00000001
    sta p_attr 
@left: 
    lda #BUTTON_LEFT
    and buttons 
    beq @up
    lda #%01000001
    sta p_attr 
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
    jsr physics_engine
    jsr animate 

    rts


physics_engine: 
    ldx p_x 
    ldy p_y 
    jsr collision
    bne @end 
;process x
    twos_comp acc_x  
    lda tmp  
    cmp #FULL_SPEED  
    beq @full_speed 
    lda frame_hold
    cmp frame_counter
    bne @process_y
    lda frame_counter
    clc 
    adc #ACC_SPEED
    sta frame_hold
    lda p_attr 
    asl 
    asl 
    bcs @left 
    inc p_x
    inc acc_x 
    jmp @process_y 
    @left:
    dec acc_x
    dec p_x 
    jmp @process_y
    @full_speed:
        lda p_attr 
        asl 
        asl 
        bcs @l
        inc p_x 
        jmp @process_y 
        @l:
        dec p_x  

    @process_y:
        ;gravity  
        ldy p_y
        dey 
        ldx p_x 
        jsr collision
        bne @ground  
        dec acc_y
        ;inc y 
        lda acc_y 
        asl 
        bcs :+
        dec p_y  
        dec p_y 
        :
        inc p_y 
        inc p_y  
    @end:
        rts 
;********************
    @gravity: 
        dec acc_y 
        
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
    inc tile_count
    ldy tile_count
    cpy #MAX_TILES
    bne :+
    tya
    sec 
    sbc #MAX_TILES
    tay  
    sta tile_count
    : 
    sty tmp 
    lda default_tile
    clc 
    adc tmp  
    sta p_tile 
    @end:
    rts 