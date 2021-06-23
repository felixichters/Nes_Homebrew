MS_pointer: .res 2						;Metasprite_pointer
sprite_1_trigger: .res 1				;trigger byte (00000000 = stehen 00000001 = links 00000010 = rechts 00000100 = sprung) 
frame_counter: .res 1					;zählt jeden Frame hoch 
frame_counter_buffer: .res 1			;für controller funktion
buttons: .res 1							;button data
tmp: .res 1								;temporärer speicher
metasprite_counter: .res 1				;für controlelr engine
tile_counter: .res 1					;"