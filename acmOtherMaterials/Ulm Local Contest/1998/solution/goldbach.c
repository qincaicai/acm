/* University of Ulm Local Contest 1998
 * Problem G: Goldbach's Conjecture
 * Author   : Mark Dettinger
 * Algorithm: Precomputation of Prime Table with Sieve of Eratosthenes
 */

#include <stdio.h>
#include <assert.h>

FILE *input;
int n;
int p[1000010];

void compute_prime_table() /* with Sieve of Eratosthenes */
{
  int i,j;

  p[0] = p[1] = 0;
  for (i=2; i<=1000000; i++) p[i]=1; /* initialization */
  for (i=2; i<=1000;) /* for all primes up to 1000 */
    {
      for (j=i+i; j<=1000000; j+=i) p[j]=0; /* delete all multiples of i */
      for (i++; !p[i]; i++); /* find next prime */ 
    }
}

int read_case()
{
  fscanf(input,"%d",&n);
  if (n==0) return 0;
  return 1;
}

void solve_case()
{
  int i,j;

  for (i=3, j=n-3; i<=j; i++,j--)
    if (p[i] && p[j]) break;
  printf("%d = %d + %d\n",n,i,j);
}

int main()
{
  input = fopen("goldbach.in","r");
  assert(input!=NULL);
  compute_prime_table();
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
