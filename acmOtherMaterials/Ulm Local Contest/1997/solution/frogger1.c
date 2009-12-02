/* Contest    : Ulm Local Contest 1997 
 * Problem F  : Frogger 
 * Method     : Floyd-Warshall with MAX instead of +
 * Complexity : O(n^3)
 * Author     : Mark Dettinger
 * Date       : June 13, 1997
 */

#include <stdio.h>
#include <math.h>
#include <assert.h>

#define MIN(a,b) ((a)<(b)?(a):(b))
#define MAX(a,b) ((a)>(b)?(a):(b))
#define SQR(x) ((x)*(x))
#define MAXSTONES 500

FILE *input;
int scenario=0;
int n;
int w[MAXSTONES][MAXSTONES];
int x[MAXSTONES],y[MAXSTONES];

int read_case()
{
  int i;

  fscanf(input,"%d",&n);
  if (n==0) return 0;
  for (i=0; i<n; i++)
    fscanf(input,"%d %d",&x[i],&y[i]);
  return 1;
}

void solve_case()
{
  int i,j,k;

  /* set up distance matrix */

  for (i=0; i<n; i++)
    for (j=0; j<n; j++)
      w[i][j] = SQR(x[i]-x[j])+SQR(y[i]-y[j]);

  /* Floyd-Warshall */

  for (k=0; k<n; k++)
    for (i=0; i<n; i++)
      for (j=0; j<n; j++)
	w[i][j] = MIN(w[i][j],MAX(w[i][k],w[k][j]));
	
  /* output */

  printf("Scenario #%d\n",++scenario);	
  printf("Frog Distance = %.3f\n\n",sqrt((double)(w[0][1])));
}

int main()
{
  input = fopen("frogger.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
