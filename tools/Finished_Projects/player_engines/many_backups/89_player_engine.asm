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
    inc acc_x
@left: 
    lda #BUTTON_LEFT
    and buttons 
    beq @up
    lda #%01000001
    sta p_attr 
    inc acc_x
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
    lda status_bits 
    lsr 
    bcs @b 
    inc acc_y
    inc acc_y 
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
    bne @process_y
;process x
;ground 
    twos_comp acc_x
    lda tmp 
    asl 
    bcs :+ 
    lda acc_x
    asl 
    bcs @right 

    @right:
    lda acc_x 
    clc 
    adc ground_rest
    sta acc_x 

    :
    lda tmp 
    lsr 
    lsr 
    lsr 
    lsr 
    bne @full_speed 
;every second frame 
    inc acc_count 
    cmp acc_hold 
    bne @process_y
    ldx acc_count
    inx 
    inx 
    stx acc_hold 
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
;gravity*****************************  
       
;move y***************************** 
        twos_comp acc_y
        lda tmp 
        cmp #TOP_Y_SPEED  
        beq @down 
        lda acc_y 
        asl 
        bcs @down
        dec p_y  
        ;dec p_y 
        @down:
        lda status_bits
        ora #%00000001
        sta status_bits
        ldy p_y
        dey 
        ldx p_x 
        jsr collision
        bne @ground
        inc p_y 
        ;inc p_y  
    @end:
        rts 
    @ground:
        lda #$00
        sta acc_y
        lda status_bits
        and #%11111110
        sta status_bits
        jmp @end 
;********************
        
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