/* Solution: FASTFOOD */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define MAX_STORES 200
#define MAX_DEPOTS 30

FILE *inp;

int pos[MAX_STORES];
int best[MAX_DEPOTS][MAX_STORES+1];
short back[MAX_DEPOTS][MAX_STORES+1];
int cost[MAX_STORES][MAX_STORES+1];
int k,n;

int caseno = 1;

/* cost[a][b] will hold for all a < b the distance sum
   coming from an interval containing the restaurants
   a,a+1,...,b-1 */

void compute_cost()
{
  int i,j,l,med,err;

  for(i=0;i<n;i++)
    for(j=i+1;j<=n;j++)
      {
	/* the median is always the best position */
	med = pos[i+(j-i)/2];
	err = 0;
	for(l=i;l<j;l++)
	  err += abs(pos[l] - med);
	cost[i][j] = err;
      }
}

/* We use a sort of dynamic programming to solve the problem */
/* - best[a][b] holds the best distance sum possible for the
     sub-problem where a+1 depots are distributed on the first b
     restaurants
   - back[a][b] is used to reconstruct the solution
   - in the end, best[k-1][n] will hold the solution to our problem
*/

void solve_case()
{
  int i,j,b,first,last;
  int sol[MAX_DEPOTS];

  compute_cost();

  for(j=1;j<=n;j++)
    {
      best[0][j] = cost[0][j];
      back[0][j] = 0;
    }
  for(i=1;i<k;i++)
    for(j=1;j<=n;j++)
      {
	best[i][j] = 9999999;
	for(b=i;b<j;b++)
	  if(cost[b][j]+best[i-1][b] < best[i][j])
	    {
	      best[i][j] = cost[b][j] + best[i-1][b];
	      back[i][j] = b;
	    }
      }
  for(i=k-1,j=n;i>=0;j=back[i--][j]) sol[i] = back[i][j];

  printf("Chain %d\n",caseno++);
  for(i=0;i<k;i++)
    {
      first = sol[i];
      last = i!=k-1?sol[i+1]-1:n-1;
      printf("Depot %d at restaurant %d serves restaurant",
	     i+1,first+(last-first+1)/2+1);
      if(first == last)
	printf(" %d\n",first+1);
      else
	printf("s %d to %d\n",first+1,last+1);
	}
  printf("Total distance sum = %d\n\n",best[k-1][n]);
}

/* read in data, etc. */

void skip_line() { while(getc(inp) >= ' '); }

int read_case()
{
  int i;

  fscanf(inp,"%d %d",&n,&k);
  if(n == 0) return 0;
  skip_line();
  for(i=0;i<n;i++)
    fscanf(inp,"%d",pos+i);
  return 1;
}

int main()
{
  inp = fopen("fastfood.in","r");
   freopen("fastfood.out","w", stdout);
  while(read_case()) solve_case();
  fclose(inp);
  return 0;
}
