Load_Sprites:									;Sprite Startwerte vorbereiten
		LDY #$00								;Counter reset
		:		
		LDA MS_pointer,x						;Lade a mit Metasprite pointer 
		STA $0200,x 							;erst zwei Spieler Sprites, dann Rest
		INX 									;Inkrementiere Adressen counter
		INY										;Inkremntiere Sprite attribte couter
		CPY #$04								
		BNE :-
		RTS 
