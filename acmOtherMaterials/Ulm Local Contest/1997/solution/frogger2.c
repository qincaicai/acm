/* Contest    : Ulm Local Contest 1997 
 * Problem F  : Frogger 
 * Method     : Kruskal Algorithm
 * Complexity : O(n^2 log n)
 * Author     : Mark Dettinger
 * Date       : June 13, 1997
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>

#define MIN(a,b) ((a)<(b)?(a):(b))
#define MAX(a,b) ((a)>(b)?(a):(b))
#define SQR(x) ((x)*(x))
#define MAXSTONES 500

typedef struct { int u,v,w; } edge;

FILE *input;
int scenario=0;
int n;
int x[MAXSTONES],y[MAXSTONES];
edge e[MAXSTONES*MAXSTONES];

/* ----- Data Structures and Algorithms for Disjoint Sets ------------------------- */

int rank[MAXSTONES],p[MAXSTONES];

void make_set (int x)
{
  p[x] = x;
  rank[x] = 0;
}

int find_set (int x)
{
  if (x!=p[x])
    p[x] = find_set(p[x]);
  return p[x];
}

void link (int x, int y)
{
  if (rank[x]>rank[y])
    {
      p[y] = x;
    }
  else
    {
      p[x] = y;
      if (rank[x]==rank[y]) rank[y]++;
    }
}

int same_set (int x, int y)
{
  return find_set(x)==find_set(y);
}

void union_sets (int x, int y)
{
  if (!same_set(x,y)) link(find_set(x),find_set(y));
}

/* -------------------------------------------------------------------------------- */

int edgecmp (const void* a, const void* b)
{
  return ((edge*)a)->w - ((edge*)b)->w;
}

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

  /* 1. construct edges for all pairs of stones */

  k = 0;
  for (i=0; i<n; i++)
    for (j=i+1; j<n; j++)
      {
	e[k].u = i;
	e[k].v = j;
	e[k].w = SQR(x[i]-x[j])+SQR(y[i]-y[j]);
	k++;
      }

  /* 2. sort edges by length */

  qsort(e,k,sizeof(edge),edgecmp);

  /* 3. generate a forest of one tree per stone */

  for (i=0; i<n; i++)
    make_set(i);

  /* 4. while Freddy and Fiona are not in the same tree, add an edge to the forest */

  for (i=0; !same_set(0,1); i++)
    union_sets(e[i].u,e[i].v);
  
  /* 5. output */

  printf("Scenario #%d\n",++scenario);	
  printf("Frog Distance = %.3f\n\n",sqrt((double)(e[i-1].w)));
}

int main()
{
  input = fopen("frogger.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
