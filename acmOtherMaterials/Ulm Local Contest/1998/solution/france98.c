/* University of Ulm Local Contest 1998
 * Problem F: France '98
 * Author   : Mark Dettinger
 * Algorithm: Dynamic Programming
 */

/* 0
 *     17
 * 1 
 *          24
 * 2
 *     17
 * 3
 *               28
 * 4
 *     18
 * 5
 *          25
 * 6
 *     19
 * 7
 *                    30
 * 8
 *     20
 * 9
 *          26
 * 10
 *     21
 * 11
 *               29
 * 12
 *     22
 * 13
 *          27
 * 14  
 *     23
 * 15

 * There are 31 nodes (numbered 0 to 30) in the "tournament flow graph".
 * At each node, in ascending order, we compute the vector of probabilities for this node.
 * The vectors at nodes 0-15 are the unit vectors for the single countries.
 * From vector 0 and 1 we compute vector 16, from vector 2 and 3 we compute vector 17,...
 * Vector 30 is the thing we are looking for. 
 */

#include <stdio.h>
#include <assert.h>

FILE *input;
char name[16][100];
double p[16][16],pos[32][16];

void play (int a, int b, int c)
{
  int i,j;

  for (i=0; i<16; i++)
    pos[c][i] = 0.0;
  for (i=0; i<16; i++)
    for (j=0; j<16; j++)
      {
	pos[c][i] += pos[a][i]*pos[b][j]*p[i][j];
	pos[c][j] += pos[a][i]*pos[b][j]*p[j][i];
      }
  /*  
  printf("Position #%d\n",c);
  for (i=0; i<16; i++)
    printf("%-10s %.2f\n",name[i],pos[c][i]);
  printf("\n"); 
  */
}

int main()
{
  int i,j;

  input = fopen("france98.in","r");
  assert(input!=NULL);

  /* read countries */
  for (i=0; i<16; i++)
    fscanf(input,"%s",name[i]);

  /* read matrix */
  for (i=0; i<16; i++)
    {
      for (j=0; j<16; j++)
	{
	  fscanf(input,"%lf",&p[i][j]);
	  p[i][j] /= 100.0;
	  pos[i][j] = 0.0;
	}
      pos[i][i] = 1.0;
    }
  
  /* eigth finals */
  play(0,1,16);
  play(2,3,17);
  play(4,5,18);
  play(6,7,19);
  play(8,9,20);
  play(10,11,21);
  play(12,13,22);
  play(14,15,23);

  /* quarter finals */
  play(16,17,24);
  play(18,19,25);
  play(20,21,26);
  play(22,23,27);

  /* semi-finals */
  play(24,25,28);
  play(26,27,29);

  /* finals */
  play(28,29,30);

  /* output */
  for (i=0; i<16; i++)
    printf("%-10s p=%.2f%%\n",name[i],100.0*pos[30][i]);

  fclose(input);
  return 0;
}
