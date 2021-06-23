;tmp3 = current_planet 
crosshair:
    @right:
        lda #BUTTON_RIGHT
        and buttons1
        beq @left
        lda SPRITE_2_X 
        cmp #$E9
        beq @left 
        inc SPRITE_1_X 
          inc SPRITE_2_X 
            inc SPRITE_3_X 
              inc SPRITE_4_X 
    @left:
        lda #BUTTON_LEFT
        and buttons1
        beq @up
        lda SPRITE_1_X 
        cmp #$10
        beq @up
        dec SPRITE_1_X
          dec SPRITE_2_X
            dec SPRITE_3_X
              dec SPRITE_4_X 
        
    @up:
        lda #BUTTON_UP
        and buttons1
        beq @down 
        lda SPRITE_1_Y 
        cmp #$0E
        beq @down
        dec SPRITE_1_Y 
          dec SPRITE_2_Y 
            dec SPRITE_3_Y 
              dec SPRITE_4_Y   
    @down:
        lda #BUTTON_DOWN 
        and buttons1
        beq @end 
        lda SPRITE_4_Y 
        cmp #$C7 
        beq @end
        inc SPRITE_1_Y 
          inc SPRITE_2_Y 
            inc SPRITE_3_Y 
              inc SPRITE_4_Y 
    @end:
    
        rts 