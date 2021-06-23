process_players: 
;player 1************************************************************************
ldy #$00
:
lda buttons1,y
sta buttons,y 
iny 
cpy #$0A
bne :- 
lda current_room_p1
sta room_backup_p1
lda SPRITE_1_X
sta p_x 
lda SPRITE_1_Y 
sta p_y 
lda SPRITE_1_TILE 
sta p_tile 
lda SPRITE_1_ATTR 
sta p_attr 
;**********************
lda #DEFAULT_TILE_P1 
sta default_tile
sta animation_tile
;*********************
lda #FULL_ACC_X_P
sta full_acc_x
lda #ACC_SPEED_X_P 
sta acc_speed_x 
lda #FULL_SPEED_X_P 
sta full_speed_x 
lda #FULL_ACC_Y_P
sta full_acc_y
lda #SPEED_Y_P
sta speed_y
lda #SPEED_X_P
sta speed_x 
lda #JMP_STRENGTH_P
sta jmp_strength
;________________________________
lda input_lock1
bne :+
jsr input_handling
:
jsr physics_engine 
jsr animation
;________________________________
ldy #$00
:
lda buttons,y 
sta buttons1,y 
iny 
cpy #$0A
bne :-
lda p_x 
sta SPRITE_1_X
lda p_y
sta SPRITE_1_Y
lda p_tile 
sta SPRITE_1_TILE
lda p_attr
sta SPRITE_1_ATTR
  lda room_backup_p1 
  cmp current_room_p1
  beq :+ 
  lda status_bits_p1
  and #%01111111
  sta status_bits_p1
  :

;player 2************************************************************************
ldy #$00
:
lda buttons2,y
sta buttons,y 
iny 
cpy #$0A
bne :- 
lda current_room_p2
sta room_backup_p2
lda SPRITE_2_X
sta p_x 
lda SPRITE_2_Y 
sta p_y 
lda SPRITE_2_TILE 
sta p_tile 
lda SPRITE_2_ATTR 
sta p_attr 
;**********************
lda #DEFAULT_TILE_P2
sta default_tile
sta animation_tile
;*********************
lda #FULL_ACC_X_P
sta full_acc_x
lda #ACC_SPEED_X_P 
sta acc_speed_x 
lda #FULL_SPEED_X_P 
sta full_speed_x 
lda #FULL_ACC_Y_P
sta full_acc_y
lda #SPEED_Y_P
sta speed_y
lda #SPEED_X_P
sta speed_x 
lda #JMP_STRENGTH_P
sta jmp_strength
;________________________________
lda input_lock2 
bne :+
jsr input_handling
:
jsr physics_engine 
jsr animation
;________________________________
ldy #$00
:
lda buttons,y 
sta buttons2,y 
iny 
cpy #$0A
bne :-
lda p_x 
sta SPRITE_2_X
lda p_y
sta SPRITE_2_Y
lda p_tile 
sta SPRITE_2_TILE
lda p_attr
sta SPRITE_2_ATTR
  lda room_backup_p2 
  cmp current_room_p2
  beq :+ 
  lda status_bits_p2
  and #%01111111
  sta status_bits_p2
  :
rts


;player hit !!!!!!!!!!!!!!!!!!