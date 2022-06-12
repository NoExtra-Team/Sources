/*************************************************************************************
 * CUT_PI1.C
 * 
 * Progam to cut Degas Low Resolution file to Raw file in 4 bitplanes
 *
 * [c] 2022 NoExtra-Team
 *************************************************************************************
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int cut_file(const char *infile, const char *outfile, long Y1, long Y2);
void printHelp(char *prgName);

int main(int argc, char** argv)
{
    int ret = EXIT_FAILURE;
    int posy1 = atoi(argv[3]);
    int posy2 = atoi(argv[4]);

    if ( argc < 5 ) { // 4 arguments et s'il manque un argument ?
        printHelp(argv[0]);
        exit(ret) ;
    }

    if ( ( posy1 >= 0 && posy1 <= 200 ) && ( posy2 >= 0 && posy2 <= 200) ) // il y a des valeurs alors on y va !
        ret = cut_file( argv[1], argv[2], posy1, posy2 );

    return ret;
}

int cut_file(const char *infile, const char *outfile, long Y1, long Y2)
{
    FILE *INFILE = fopen(infile, "rb");
    if (INFILE == NULL) {
        perror(infile);
        exit(EXIT_FAILURE);
    }

    FILE *OUTFILE = fopen(outfile, "wb");
    if (OUTFILE == NULL) {
        perror(outfile);
        exit(EXIT_FAILURE);
    }

    fseek(INFILE, 0, SEEK_END);
    long size = ftell(INFILE);

    printf(">>> Degas filename : %s\n",infile);
    printf(">>> Size : %li bytes.\n", size);

    long size32k = Y2*160-Y1*160;
    void *buffer = malloc(size32k);

    fseek(INFILE, 2+32 + Y1*160, SEEK_SET);
    fread(buffer, 1, size32k, INFILE);
    fwrite(buffer, 1, size32k, OUTFILE);
    fclose(INFILE);

    fseek(OUTFILE, 0, SEEK_END);
    size = ftell(OUTFILE);
    fclose(OUTFILE);

    printf(">>> Binary filename : %s\n",outfile);
    printf(">>> Size : %li bytes.\n", size);

    return EXIT_SUCCESS;
}

void printHelp(char *prgName)
{
    printf("> %s\n", prgName);
    printf("> Cut Degas picture file Low Resolution to binary file.\n");
    printf("> with position Y1 and Y2 with X=0 of start and end of the sprite to crop. (Value between 0 .. 200)\n");
    printf("> Usage:\n");
    printf("> cut_pi1.exe <fileName.PI1> <fileName.IMG> <StartPosition> <EndPosition>\n");
}