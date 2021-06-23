check_players: 
    lda SPRITE_1_X
    sta p_x
    lda SPRITE_1_Y
    sta p_y
    lda SPRITE_1_TILE 
    sta p_tile 
    lda SPRITE_1_ATTR
    sta p_attr
    lda p1_moment
    sta momentum
    lda p1_speed 
    sta speed
    lda buttons1
    sta buttons 
    lda player_grav
    sta gravity 
    lda p1_direction
    sta direction 

    jsr player_engine

    lda p_x
    sta SPRITE_1_X
    lda p_y
    sta SPRITE_1_Y
    lda p_tile
    sta SPRITE_1_TILE
    lda p_attr
    sta SPRITE_1_ATTR
    lda momentum
    sta p1_moment 
    lda speed 
    sta p1_speed
    lda direction
    sta p1_direction
    rts
;p1
;p2

player_engine:
lda buttons 
cmp #$00
bne @right 
    @standing:
        dec speed
    @right:
        lda gravity
        cmp frame_counter
        bne :+ 
        inc speed 
        :
        lda current_frame
        clc 
        adc #$speed 
        cmp frame_counter
        bne @left 
        inc p_x
    @left:
        dec p_x
    @up:
        doors
    @down:
        dec momentum
    @jump:;a
        inc momentum
    @dash:;b 
    rts