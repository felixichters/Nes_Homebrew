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
		
PALETTE_DATA:
	.byte $3F,$00,$30,$30,  $3F,$00,$30,$30, $3F,$00,$30,$30,  $3F,$00,$30,$30 				;background data
	.byte $3F,$11,$14,$17,  $3F,$11,$14,$17, $3F,$11,$14,$17,  $3F,$11,$14,$17 	 	 		;sprite data
		