/* Ulm Local Contest 1998
 * Problem H: Heavy Cargo
 * Author   : Mark Dettinger
 * Algorithm: Floyd-Warshall with MIN and MAX instead of + and MIN
 */

#include <stdio.h>
#include <string.h>
#include <assert.h>

#define MIN(a,b) ((a)<(b)?(a):(b))
#define MAX(a,b) ((a)>(b)?(a):(b))
#define MAXCITIES 256
#define oo 1000000000

FILE *input;
int kase=0;
int n,r;
int w[MAXCITIES][MAXCITIES];
char city[MAXCITIES][30];
char start[30],dest[30];
int numcities;

int index (char* s)
{
  int i;
  for (i=0; i<numcities; i++)
    if (!strcmp(city[i],s)) return i;
  strcpy(city[i],s);
  numcities++;
  return i;
}

int read_case()
{
  int i,j,k,limit;

  /* read number of cities and road segments */
  fscanf(input,"%d %d",&n,&r);
  if (n==0) return 0;

  /* initialize matrix */
  for (i=0; i<n; i++)
    for (j=0; j<n; j++)
      w[i][j] = 0;
  for (i=0; i<n; i++)
    w[i][i] = oo;
  
  /* read road network */
  numcities = 0;
  for (k=0; k<r; k++)
    {
      fscanf(input,"%s %s %d",start,dest,&limit);
      i = index(start);
      j = index(dest);
      w[i][j] = w[j][i] = limit;
    }

  /* read start and destination */
  fscanf(input,"%s %s",start,dest);
  return 1;
}  

void solve_case()
{
  int i,j,k;

  /* Floyd-Warshall */
  for (k=0; k<n; k++)
    for (i=0; i<n; i++)
      for (j=0; j<n; j++)
	w[i][j] = MAX(w[i][j],MIN(w[i][k],w[k][j]));

  /* output */
  i = index(start);
  j = index(dest);
  printf("Scenario #%d\n",++kase);
  printf("%d tons\n\n",w[i][j]);
}

int main()
{
  input = fopen("heavy.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
