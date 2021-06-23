@echo off
echo MAKEFILE
SET /P name=[enter the name of the file]

echo build... %name%
echo makefile...
echo ;------------------------------------------------------------------- >%name%.asm
echo ;NES ASM Project: %name% >>%name%.asm
echo ;Generated at %date% %time% >>%name%.asm
echo ;------------------------------------------------------------------- >>%name%.asm 
echo init----------HEADER
echo .segment "HEADER" >>%name%.asm
echo 	.BYTE "NES", $1A>>%name%.asm
echo	.BYTE $02         							; 1 or 2 for NROM-128 or NROM-256 respectively>>%name%.asm
echo	.BYTE $01         							; 8 KiB CHR ROM>>%name%.asm
echo	.BYTE $00       							; Mapper 0; $00 or $01 for horizontal or veRTIcal mirroring respectively>>%name%.asm
echo	.BYTE $08       							; Mapper 0; NES 2.0>>%name%.asm
echo	.BYTE $00      				   				; No submapper>>%name%.asm
echo	.BYTE $00       							; PRG ROM not 4 MiB or larger>>%name%.asm
echo	.BYTE $00     								; No PRG RAM>>%name%.asm
echo	.BYTE $00     								; No CHR RAM>>%name%.asm
echo	.BYTE $01     								; 0 or 1 for NTSC or PAL respectively>>%name%.asm
echo	.BYTE $00     								; No special PPU>>%name%.asm
echo init----------ZEROPAGE
echo .segment "ZEROPAGE">>%name%.asm
echo init----------CODE
echo .segment "CODE">>%name%.asm
echo 	RESET:>>%name%.asm
echo		SEI 									;setze interrupt-flag>>%name%.asm
echo		CLD 									;dezimal ausschalten>>%name%.asm
echo		LDA #$40								;64dec laden>>%name%.asm
echo		STA $4017								;nach 4017 (frame counter control(APU)) speichern>>%name%.asm
echo		LDX #$FF								;x = FF >>%name%.asm
echo		TXS										;x auf STAck>>%name%.asm
echo		INX										;x->00>>%name%.asm
echo		STX $2000								;PPUCTRL alles auf 0 (NMI usw. ausschalten)>>%name%.asm
echo		STX $2001								;PPUMASK ales auf 0 (background und sprite sausschalten)>>%name%.asm
echo		STX $4010								;IRQ ausschalten (APU)>>%name%.asm
echo		JSR wait_vblank							;warte auf veRTIcal blank>>%name%.asm
echo		TXA										;schreibe 00 in accumulator>>%name%.asm
echo	clearmemory:>>%name%.asm
echo		STA $0000, X 							; $0000 => $00FF (1byte)>>%name%.asm
echo		STA $0100, X 							; $0100 => $01FF>>%name%.asm
echo		STA $0300, X							;...>>%name%.asm
echo		STA $0400, X							;...>>%name%.asm
echo		STA $0500, X							;...>>%name%.asm
echo		STA $0600, X							;...>>%name%.asm
echo		STA $0700, X							;...>>%name%.asm
echo		LDA #$FF								;...>>%name%.asm
echo		STA $0200, X 							; $0200 => $02FF>>%name%.asm
echo		LDA #$00								;...>>%name%.asm
echo		INX										;...>>%name%.asm
echo		BNE clearmemory>>%name%.asm
echo		LDX #$00>>%name%.asm
echo		JSR wait_vblank							;warte auf veRTIcal blank>>%name%.asm
echo		LDA #$02		>>%name%.asm						
echo		STA $4014>>%name%.asm
echo		NOP	>>%name%.asm
echo	NMI:>>%name%.asm
echo		@save_registers:						>>%name%.asm
echo			PHA 								;Push Accumulator auf den STAck>>%name%.asm					
echo			TXA 								;Transfer X nahc A>>%name%.asm
echo			PHA									;Push X auf den STAck>>%name%.asm
echo			TYA									;Transfer Y nach A >>%name%.asm
echo			PHA									;Push Y auf den STAck>>%name%.asm
echo		@get_registers:>>%name%.asm
echo			PLA 								;hole Y von STAck>>%name%.asm
echo			TAY									;Spichere Y>>%name%.asm
echo			PLA									;hole X von STAck>>%name%.asm
echo			TAX									;Speichere X>>%name%.asm
echo			PLA									;hole A von STAck>>%name%.asm
echo			RTI									;interrupt ende >>%name%.asm
echo	wait_vblank:>>%name%.asm
echo		BIT $2002								;prüfen ob V-Blank aktiv ist>>%name%.asm
echo		BPL wait_vblank							;wenn nicht dann warten>>%name%.asm
echo		RTS										;return>>%name%.asm
echo init----------VECTORS
echo .segment "VECTORS">>%name%.asm
echo 	.word NMI									;V-Blank interrupt>>%name%.asm
echo 	.word RESET 								;Reset interrupt>>%name%.asm
echo init----------CHARS
echo .segment "CHARS">>%name%.asm
echo ;------------------------------------------------------------------- >>%name%.asm
Start %name%.asm
pause 
exit