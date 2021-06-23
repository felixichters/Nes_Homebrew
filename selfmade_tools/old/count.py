x = 0
i = 1
while i < 64:
    print ("SPRITE_"+ str(i) + "_Y = $0200 +" + str(x))
    x+=1
    print ("SPRITE_"+ str(i) + "_TILE = $0200 +" + str(x))
    x+=1
    print ("SPRITE_"+ str(i) + "_ATTR = $0200 +" + str(x))
    x+=1
    print ("SPRITE_"+ str(i) + "_X = $0200 +" + str(x))
    x+=1
    i+=1