;titel bildschirm vorbereiten 
;auf user input start warten
FIRST_SCREEN:
:
    BIT $2002
    BPL :-
jsr read_controller
lda #BUTTON_START
and buttons1
beq :-
run_game:
    cli 
    lda #%10001000
    sta PPU_CTRL