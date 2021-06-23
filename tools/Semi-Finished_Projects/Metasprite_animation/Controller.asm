	Controller: 
		LDA #$01
		STA $4016
		LDX #$00
		STX $4016
		
		@controller_loop:
			LDA $4016
			LSR 
			ROL buttons
			INX 
			CPX #$08
			BNE @controller_loop
			
			@check_a:
				LDA #%10000000
				AND buttons
				BEQ @check_b
				
			@check_b:
				LDA #%01000000
				AND buttons
				BEQ @check_up
				
			@check_up:
				LDA #%00001000
				AND buttons
				BEQ @check_down				
			;	DEC SPRITE1Y
			;	LDA #$03
			;	STA sprite_1_trigger
			;	LDX SPRITE1X
			;	LDY SPRITE1Y
			;	JSR check_collision
			;	BEQ @check_down
			;	INC SPRITE1Y
			
			@check_down:
				LDA #%00000100
				AND buttons
				BEQ @check_left
			;	INC SPRITE1Y
			;	LDX SPRITE1X
			;	LDY SPRITE1Y
			;	JSR check_collision
			;	BEQ @check_left
			;	DEC SPRITE1Y
				
			@check_left:
				LDA #%00000010
				AND buttons
				BEQ @check_right
				LDX SPRITE1_1_X
				DEX
				LDY SPRITE1_1_Y
				JSR check_collision
				BNE @check_right
				LDA #%00000001
				ORA sprite_1_trigger
				STA sprite_1_trigger
			
			@check_right:
				LDA #%00000001
				AND buttons
				BEQ :+
				LDX SPRITE1_1_X
				INX
				LDY SPRITE1_1_Y
				JSR check_collision
				BNE :+
				LDA #$00000010
				ORA sprite_1_trigger
				STA sprite_1_trigger
				:
				RTS
				

Player_engine:

	JMP @trigger_check
	
	@right:
		LDX frame_counter
		CPX frame_counter_buffer
		BEQ @walk_right_animation
		
		@walk_right_animation:
			INC SPRITE1_1_X
			INC SPRITE1_2_X
			INC SPRITE1_3_X
			INC SPRITE1_4_X
		:
			LDA METASPRITE_1_walking,x
			STA $0200,y
			TYA
			CLC 
			ADC #$05
			TAY
			CPX #$04
			BNE :-
			LDX #$00
			
	@left:
	
	@trigger_check:
		LDX metasprite_counter
		LDY tile_counter
		LDA sprite_1_trigger
		CMP #$00000001
		BEQ @left
		
		CMP #$00000010
		BEQ @right
		
		@Reset_Frame_Counter_Buffer:
			LDY #$00
			STY sprite_1_trigger
			STY metasprite_counter
			STY tile_counter
			LDA frame_counter								
			CLC 
			ADC #$30
			STA frame_counter_buffer
			
	@end:
		RTS
	
	