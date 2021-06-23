debug:                  .res 1;tmp**************************
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
frame_counter:          .res 1;global**********************
frame_status:           .res 1  
width_room:             .res 1;Background*******************
ground_texture:         .res 1
height_room:            .res 1
ppu_addr_low:           .res 1
ppu_addr_high:          .res 1
line_counter:           .res 1
col_counter:            .res 1
current_y:              .res 1;doors***********************
room_backup_p1:         .res 1
room_backup_p2:         .res 1
room_ptr:               .res 2;pointer*********************

palette_ptr:            .res 2

attribute_ptr:          .res 2 

sprite_ptr:             .res 2

doors_ptr_x:            .res 2 

doors_ptr_y:            .res 2

collision_ptr:          .res 2 

enemy_ptr:              .res 2 

enemy_hi_ptr:           .res 2 

enemy_lo_ptr:           .res 2

enemy_room_ptr:         .res 2

addr_ptr:               .res 2

animation_ptr:          .res 2 

every_frame_ptr:        .res 2 

every_frame_jmp_ptr:    .res 2 
buttons1:               .res 1 ;player attributes p1 **********************
animation_count_p1:     .res 1
animation_hold_p1:      .res 1
tile_count_p1:          .res 1
acc_x_p1:               .res 1
acc_y_p1:               .res 1
acc_count_x_p1:         .res 1
acc_hold_x_p1:          .res 1
current_room_p1:        .res 1
status_bits_p1:         .res 1
buttons2:               .res 1 ;player attributes p2 **********************
animation_count_p2:     .res 1
animation_hold_p2:      .res 1
tile_count_p2:          .res 1
acc_x_p2:               .res 1
acc_y_p2:               .res 1
acc_count_x_p2:         .res 1
acc_hold_x_p2:          .res 1
current_room_p2:        .res 1
status_bits_p2:         .res 1
buttons:                .res 1;input_handling*****************************
animation_count:        .res 1
animation_hold:         .res 1
tile_count:             .res 1 
acc_x:                  .res 1
acc_y:                  .res 1
acc_count_x:            .res 1
acc_hold_x:             .res 1 
current_room:           .res 1 
status_bits:            .res 1;************
default_tile:           .res 1
animation_tile:         .res 1
full_acc_x:             .res 1
acc_speed_x:            .res 1
p_attr:                 .res 1 
p_tile:                 .res 1
p_y:                    .res 1
p_x:                    .res 1
animation_speed:        .res 1
full_speed_x:           .res 1
full_acc_y:             .res 1
speed_y:                .res 1
speed_x:                .res 1
jmp_strength:           .res 1
collectable_room:       .res 1;collectable********************
current_room_e1:        .res 1;enemy1*************************
animation_count_e1:     .res 1
animation_hold_e1:      .res 1
tile_count_e1:          .res 1
animation_count_e1fx:   .res 1
animation_hold_e1fx:    .res 1
tile_count_e1xf:        .res 1
acc_x_e1:               .res 1
acc_y_e1:               .res 1
status_e1:              .res 1
current_room_e2:        .res 1;enemy2*************************
animation_count_e2:     .res 1
animation_hold_e2:      .res 1
tile_count_e2:          .res 1
animation_count_e2fx:   .res 1
animation_hold_e2fx:    .res 1
tile_count_e2xf:        .res 1
acc_x_e2:               .res 1
acc_y_e2:               .res 1
status_e2:              .res 1
current_room_e3:        .res 1;enemy3*************************
animation_count_e3:     .res 1
animation_hold_e3:      .res 1
tile_count_e3:          .res 1
animation_count_e3fx:   .res 1
animation_hold_e3fx:    .res 1
tile_count_e3xf:        .res 1
acc_x_e3:               .res 1
acc_y_e3:               .res 1
status_e3:              .res 1
current_room_e4:        .res 1;enemy4*************************
animation_count_e4:     .res 1
animation_hold_e4:      .res 1
tile_count_e4:          .res 1
animation_count_e4fx:   .res 1
animation_hold_e4fx:    .res 1
tile_count_e4xf:        .res 1
acc_x_e4:               .res 1
acc_y_e4:               .res 1
status_e4:              .res 1
input_lock1:            .res 1
input_lock2:            .res 1
animation_count_c:      .res 1
animation_hold_c:       .res 1
tile_count_c:           .res 1
collectable_tile:       .res 1



















current_room_et:        .res 1;enemys*************************
animation_count_et:     .res 1
animation_hold_et:      .res 1
tile_count_et:          .res 1 
et_acc_x:               .res 1
et_acc_y:               .res 1
animation_count_et_fx:  .res 1
animation_hold_et_fx:   .res 1
tile_count_et_fx:       .res 1 
current_room_spr:       .res 1;enemys*************************
animation_count_spr:    .res 1
animation_hold_spr:     .res 1
tile_count_spr:         .res 1 