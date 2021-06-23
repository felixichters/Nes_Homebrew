;Sprites************************************************

;Sprite 1
SPRITE_1_Y      = $0200
SPRITE_1_TILE   = $0201
SPRITE_1_ATTR   = $0202
SPRITE_1_X      = $0203
;Sprite 2
SPRITE_2_Y      = $0204
SPRITE_2_TILE   = $0205
SPRITE_2_ATTR   = $0206
SPRITE_2_X      = $0207
;Sprite 3
SPRITE_3_Y      = $0208
SPRITE_3_TILE   = $0209
SPRITE_3_ATTR   = $020A
SPRITE_3_X      = $020B
;Sprite 4 
SPRITE_4_Y      = $020C
SPRITE_4_TILE   = $020D 
SPRITE_4_ATTR   = $020E 
SPRITE_4_X      = $020F 
;.
;.
;.

;PPU******************************************************
PPU_CTRL        = $2000
PPU_MASK        = $2001
PPU_STATUS      = $2002
PPU_OAMADDR     = $2003
PPU_OAMDATA     = $2004
PPU_SCROLL      = $2005
PPU_ADDR        = $2006
PPU_DATA        = $2007
PPU_OAMDMA      = $4014

;Controller*************************************************
P1_POLL         = $4016
P2_INPUT        = $4017
;Button Status
BUTTON_A        = %10000000
BUTTON_B        = %01000000
BUTTON_SELECT   = %00100000
BUTTON_START    = %00010000
BUTTON_UP       = %00001000
BUTTON_DOWN     = %00000100
BUTTON_LEFT     = %00000010
BUTTON_RIGHT    = %00000001