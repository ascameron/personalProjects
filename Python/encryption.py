
# ascameron
# block cypher encryption originally written in java
# key: xFFF44FF00F444004


# main function
def main():
    # get the message they want encrypted
    plaintext = bytes(input('Enter message to encrypt: '), 'utf-8')
    # add to dictionary
    plain_bytes = {i: plaintext[i] for i in range(0, len(plaintext))}
    # send the dict of bytes to the encrypt function
    encrypted = encrypt(plain_bytes)
    print('encrypted message: ', end ="")
    for i in encrypted:
        print(chr(encrypted[i]), end="")


# function to encrypt the user message
def encrypt(message):
    # create byte dict of the key
    key = {0: 0xff, 1: 0xf4, 2: 0x4f, 3: 0xf0, 4: 0x0f, 5: 0x44, 6: 0x40, 7: 0x04}
    # create iteration variables
    x = len(message)
    n = (len(message) % 8)
    index = int(x / 8)
    ind, i, j, k, m = 0, 0, 0, 0, 0
    zero = bytes('00', 'utf-8')
    # new dictionary to store encrypted message
    encrypted = dict.fromkeys(range(x + (8 - n)))
    # begin encryption
    while i < index:
        while j < 8:
            encrypted[ind] = message[ind] ^ key[j]
            ind += 1
            j += 1
        i += 1
    ind1 = ind  # hold position
    # pad with zeros
    while k < (8-n):
        encrypted[ind] = int(zero) ^ key[k]
        ind += 1
        k += 1
    # finish encryption after padding
    while m < n:
        encrypted[ind] = message[ind1] ^ key[m]
        ind += 1
        ind1 += 1
        m += 1
    return encrypted


main()