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

    jsr player_engine

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
;********************************************
;p2
    rts
;****************************************
;****************************
player_engine:
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
@right:
    lda #BUTTON_RIGHT
    and buttons
    beq @left 
    ldx p_x 
    ldy p_y 
    jsr collision 
    bne @left
    lda p_attr
    asl 
    asl 
    bcc :+
    lda p_x 
    sta px_hold
    lda #$00
    sta tile_count_x
    :
    lda #%00000001
    sta p_attr
    jsr animate 
    inc p_x
    inc p_x 
@left: 
    lda #BUTTON_LEFT
    and buttons 
    beq @up
    ldx p_x 
    ldy p_y 
    jsr collision 
    bne @left
    lda p_attr
    asl 
    asl 
    bcs :+
    lda p_x 
    sta px_hold
    lda #$00
    sta tile_count_x
    :
    lda #%01000001
    sta p_attr
    jsr animate
    dec p_x
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
   ; lda p_y 
  ;  clc 
  ;  adc #$
    ;speed auf Max speed setzen 
    ;speed über gravitation bis collision abbauen 
    ;weiterer input 

   ; lda speed
   ; cmp frame_counter
   ; bne @b 
   ; lda frame_counter
   ; clc 
   ; adc acc_y
   ; lda p_y 
   ; inc acc_y 
   ; lda acc_y 
   ; cmp #$MIN_SPEED 
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
   ; lda p_y 
  ;  clc 
  ;  adc #$08 
  ;  tay 
 ;   ldx p_x 
  ;  jsr collision
 ;   beq :+
    ;jsr physics_engine

  ;  :
    rts
;*********************************************************

;deccelerate: 
;    lda frame_counter
;    cmp frame_hold 
;    bne @end 
;    dec acceleration
;    lda frame_counter
;    clc 
;    adc gravity 
;    sta frame_hold 
;    @end: 
;        rts
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