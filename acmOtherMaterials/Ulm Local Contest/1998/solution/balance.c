/* University of Ulm Local Contest 1998
 * Problem B: Balancing Bank Accounts
 * Author: Mark Dettinger
 */

#include <stdio.h>
#include <assert.h>

#define MIN(a,b) ((a)<(b)?(a):(b))
#define DBG(x)

FILE *input;
int kase=0;
int n,t;
int account[32];
char name[32][32];

int read_case()
{
  int i,j,k,amount;
  char name1[30],name2[30];

  fscanf(input,"%d %d",&n,&t);
  if (n==0 && t==0) return 0;
  for (i=0; i<n; i++)
    {
      fscanf(input,"%s",name[i]);
      account[i] = 0;
    }
  for (k=0; k<t; k++)
    {
      fscanf(input,"%s %s %d\n",name1,name2,&amount);
      for (i=0; strcmp(name1,name[i]); i++);
      for (j=0; strcmp(name2,name[j]); j++);
      account[i] -= amount;
      account[j] += amount;
    }
  return 1;
}

void solve_case()
{
  int src,dst,transfer;

  printf("Case #%d\n",++kase);
  DBG(printf("%d people, %d transactions\n",n,t));
  while (1)
    {
      for (src=0; src<n; src++)
	if (account[src]>0) break; /* person who has to pay found */
      for (dst=0; dst<n; dst++)
	if (account[dst]<0) break; /* person who receives money found */
      if (src==n || dst==n) break;
      transfer = MIN(account[src],-account[dst]);
      account[src] -= transfer;
      account[dst] += transfer;
      printf("%s %s %d\n",name[src],name[dst],transfer);
    }
  printf("\n");
}

int main()
{
  input = fopen("balance.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
