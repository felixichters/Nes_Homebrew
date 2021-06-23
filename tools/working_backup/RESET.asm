RESET:
	SEI 									;setze interrupt-flag
	CLD 									;dezimal ausschalten
	LDA #$40								;64dec laden
	STA $4017								;nach 4017 (frame counter control(APU)) speichern
	LDX #$FF								;x = FF 
	TXS										;x auf STAck
	INX										;x-
	STX $2000								;PPUCTRL alles auf 0 (NMI usw. ausschalten)
	STX $2001								;PPUMASK ales auf 0 (background und sprite sausschalten)
	STX $4010								;IRQ ausschalten (APU)
	:
		BIT $2002
		BPL :-								;warte auf veRTIcal blank
	TXA										;schreibe 00 in accumulator
Clearmemory:
	STA $0000, X 							; $0000 = (1byte)
	STA $0100, X 							; $0100 =
	STA $0300, X							;...
	STA $0400, X							;...
	STA $0500, X							;...
	STA $0600, X							;...
	STA $0700, X							;...
	LDA #$FF								;...
	STA $0200, X 							; $0200 =
	LDA #$00								;...
	INX										;...
	BNE Clearmemory
	LDA #$02								
	STA $4014
	NOP	
	:
	BIT $2002
	BPL :-								;warte auf veRTIcal blank