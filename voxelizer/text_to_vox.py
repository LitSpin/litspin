from PIL import Image, ImageDraw, ImageFont

HEIGHT = 19
WIDTH = 10

# credits: Alexis Polti
def load_font():
    fout = open("char_map.bin", "wb")
    im = Image.open("LitSpin.png")
    out = bytearray(0)
    chars = chars = """ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_Zabcdefghijklmnopqrstuvwxyz{|}^~"""
    char_map = {}
    w, h = im.size
    print("w: " + str(w) + " h: " + str(h))
    for i, c in enumerate(chars):
        print("i: " + str(i) + " char: " + c)
        #out.append(ord(c))
        xmin = (i%16)*WIDTH
        xmax = xmin+WIDTH
        ymin = (i//16)*HEIGHT
        ymax = ymin+HEIGHT
        if (c=="§"):
            print("truc bizarre: " + str(ord("§")))
            out_test = im.crop((xmin, ymin, xmax, ymax))
            out_test.save("out_test.png")
        test = im.crop((xmin, ymin, xmax, ymax))
        # Get subimage
        char_map[c] = im.crop((xmin, ymin, xmax, ymax))
        w, h = test.size
        for j in range(h):
            for k in range(w):
                r, g, b = test.getpixel((k,j))
                if c == "!":
                    print("r: " + str(r) + " g: " + str(g) + " b: " + str(b))
                out.append(r)
                out.append(g)
                out.append(b)
    fout.write(out)
    fout.close()
    return char_map

def build_ppm(char):
    # size max : 16 (128/8)
    out = Image.new(mode = "RGB", size = (128,32*20), color = 0)
    for i, c in enumerate(char):
        im = char_map[c]
        w, h = im.size
        print("lettre, w: " + str(w) + " h: " + str(h))
        #print("i: " + str(i))
        for j in range(h):
            for k in range(w):
                print("j :" + str(j) + "k :" + str(k));
                print(im.getpixel((k,j)))
                if (im.getpixel((k,j))==(0,0,0)):
                    out.putpixel((i*10+k,j),(255,255,255))
    out.save("out.png");


char_map = load_font()
#build_ppm("LitSpinnnn")
