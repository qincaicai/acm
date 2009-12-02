/* University of Ulm Local Contest 1998
 * Problem C : The Settlers of Catan
 * Author    : Mark Dettinger
 * Algorithm : Backtracking 
 */

#include <stdio.h>
#include <assert.h>

#define DBG(x)

FILE *input;
int n,m,best;
int a[32][32];

int read_case()
{
  int i,j;

  /* read number of nodes and edges */
  fscanf(input,"%d %d",&n,&m);
  DBG(printf("%d nodes, %d edges\n",n,m));
  if (m==0 && n==0) return 0;
  /* initialize adjacency matrix */
  for (i=0; i<n; i++)
    for (j=0; j<n; j++)
      a[i][j] = 0;
  /* read edges */
  while (m--)
    {
      fscanf(input,"%d %d",&i,&j);
      a[i][j] = a[j][i] = 1;
    }
  return 1;
}

void visit (int i, int l)
{
  int j;

  /* try to walk another edge */
  for (j=0; j<n; j++)
    if (a[i][j])
      {
	a[i][j] = a[j][i] = 0;
	visit(j,l+1);
	a[i][j] = a[j][i] = 1;
      }
  /* look how far you have gone */
  if (l>best) best=l;
}

void solve_case()
{
  int i;

  best = 0;
  for (i=0; i<n; i++)
    visit(i,0);
  printf("%d\n",best);
}

int main()
{
  input = fopen("catan.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
