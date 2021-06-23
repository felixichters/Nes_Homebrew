try:
    addr = int(input("Input hexadecimal value: "), 16)
    print(addr)
    print(hex(addr))
except ValueError:
    print("not a hex number!!!")