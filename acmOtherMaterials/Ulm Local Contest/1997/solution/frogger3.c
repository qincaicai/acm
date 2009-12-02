/* Contest    : Ulm Local Contest 1997 
 * Problem F  : Frogger 
 * Method     : Variant of Prim's (or Dijkstra's) Algorithm
 * Complexity : O(n^2)
 * Author     : Mark Dettinger
 * Date       : June 17, 1997
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>

#define WHITE 0
#define GRAY 1
#define BLACK 2
#define MIN(a,b) ((a)<(b)?(a):(b))
#define MAX(a,b) ((a)>(b)?(a):(b))
#define SQR(x) ((x)*(x))
#define MAXSTONES 500

FILE *input;
int scenario=0;
int n;
int x[MAXSTONES],y[MAXSTONES];
int color[MAXSTONES],d[MAXSTONES];

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
  int i,j;

  /* 1. initialize stones */

  for (i=0; i<n; i++)
    {
      color[i] = GRAY;
      d[i] = SQR(x[i]-x[0]) + SQR(y[i]-y[0]);
    }
  color[0] = BLACK;

  /* 2. algorithm */

  while (color[1]==GRAY)
    {
      /* Invariant:
       * for each black stone i:
       *   d[i] is the frog distance from 0 to i
       * for each gray stone i:
       *   d[i] is an upper bound for the frog distance from 0 to i */

      /* 2.1. search nearest gray stone */

      for (i=1; color[i]!=GRAY; i++);
      for (j=i+1; j<n; j++)
	if (color[j]==GRAY && d[j]<d[i]) i=j;

      /* 2.2. paint it black */

      color[i] = BLACK;

      /* 2.3. update distances */

      for (j=0; j<n; j++)
	if (color[j]==GRAY)
	  d[j] = MIN(d[j],MAX(d[i],SQR(x[i]-x[j])+SQR(y[i]-y[j])));
    }

  /* 3. output */

  printf("Scenario #%d\n",++scenario);	
  printf("Frog Distance = %.3f\n\n",sqrt((double)(d[1])));
}

int main()
{
  input = fopen("frogger.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
