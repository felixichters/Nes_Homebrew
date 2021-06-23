;enemy functions 
enemy1:
   ldy enemy_addr 
   lda (addr_ptr),y
   sta tmp2 
   cmp p1_y
   bne @p2
   iny
   iny
   iny 
   lda (addr_ptr),y 
   sta tmp3
   tax
   @check_x:
   cpx p1_x
   beq @attack
   lda eye_direction
   cmp #$01 
   bne :+
   dex 
   dex 
   :
   inx
   ldy tmp2 
   jsr collision 
   bne @check_x 

   @left:
   cpx p1_x
   beq @attack
   dex 
   ldy tmp2 
   jsr collision 
   bne :- 
   @p2:
   lda tmp2 
   cmp p2_y
   bne @end
   ldy tmp3 

   cmp p2_x
   beq @attack
   @end  
   jmp next_enemy 

enemy2: 
    inc SPRITE_3_ATTR 
    jmp next_enemy