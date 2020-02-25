#include<iostream>
#include<fstream>
#include<cstring>
#include <sstream>
#include <algorithm>
#include <filesystem>
#include "include/textprinter.h"
#include "include/voxelizer.h"

#define L_HEIGHT 19
#define L_WIDTH 10
#define MAX_LETTERS 10
#define BUF_SIZE 50

static std::string dict = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_Zabcdefghijklmnopqrstuvwxyz{|}^~";

void TextPrinter::display_text(std::string filename, std::string msg) {
    std::ifstream infile(filename + "char_map.bin", std::ios::in | std::ios::binary);
    if (msg.size() > BUF_SIZE) {
        msg.resize(BUF_SIZE);
    }
    int size = int(msg.size());
    char tab[L_HEIGHT][BUF_SIZE*L_WIDTH][3] = {};
    char buffer[L_WIDTH*3];
    memset(buffer, 0, sizeof(buffer));
    // construction of tab
    for (int l=0; l<int(msg.length()); l++) {
        int ind = int(dict.find(msg[(unsigned long)l]));
        for (int i=0; i<L_HEIGHT; i++) {
            // fetch the correct line of the correct letter
            int coef = ind*L_WIDTH*L_HEIGHT*3+i*L_WIDTH*3;
            infile.seekg(coef);
            infile.read(buffer, sizeof(buffer));
            int k = 0;
            for (int j = 0; j<int(sizeof(buffer)); j+=3) {
                tab[i][(l*L_WIDTH)+k][0] = buffer[j];
                tab[i][(l*L_WIDTH)+k][1] = buffer[j+1];
                tab[i][(l*L_WIDTH)+k][2] = buffer[j+2];
                k++;
            }
            infile.seekg(0, std::ios::beg);
        }
    }
    // static display
    if (size <= MAX_LETTERS) {
        FILE * myfile;
        std::string fname = filename + "text/out_1.ppm";
        myfile = fopen(fname.c_str(), "w");
        fprintf(myfile,"P3\n%d %d\n255\n", ANG_SUBDIVISIONS, NB_CIRCLES*NB_LEDS_VERTICAL);
        for (int i = 0; i<L_HEIGHT; i++) {
            for (int j = 0; j<L_WIDTH*size; j++) {
                fprintf(myfile, "%hhu %hhu %hhu\n", tab[i][j][0], tab[i][j][1], tab[i][j][2]);
            }
            // finish line
            for (int j = 0; j<ANG_SUBDIVISIONS-L_WIDTH*size; j++) {
                fprintf(myfile, "0 0 0\n");
            }
        }
        // finish the file
        for (int i = 0; i<NB_CIRCLES*NB_LEDS_VERTICAL-L_HEIGHT; i++) {
            for (int j = 0; j<ANG_SUBDIVISIONS; j++) {
                fprintf(myfile, "0 0 0\n");
            }
        }
        fclose(myfile);
    }
    // scrolling display
    else {
        int pix = 1; // number of pixels that have been displayed
        while (pix<L_WIDTH*size+MAX_LETTERS*L_WIDTH) {
            // open one file per value of pix
            FILE * myfile;
            std::string fname = filename + "text/out_" + std::to_string(pix) + ".ppm";
            myfile = fopen(fname.c_str(),"w");
            fprintf(myfile,"P3\n%d %d\n255\n", ANG_SUBDIVISIONS, NB_CIRCLES*NB_LEDS_VERTICAL);
            for (int i=0; i<L_HEIGHT; i++) {
                // blank before message
                for (int j=0; j<L_WIDTH*MAX_LETTERS-pix; j++) {
                    fprintf(myfile, "0 0 0\n");
                }
                // message
                for (int j=std::max(0,pix-L_WIDTH*MAX_LETTERS); j<std::min(pix, size*L_WIDTH); j++) {
                    fprintf(myfile, "%hhu %hhu %hhu\n", tab[i][j][0], tab[i][j][1], tab[i][j][2]);
                }
                // additionnal black pixels at the end of the message
                if (pix>L_WIDTH*size) {
                    for (int j = 0; j<pix-L_WIDTH*size; j++) {
                        fprintf(myfile, "0 0 0\n");
                    }
                }
                // finish the line
                for (int j =0; j<ANG_SUBDIVISIONS-L_WIDTH*MAX_LETTERS; j++) {
                    fprintf(myfile, "0 0 0\n");
                }
            }
            // finish the file
            for (int i = 0; i<NB_CIRCLES*NB_LEDS_VERTICAL-L_HEIGHT; i++) {
                for (int j = 0; j<ANG_SUBDIVISIONS; j++) {
                    fprintf(myfile, "0 0 0\n");
                }
            }
            pix ++;
            fclose(myfile);
        }
    }
}
