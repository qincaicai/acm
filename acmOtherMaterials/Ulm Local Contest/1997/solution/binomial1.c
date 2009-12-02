/* Contest   : Ulm Local Contest 1997 
 * Problem B : Binomial Showdown
 * Method    : Perform divisions before multiplications
 * Author    : Mark Dettinger
 * Date      : June 3, 1997
 */

#include <stdio.h>
#include <assert.h>

FILE *input;

int n,k;

int gcd (int a, int b) { return b?gcd(b,a%b):a; }

int read_case()
{
  fscanf(input,"%d %d",&n,&k);
  if (n==0 && k==0) return 0;
  return 1;
}

void solve_case()
{
  int a[20];
  int i,j,d,g,res;

  if (k>n/2) k=n-k;
  assert(k<20);        /* bino(n,k)<2^31 && k<=n/2 => k<20 */
  for (i=0; i<k; i++)
    a[i] = n-i;
  for (j=2; j<=k; j++)
    for (i=0, d=j; d>1; i++)
      {
	g = gcd(a[i],d);
	a[i] /= g;
	d /= g;
      }
  for (i=0, res=1; i<k; res*=a[i++]);
  printf("%d\n",res);
}

int main()
{
  input = fopen("binomial.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
