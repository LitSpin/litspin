from PIL import Image, ImageDraw, ImageFont

# credits: Alexis Polti
def load_font():
    im = Image.open("data/Sinclair_S.png")
    chars = chars = """ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_§abcdefghijklmnopqrstuvwxyz{|}~"""
    char_map = {}
    w, h = im.size
    for i, c in enumerate(chars):
        xmin = (i*8)%w
        xmax = xmin+8
        ymin = ((i*8)//w)*8
        ymax = ymin+8
        # Get subimage
        char_map[c] = im.crop((xmin, ymin, xmax, ymax))
    return char_map

def build_ppm(char):
    # size max : 16 (128/8)
    out = Image.new(mode = "RGB", size = (128,32*20), color = 0)
    for i, c in enumerate(char):
        im = char_map[c]
        w, h = im.size
        #print("i: " + str(i))
        for j in range(h):
            for k in range(w):
                #print(im.getpixel((j,k)))
                #sprint("j: " + str(j) + " k: " + str(k))
                if (im.getpixel((j,k))!=(0,0,0)):
                    out.putpixel((i*8+j,k),(255,255,255))
    out.save("out.png");


char_map = load_font()
build_ppm("LitSpinnnn")
