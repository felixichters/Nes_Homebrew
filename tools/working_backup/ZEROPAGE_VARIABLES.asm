;tmp
debug:                  .res 1
tmp:                    .res 1
tmp1:                   .res 1
tmp2:                   .res 1
tmp3:                   .res 1
tmp4:                   .res 1
tmp5:                   .res 1
tmp6:                   .res 1
tmp7:                   .res 1
tmp8:                   .res 1
tmp9:                   .res 1

;global
frame_counter:          .res 1
frame:                  .res 1

;butons
buttons1:               .res 1
buttons2:               .res 1

;Background
width_room:             .res 1
height_room:            .res 1
ppu_addr_low:           .res 1
ppu_addr_high:          .res 1
line_counter:           .res 1
col_counter:            .res 1

;doors
current_y:              .res 1
current_room_p1:        .res 1 

;pointer
room_ptr:               .res 2
sprite_ptr:             .res 2
doors_ptr_x:            .res 2 
doors_ptr_y:            .res 2
collision_ptr:          .res 2 
enemy_ptr:              .res 2 
enemy_hi_ptr:           .res 2 
enemy_lo_ptr:           .res 2
enemy_room_ptr:         .res 2
addr_ptr:               .res 2

;sprites
tile_count_right_p1:    .res 1
tile_count_left_p1:     .res 1
input_right_p1:         .res 1 
input_left_p1:          .res 1
p1_x:                   .res 1
p1_y:                   .res 1
p2_x:                   .res 1
p2_y:                   .res 1

;enemys 
enemy_addr:             .res 1 
