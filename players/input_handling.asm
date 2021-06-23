input_handling:
lda acc_y 
lda status_bits 
and #%00111000                  ;if >4 dann 
beq @get_input
lda status_bits
lsr 
lsr 
lsr 
lsr 
bcc :+                          ;wenn nicht in x Richtung gedasht dann weiter 

lda #$10
sta animation_tile
lda acc_x 
beq @reset_status_bits 
lda #SPEED_X_DASH 
sta speed_x
lda #$00 
sta acc_y  
jmp @start
:
lsr 
bcc :+                          ;wenn nicht in y Richtung gedasht, dann weiter 

lda #$0C 
sta animation_tile

lda acc_y 
cmp #$FE 
beq @reset_status_bits
lda #SPEED_Y_DASH
sta speed_y
lda #$00 
sta acc_x 
jmp @start
: 
lsr                             ;wenn nicht in beide richtungen gleichzeitig gedasht, dann ende 
bcc @reset_status_bits

lda #$10 
sta animation_tile

lda acc_y 
beq @reset_status_bits
lda acc_x 
beq @reset_status_bits 
lda #SPEED_XY_DASH
sta speed_y
sta speed_x
jmp @start 
@reset_status_bits:             ;reset status bits, wenn dash vorrüber 
lda status_bits
and #%11000111  
sta status_bits
@get_input:
lda buttons 
bne @right  
@standing:;******************************
    lda default_tile
    sta animation_tile
    lda #$0A 
    sta animation_speed
    lda p_attr
    and #%11111110
    sta p_attr 
@right:;*********************************
    lda #BUTTON_RIGHT
    and buttons
    beq @left 
    lda #%00000000
    sta p_attr
    lda default_tile
    clc 
    adc #$04 
    sta animation_tile
    lda #$03 
    sta animation_speed
    lda acc_x 
    cmp full_speed_x
    beq @left 
    inc acc_x 
    inc acc_x 
@left:;***********************************
    lda #BUTTON_LEFT
    and buttons 
    beq @up
    lda #%01000000
    sta p_attr 
    lda default_tile
    clc 
    adc #$04 
    sta animation_tile
    lda #$03 
    sta animation_speed
    lda acc_x 
    twos_comp acc_x 
    lda tmp 
    cmp full_speed_x 
    beq @up 
    dec acc_x 
    dec acc_x 
@up:;**************************************
    lda #BUTTON_UP
    cmp buttons 
    bne @down 
    lda status_bits
    lsr 
    lsr 
    lsr 
    bcc @down
    lda status_bits
    and #%11111011
    sta status_bits
    ldx p_x 
    lda p_y 
    jsr door_engine 
@down:;************************************
    lda #BUTTON_DOWN
    and buttons 
    beq @a
@a:;jump***********************************
    lda #BUTTON_A
    and buttons 
    beq @b
    ldx p_x 
    ldy p_y 
    iny  
    jsr collision
    beq @paddle 
    lda status_bits
    lsr 
    lsr
    bcc @b
    lda default_tile
    clc 
    adc #$08 
    sta animation_tile 
    lda #$03 
    sta animation_speed
    lda status_bits
    and #%11111101
    sta status_bits
    lda jmp_strength
    sta acc_y
    @paddle:
    lda default_tile
    clc 
    adc #$08 
    sta animation_tile
        lda acc_y 
        asl 
        bcs @b 
        inc acc_y  
@b:;dash**********************************
    lda #BUTTON_B
    and buttons 
    bne :+
    jmp @start 
    :
    lda status_bits
    lsr  
    bcs :+
    jmp @start 
    :
    lda status_bits
    and #%11111110
    sta status_bits
    @dash_right:
    lda #BUTTON_RIGHT
    and buttons
    beq @dash_left
        @right_up:
        lda #BUTTON_UP                      ;wenn buttons = dash & rechts dann hoch 
        and buttons 
        beq @right_down                     ;wenn false dann nächsten fall testen 
        jsr set_x_y
        lda #DASH_RIGHT_ACC                 ;beschleunigungs variable welche abbgebaut werden muss setzen 
        sta acc_x                           ;in x  
        lda #DASH_UP_ACC       
        sta acc_y                           ;in y 
        jmp @start                          ;keine weiteren eingaben testen 
        @right_down:
        jsr set_x_y
        lda #BUTTON_DOWN
        and buttons 
        beq @just_right
        jsr set_x_y
        lda #DASH_RIGHT_ACC                 ;beschleunigung + setzen 
        sta acc_x 
        lda #DASH_DOWN_ACC                  ;beschleunigung - setzen 
        sta acc_y 
        jmp @start 
        @just_right:
        jsr set_x
        lda #DASH_RIGHT_ACC                 ;dauer von dash setzen 
        sta acc_x 
        jmp @start
    @dash_left:
    lda #BUTTON_LEFT
    and buttons 
    beq @dash_up
        @left_up:
        lda #BUTTON_UP
        and buttons 
        beq @left_down
        jsr set_x_y
        lda #DASH_LEFT_ACC 
        sta acc_x
        lda #DASH_UP_ACC 
        sta acc_y 
        jmp @start
        @left_down:
        lda #BUTTON_DOWN
        and buttons 
        beq @just_left
        jsr set_x_y 
        lda #DASH_LEFT_ACC
        sta acc_x
        lda #DASH_DOWN_ACC
        sta acc_y  
        jmp @start 
        @just_left:
        jsr set_x
        lda #DASH_LEFT_ACC 
        sta acc_x 
        jmp @start
    @dash_up:
        lda #BUTTON_UP
        and buttons 
        beq @dash_down
        jsr set_y
        lda #DASH_UP_ACC
        sta acc_y 
        jmp @start 
    @dash_down:
        lda #BUTTON_DOWN
        and buttons
        beq @start
        jsr set_y
        lda #DASH_DOWN_ACC
        sta acc_y  
@start:;**********************************
    lda #BUTTON_START
    and buttons 
    beq @select 
@select:;*********************************
    lda #BUTTON_SELECT
    and buttons 
    beq @end 
@end:;************************************
    jsr dash_reload
    jsr jump_reload
    jsr up_reload
    rts
;***********************************************reloads 
jump_reload:
    lda buttons
    asl 
    bcs :+                                      ;wenn button eimal losgelassen wurde, dann jmp reloaded 
    lda status_bits
    ora #%00000010
    sta status_bits
    :
    rts 
up_reload:
    lda buttons
    asl 
    asl 
    asl 
    asl 
    asl 
    bcs :+
    lda status_bits
    ora #%00000100
    sta status_bits
    :
    rts 
dash_reload:    
    lda buttons
    asl 
    asl 
    bcs :+
    ldx p_x 
    ldy p_y 
    iny 
    jsr collision
    beq :+                                      ;bei kollision mit dem boden und loslassen des Tasters -> dash reloaded 
    lda status_bits
    ora #%00000001
    sta status_bits
    rts 
    :
    rts
;************************************************set methods 
set_x_y:
    lda status_bits
    ora #%00100000   
    sta status_bits
    rts 
set_x:
    lda status_bits
    ora #%00001000
    sta status_bits
    rts 
set_y:
    lda status_bits
    ora #%00010000
    sta status_bits
    rts
;************************************************