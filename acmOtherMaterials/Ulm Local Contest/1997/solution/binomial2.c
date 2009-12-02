/* Contest   : Ulm Local Contest 1997 
 * Problem B : Binomial Showdown
 * Method    : Pascal's Triangle
 * Author    : Mark Dettinger
 * Date      : June 3, 1997
 */

#include <stdio.h>
#include <assert.h>

FILE *input;

int n,k;
int bino[100000][20];

void init()  /* compute table with Pascal's Triangle */
{
  bino[0][0] = 1;
  for (k=1; k<20; k++)
    bino[0][k] = 0;
  for (n=1; n<100000; n++)
    {
      bino[n][0] = 1;
      for (k=1; k<20; k++)
	bino[n][k] = bino[n-1][k-1]+bino[n-1][k];
    }
}

int read_case()
{
  fscanf(input,"%d %d",&n,&k);
  if (n==0 && k==0) return 0;
  return 1;
}

void solve_case()
{
  if (k>n/2) k=n-k;
  assert(k<20);        /* bino(n,k)<2^31 && k<=n/2 => k<20 */
  if (k==0)
    printf("1\n");
  else if (k==1)
    printf("%d\n",n);
  else
    printf("%d\n",bino[n][k]);
}

int main()
{
  input = fopen("binomial.in","r");
  assert(input!=NULL);
  init();
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
