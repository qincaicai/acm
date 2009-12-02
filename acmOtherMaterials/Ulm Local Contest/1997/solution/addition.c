/* Contest   : Ulm Local Contest 1997 
 * Problem A : Addition Chains
 * Method    : Backtracking
 * Author    : Mark Dettinger
 * Date      : June 22, 1997
 */

#include <stdio.h>
#include <assert.h>

#define oo 1000000000

FILE *input;

int n,best;
int a[100];   /* current addition chain */
int b[100];   /* best addition chain so far */
int d[1000];

int read_case()
{
  fscanf(input,"%d",&n);
  if (n==0) return 0;
  return 1;
}

void visit (int k)
{
  int i,j;

  /* if the current partial solution cannot be extended
   * to a new optimal solution, then give it up */

  if (k+d[a[k]]>=best) return;

  /* if you are finished, save the solution and quit */

  if (a[k]==n)
    {
      best = k;
      for (i=0; i<=k; i++) b[i]=a[i];
      return;
    }

  /* otherwise try to extend the current partial solution */

  for (i=k; i>=0; i--)
    for (j=k; j>=i; j--)
      {
	a[k+1] = a[i]+a[j];
	if (a[k+1]>a[k] && a[k+1]<=n) visit(k+1);
      }
}

void solve_case()
{
  int i;

  /* for each i
   *   compute a lower bound d[i] for the
   *   number of necessary steps from i to n */

  for (i=n+n; i>=n; i--) d[i]=0;
  for (i=n-1; i>=1; i--) d[i]=1+d[i+i];

  /* find solution by backtracking */

  best = oo;
  a[0] = 1;
  visit(0);

  /* output solution */

  for (i=0; i<best; i++)
    printf("%d ",b[i]);
  printf("%d\n",b[best]);
}

int main()
{
  input = fopen("addition.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
