/* Problem C: Quadtree    */
/* Author: Mark Dettinger */

#include <stdio.h>
#include <assert.h>

#define MAX_N 1024

FILE *input;
int n;
unsigned char xbm[MAX_N][MAX_N/8];

void quadtree (int top, int left, int size)
{
  switch (fgetc(input))
    {
    case 'W':
      for (int i=top; i<top+size; i++)
	for (int j=left; j<left+size; j++)
	  xbm[i][j/8] &= ~(1 << (j%8));
      break;
    case 'B':
      for (int i=top; i<top+size; i++)
	for (int j=left; j<left+size; j++)
	  xbm[i][j/8] |= 1 << (j%8);
      break;
    case 'Q':
      quadtree(top,left,size/2);
      quadtree(top,left+size/2,size/2);
      quadtree(top+size/2,left,size/2);
      quadtree(top+size/2,left+size/2,size/2);
    }
}

int main()
{
  input = fopen("quadtree.in","r");
  assert(input!=NULL);
  fscanf(input,"%d ",&n);
  quadtree(0,0,n);
  printf("#define quadtree_width %d\n",n);
  printf("#define quadtree_height %d\n",n);
  printf("static char quadtree_bits[] = {\n");
  for (int i=0; i<n; i++)
    {
      for (int j=0; j<n/8; j++)
	printf("0x%02x,",xbm[i][j]);
      printf("\n");
    }
  printf("};\n");
  fclose(input);
  return 0;
}
