animation:
    lda animation_count 
    cmp animation_hold                          ;vergleiche ob animtion erlaubt ist 
    bne @end                                                  
    lda animation_speed                         ;nächten vergleichspunkt für animations-is-valid test vorbereiten
    clc 
    adc animation_hold
    sta animation_hold
    @animate: 
    lda tile_count                              
    cmp #MAX_TILES                              ;wenn 4 animationsframes durchlaufen sind, dann reset 4 -> 0
    bne :+
    lda #$00  
    sta tile_count
    : 
    clc                                         ;aktuellen animations frame auf tile index addieren (=animaitonsframes durchlaufen)
    adc animation_tile  
    sta p_tile
    inc tile_count                              ;animationsframestatus inkrementieren für nächsten animationsframe  
    @end:
    inc animation_count                         ;zeit für obrigen vergleich inkremtierne
    rts 