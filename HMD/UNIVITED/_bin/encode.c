/*************************************************************************************
 * ENCODE.C
 * 
 * Progam to encode text to Hexa
 *
 * [c] 2022 NoExtra-Team
 *************************************************************************************
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

void printHelp (char *prgName);
int load_file ( char *filename );
void code_file ( void );
int save_file ( char *filename );
void free_mem ( void );

#define FALSE 0
#define TRUE 1

char* input_file;
char* output_file;
int range = 0;

//extern char	*malloc ();
typedef unsigned char Byte;
Byte *data;
char letters[]=" !\"#$\%&'()*+,-./0123456789:; = ?@ABCDEFGHIJKLMNOPQRSTUVWXYZ \\ ^_ abcdefghijklmnopqrstuvwxyz\0";
char *text = letters;
int	fsize = 0;

int main ( int argc, char** argv )
{
    int statut = EXIT_FAILURE;

	if ( argc < 4 ) // Il faut 4 arguments !
	{
		printHelp (argv[0]);
		exit(statut);
	} else {
		input_file  = argv[1];
		output_file = argv[2];
		range = atoi(argv[3]);
	}

	printf(">> Open text file %s \n", input_file);
	load_file( input_file );
	printf(">> Encoded text file %s \n", input_file);
	code_file();
	printf(">> Save hexa file encoded %s \n", output_file);
	save_file( output_file );
	free_mem();

	return EXIT_SUCCESS;
}

void printHelp (char *prgName)
{
	printf("> Convert text file to hexa file\n");
	printf("> Usage:\n");
	printf("> %s <input file> <output file> <range>\n", prgName);
}

int load_file ( char *filename )
{
	FILE *fd;
    int statut = EXIT_FAILURE;

	if ( ( fd = fopen (filename, "rb") ) == NULL ) {
		fprintf(stderr, ">>> Cannot open the file %s!\n", filename);
		exit(statut);
	} // if
	fseek(fd, 0L, 2);
	fsize=(int) ftell (fd);
	rewind(fd);
	text=(char *) malloc (fsize);
	data=(Byte *) malloc (fsize);
	if ( (text == NULL) || (data == NULL) ) {
		fprintf (stderr, ">>> Not enough memory!!!\n");
		exit(statut);
	} // if
	fread(text, fsize, 1, fd);
	fclose(fd);

	return EXIT_SUCCESS;
}

void code_file ( void )
{
	int l_ptr, letter, found, d_ptr=0, loop;

	for ( loop=0 ; loop < fsize ; loop++ ) {
		letter=text[loop];
		found=FALSE;
		l_ptr=0;
		while ( ( letters[l_ptr] != NULL ) && ( found == FALSE  ) )
		{
			if ( letters[l_ptr] == letter )
				found=TRUE;
			else
				l_ptr++;
		} // while
		if ( found ) {
			data[d_ptr]=(Byte)l_ptr+range;	//	+32 to see... mandatory!
			d_ptr++;
		} else {
			if ( (letter != 0x0d) && (letter != 0x0a) )
				printf (">>> Character <%c> not found  at number [%d]\n", letter, loop);
		} // if
	} // for

	fsize=d_ptr;
}

int save_file ( char *filename )
{
	FILE *fd;
    int statut = EXIT_FAILURE;

	if ( ( fd=fopen (filename, "wb") ) == NULL ) {
		fprintf (stderr, ">>> Cannot create the file %s!\n", filename);
		exit(statut);
	} // if
	fwrite ((char *)data, fsize, 1, fd);
	fputc (0xff, fd);
	fclose (fd);

	return EXIT_SUCCESS;
}

void free_mem ( void )
{
	free( text );
	free( (char *) data );
}
