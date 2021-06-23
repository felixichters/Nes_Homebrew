Load_palette:
	LDX #$00
	@config:
		LDA #$3F 
		STA $2006 
		LDA #$00
		STA $2006
		
	@load:
		LDA PALETTE_DATA,x 
		STA $2007
		INX 
		CPX #$20
		BNE @load
	
	:
		BIT $2002
		BPL :-
