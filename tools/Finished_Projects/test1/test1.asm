.segment "HEADER"
  .byte "NES", $1A
  .byte 2         					; 1 or 2 for NROM-128 or NROM-256 respectively
  .byte 1         					; 8 KiB CHR ROM
  .byte $00       					; Mapper 0; $00 or $01 for horizontal or vertical mirroring respectively
  .byte $08       					; Mapper 0; NES 2.0
  .byte $00      				    ; No submapper
  .byte $00       					; PRG ROM not 4 MiB or larger
  .byte $00     						; No PRG RAM
  .byte $00     						; No CHR RAM
  .byte $01    						; 0 or 1 for NTSC or PAL respectively
  .byte $00     						; No special PPU
 
.segment "ZEROPAGE"
;**********************************************************************************************************************************
	buttons: .res 1 				;1 byte resevieren für buttonstatus 
.segment "STARTUP"
;**********************************************************************************************************************************
.segment "CODE"
;**********************************************************************************************************************************
RESET:
    SEI 							;interrupts aussschalten
	CLD 							;dezimal asuschalten
	
									;sound interrupt ausschalten
	LDX #$40
	STX $4017
	
									;init Stack
	LDX #$FF
	TXS
	INX
	
									;PPU zurücksetzen
	STX $2000
	STX $2001
	
	STX $4010
	
:
    BIT $2002
    BPL :-

    TXA

CLEARMEM:
    STA $0000, X 					; $0000 => $00FF
    STA $0100, X 					; $0100 => $01FF
    STA $0300, X
    STA $0400, X
    STA $0500, X
    STA $0600, X
    STA $0700, X
    LDA #$FF
    STA $0200, X 					; $0200 => $02FF
    LDA #$00
    INX
    BNE CLEARMEM 
	LDX #$00
	
constants:
	SPRITEX = 0203
	SPRITEY = 0200
loadcolor:
									;PPU Register 3F00 ansprechen
	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
	LDX #$00
	
loadpallettedata:
									;Palette füllen (PPU zählt automatisch hoch 3F00 -> 3F01....)
	LDA palettedata,x 
	STA $2007 
	INX
	CPX #$20
	BNE loadpallettedata
	
	LDY #$00
	
selectsprites:
									;spriteinfos laden
	LDA spritedata, y
	STA $0200, y       				;sprite infos werden in RAM geladen
	INY
	CPY #$04
	BNE selectsprites
	
startupdate:

	CLI          					 ;interrupts anschalten

    LDA #%10001000    				; NMI anschalten
    STA $2000
   
    LDA #%00011110    				;sprites anschalten
    STA $2001
	
	
controller:
									;controller port "pollen"
	LDA #$01
	STA $4016
	LDX #$00
	STX $4016
	
controllerloop:
	LDA $4016    					;der wert der in 4016(controller Port) steht wird in A gespeichert                                  7 6 5 4 3 2 1 
	LSR        						 ; buttoninfo liegt nur im lsb, dieses wird nach rechts geshcoben und landet somit im carry flag|    A B s S U D L R
	ROR buttons  					;die buttonifo wird in byte buttons über rotate right gespeichert, da das carry flag den wert gespeichert hat wird dieser übernommen
	INX        						 ;erster durchlauf button A zweiter B .....
	CPX #$08    						;alle 8 buttons
	BNE controllerloop
	
checkright:
									;wenn der wert in A nicht der selbe ist wie in buttons dann nächste routine
	LDA #%10000000
	AND buttons
	BEQ checkleft  
	
									;addiere Xcoord mit 2 
	INC $SPRITEX
	
checkleft:
	LDA #%01000000
	AND buttons
	BEQ checkdown
	
	DEC $SPRITEX
	
checkdown:
	LDA #%00100000
	AND buttons
	BEQ checkup
	
	INC $SPRITEY
	
checkup:
	LDA #%00010000
	AND buttons
	BEQ end
	
	DEC $SPRITEY
	
end:
	RTS
	
NMI:
	LDA #$02
	STA $4014
	JSR controller
	RTI	

palettedata:
	.byte $0F,$06,$15,$36,  $0F,$06,$15,$36,  $0F,$06,$15,$36,  $0F,$06,$15,$36  		;background palette data
	.byte $3F,$30,$21,$30,  $22,$1A,$30,$15,  $22,$16,$30,$27,  $22,$0F,$36,$17  			;sprite palette data
	
spritedata:
	.byte $AF, $01, $00, $00
	
	
.segment "VECTORS"
;**********************************************************************************************************************************
    .word NMI
    .word RESET

.segment "CHARS"
;**********************************************************************************************************************************
    .incbin "CHR.chr"
