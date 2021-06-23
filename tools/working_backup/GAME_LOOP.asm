GAME_LOOP:             
  jsr check_players 
  jsr enemy_engine
  ;gegner bewegen 
  jmp GAME_LOOP