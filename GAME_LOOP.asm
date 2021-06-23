GAME_LOOP:       
  jsr read_controller       
  jsr process_players  
  jsr every_frame_engine
  jsr collectable 
  :
  lda frame_status 
  beq :-
  lda #$00
  sta frame_status
  inc frame_counter

  jmp GAME_LOOP