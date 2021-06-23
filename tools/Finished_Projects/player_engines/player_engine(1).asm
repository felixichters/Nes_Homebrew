check_players: 
    lda buttons1
    sta buttons

    lda acc_x_p1
    sta acc_x
    lda acc_y_p1 
    sta acc_y
    
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
    lda direction_p1
    sta direction
    lda acc_time_p1
    sta acc_time
    lda speed_p1
    sta speed

    jsr player_engine

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
    
    lda px_hold
    sta px_hold_p1
    lda direction
    sta direction_p1
    lda speed 
    sta speed_p1
    rts
;********************************************
    lda buttons2
    sta buttons

    lda acc_x_p2
    sta acc_x
    lda acc_y_p2 
    sta acc_y
    
    lda SPRITE_2_X
    sta p_x 
    lda SPRITE_2_Y 
    sta p_y 
    lda SPRITE_2_TILE 
    sta p_tile 
    lda SPRITE_2_ATTR 
    sta p_attr 
    
    lda px_hold_p2
    sta px_hold 
    lda direction_p2
    sta direction
    lda acc_time_p2
    sta acc_time
    lda speed_p2
    sta speed

    jsr player_engine

    lda acc_x
    sta acc_x_p2
    lda acc_y
    sta acc_y_p2
    
    lda p_x 
    sta SPRITE_2_X
    lda p_y
    sta SPRITE_2_Y
    lda p_tile 
    sta SPRITE_2_TILE
    lda p_attr
    sta SPRITE_2_ATTR
    
    lda px_hold
    sta px_hold_p2
    lda direction
    sta direction_p2
    lda speed 
    sta speed_p2
    rts
;****************************************

cooldown_x:
    lda acc_x 
    cmp #SPEED_MIN
    beq @end1
    lda cooldown_count 
    cmp frame_counter
    bne @end
    lda frame_counter
    clc 
    adc #SPEED_MIN
    sta cooldown_count
    inc acc_x 
    @end:   
        rts
    @end1:
        lda frame_counter
        sta cooldown_count
        rts 

accelerate_x:
    lda px_hold
    cmp p_x
    bne @end 
    lda direction
    beq :+

    lda p_x 
    sec 
    sbc acc_time 
    sta px_hold
    jmp @do_acc 
    :
    lda p_x 
    clc 
    adc acc_time
    sta px_hold
    @do_acc:
    lda acc_x
    cmp #SPEED_MAX
    beq @end 
    dec acc_x
    @end:
        rts

;****************************
player_engine:
lda buttons 
cmp #$00
bne @right 
@standing:
    jsr cooldown_x
    lda acc_y
    cmp #SPEED_MIN
    beq :+
    asl acc_y
    :
    lda p_x
    sta px_hold
    ldx frame_counter
    inx  
    stx speed  
@right:
    lda #BUTTON_RIGHT
    and buttons
    beq @left 
    lda direction
    beq :+
    jsr cooldown_x ;overflow bei acc_x in cooldown_x!!!!!!!!!!!!!!!!!!!!!
    lda acc_x
    cmp #SPEED_MIN
    bne @left
    :
    lda #$00
    sta direction
    jsr accelerate_x
    ;animation
@left: 
    lda #BUTTON_LEFT
    and buttons 
    beq @up
    lda direction
    bne :+
    jsr cooldown_x 
    lda acc_x
    cmp #SPEED_MIN
    bne @up
    :
    lda #$01 
    sta direction
    jsr accelerate_x
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
    
    lda acc_y 
    cmp frame_counter
    bne :+
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
    rts
;*********************************************************
physics_engine:
    @process_x:
        lda speed 
        cmp frame_counter
        bne @process_y 
        lda acc_x
        cmp #SPEED_MIN
        beq @process_y
        lda frame_counter
        clc 
        adc acc_x
        sta speed
        lda direction
        bne :+
        inc p_x
        jmp @process_y
        :
        inc debug 
        dec p_x        
    @process_y:
    rts