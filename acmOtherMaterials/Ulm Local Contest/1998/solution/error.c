/* University of Ulm Local Contest 1998
 * Problem E: Error Correction
 * Author   : Mark Dettinger
 */

#include <stdio.h>
#include <assert.h>

#define MAXN 512

int n;
int a[MAXN][MAXN], row[MAXN], col[MAXN];

FILE *input;

int read_case()
{
  int i,j;

  fscanf(input,"%d",&n);
  if (n==0) return 0;
  for (i=0; i<n; i++)
    for (j=0; j<n; j++)
      fscanf(input,"%d",&a[i][j]);
  return 1;
}

void solve_case()
{
  int cc,cr,i,j,k;

  for (i=0; i<n; i++)
    row[i] = col[i] = 0;
  for (i=0; i<n; i++)
    for (j=0; j<n; j++)
      {
	row[i] += a[i][j];
	col[j] += a[i][j];
      }
  cr = cc = 0;
  for (k=0; k<n; k++)
    {
      if (row[k]&1) { cr++; i=k; }
      if (col[k]&1) { cc++; j=k; }
    }
  if      (cc==0 && cr==0) printf("OK\n");
  else if (cc==1 && cr==1) printf("Change bit (%d,%d)\n",i+1,j+1);
  else                     printf("Corrupt\n");
}

int main()
{
  input = fopen("error.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
