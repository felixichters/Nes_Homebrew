.segment "HEADER"
  .byte "NES", $1A
  .byte 2         						; 1 or 2 for NROM-128 or NROM-256 respectively
  .byte 1         						; 8 KiB CHR ROM
  .byte $00       						; Mapper 0; $00 or $01 for horizontal or vertical mirroring respectively
  .byte $08       						; Mapper 0; NES 2.0
  .byte $00      				   		; No submapper
  .byte $00       						; PRG ROM not 4 MiB or larger
  .byte $00     						; No PRG RAM
  .byte $00     						; No CHR RAM
  .byte $00     						; 0 or 1 for NTSC or PAL respectively
  .byte $00     						; No special PPU
 
.segment "ZEROPAGE"
;**********************************************************************************************************************************
	buttons: .res 1 				;1 byte resevieren für buttonstatus
	attribute: .res 1				;Attribute byte zum shiften
	nt_pointer: .res 2 				;2 bytes zum nametable inkrementieren
	
	
	
.segment "STARTUP"
;**********************************************************************************************************************************
.segment "CODE"
;**********************************************************************************************************************************
RESET:
    SEI 							;interrupts aussschalten
	CLD 							;dezimal asuschalten
	
									;sound interrupt ausschalten
	LDX #$40							
	STX $4017						;frame interrupt ausschalten (APU)
	
									;init Stack
	LDX #$FF
	TXS								;FF auf den Stack
	INX								;FF -> 00
	
									;PPU zurücksetzen
	STX $2000						;PPUCTRL alles auf 0 (NMI usw. ausschalten
	STX $2001						;PPUMASK ales auf 0 (background und sprite sausschalten)
	
	STX $4010						;IRQ ausschalten (APU)
	
:									;wait VBlank
    BIT $2002						;bit test 2002 (vblank)
    BPL :-							;wenn bittest negativ dann warten (eine subroutine nach oben)

    TXA								;schreibe 00 in accumulator

CLEARMEM:
    STA $0000, X 					; $0000 => $00FF (1byte)
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
	
	;*******************************************************************
	LDA #<nt_0						;low byte
	sta nt_pointer
	lda #>nt_0						;high byte
	sta nt_pointer+1
	
	lda #$20
	STA $2006
	LDA #$00
	STA $2006
	
	
	ldx #$00
	ldy #$00
	jmp backgroundconfig
;---------------------------------------------------------------------------------------------------------------------------------------
nt_count:
	inc nt_pointer+1
	rts
backgroundconfig_1:
	
	
	LDA(nt_pointer),y
	STA $2007
	iny
	cpy #$00
	beq nt_count
	lda (nt_pointer),y
	sta $2007
	
	iny
	cpy #$00
	beq nt_count
	iny
	cpy #$00
	beq nt_count
	iny
	cpy #$00
	beq nt_count
	
	cpy #$40
	bne backgroundconfig_1
	
	inx
	cpx #$02
	beq backgroundconfig_1
	
	TYA
	SEC
	sbc #$4E
	tay
	
	jmp backgroundconfig_1
	
	lda nt_pointer,y
	sta $2007
	iny 
	lda nt_pointer,y
	
;-------------------------------------------
;	lda nt_counter
;	sta $2006
;	lda nt_counter+1
;	sta $2006
;	.out "guten tag"
;	lda nt_pointer
;	sta $2007
;	LDA (nt_pointer),y
;	sta $2007
;	lda nt_pointer
;	sta $2007
;	lda nt_pointer
;	sec
;	sbc #$20
;	sta nt_pointer
;	sta $2007
	
;	lda nt_pointer
;	sta $2007
;	
;	inc nt_counter
;	
;	LDX nt_counter
;	cpx #$00
;	beq position_count
;	
;	ldx nt_counter+1
;	cpx #$03
;	bne backgroundconfig

;---------------------------------------------------------------------------------------------------------------------------------------------
attributeconfig:
	LDA #$23
	STA $2006
	LDA #$C0
	LDX #$00

loadattribute:
	LDA mt_0_att
	STA $2007
	INX 
	CPX #$10
	
	BNE loadattribute
	

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
	
	LDA #$00
	STA $2005
	STA $2005
	
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
	LDA $0203
	CLC
	ADC #$02
	STA $0203
	
checkleft:
	LDA #%01000000
	AND buttons
	BEQ checkdown
	
	LDA $0203
	SEC
	SBC #$02
	STA $0203
	
checkdown:
	LDA #%00100000
	AND buttons
	BEQ checkup
	
	LDA $0200
	CLC
	ADC #$02
	STA $0200
	
checkup:
	LDA #%00010000
	AND buttons
	BEQ end
	
	LDA $0200
	SEC
	SBC #$02
	STA $0200
	
end:
	RTS
	
NMI:
	LDA #$02
	STA $4014
	JSR controller
	RTI	
;********************************************************************************************************************************


palettedata:
	.byte $0F,$06,$15,$36,  $0F,$06,$15,$36,  $0F,$06,$15,$36,  $0F,$06,$15,$36  						;background palette data
	.byte $3F,$23,$23,$23,$22,$1A,$30,$15,$22,$16,$30,$27,$22,$0F,$36,$17  							;sprite palette data
	
mt_0: 
																	    						;anlegen der Metatiles
	.byte  $01, $02, $03, $04,																;5bytes...4bytes tileinformation 1byte Palette
mt_1:																							;links oben, rechts oben, links unten, rechts unten , Palette
	.byte  $11, $12, $13, $14
mt_2: 
	.byte  $21, $22, $23, $24
mt_3: 
	.byte  $31, $32, $33, $34

mt_0_att:
	
	.byte %00000000
nt_0:
																													;auswahl der metattiles
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0
	.addr mt_0, mt_2, mt_0, mt_1, mt_3,mt_0, mt_2, mt_0, mt_1, mt_3, mt_0, mt_2, mt_0, mt_1, mt_3, mt_0

	
spritedata:
	.byte $AF, $01, $00, $00
.segment "VECTORS"
		
;**********************************************************************************************************************************
    .word NMI
    .word RESET

.segment "CHARS"
;**********************************************************************************************************************************
    .incbin "MicroMages.chr"
