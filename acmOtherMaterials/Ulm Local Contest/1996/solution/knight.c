/* University of Ulm Programming Contest 1996
   Problem D:      Knight Moves
   Implementation: Mark Dettinger */

#include <stdio.h>

#define oo 1000000000

int d[8][8][8][8];      /* distance matrix */
int startrow,startcol;  /* starting square */
int destrow,destcol;    /* destination square */

void visit (int row, int col, int moves)
{
  if (row<0 || row>7 || col<0 || col>7 || 
      moves>=d[startrow][startcol][row][col]) return;
  d[startrow][startcol][row][col] = moves;
  visit(row-2,col-1,moves+1);
  visit(row-2,col+1,moves+1);
  visit(row+2,col-1,moves+1);
  visit(row+2,col+1,moves+1);
  visit(row-1,col-2,moves+1);
  visit(row-1,col+2,moves+1);
  visit(row+1,col-2,moves+1);
  visit(row+1,col+2,moves+1);
}

int main()
{
  FILE* input = fopen("knight.in","r");
  char a[3],b[3];
  int i,j,k,l;

  for (i=0; i<8; i++)
    for (j=0; j<8; j++)
      for (k=0; k<8; k++)
	for (l=0; l<8; l++)
	  d[i][j][k][l] = oo;
  while (1)
    {
      fscanf(input,"%s %s",a,b);
      if (feof(input)) break;
      startcol = a[0]-'a';
      startrow = a[1]-'1';
      destcol = b[0]-'a';
      destrow = b[1]-'1';
      visit(startrow,startcol,0);
      printf("To get from %s to %s takes %d knight moves.\n",
	     a,b,d[startrow][startcol][destrow][destcol]);
    }
  fclose(input);
  return 0;
}

