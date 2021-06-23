y = int(input("y coord: "))
x = int(input("x coord: "))
addr = int(((y/8)*32)+x/8)
print(hex(addr))