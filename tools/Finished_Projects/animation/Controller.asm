get_controller_input: 
	LDA #$01
	STA $4016
	LDX #$00
	STX $4016
	stx buttons 
	:
		LDA $4016
		LSR 
		ROL buttons
		INX 
		CPX #$08
		BNE :-
		RTS