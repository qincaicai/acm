/* Problem   Code
** Algorithm Euler Tour (Depth First Search)
** Runtime   O(10^(n+1))
** Author    Walter Guttmann
** Date      2000.07.13
*/

#include <assert.h>
#include <stdio.h>

int edge[100000][10], nstates;
char out[1048576], *outp;

void dfs(int q)
{
  int i;
  /* We are in state q and press the key i. */
  for (i=0 ; i<10 ; i++)
    if (edge[q][i])
    {
      edge[q][i] = 0;
      dfs((q * 10 + i) % nstates);
      *--outp = '0' + i;
    }
}

int main()
{
  FILE *in = fopen("code.in", "r");
  while (1)
  {
    int i, n, q;
    fscanf(in, " %d ", &n);
    if (n == 0) break;
    assert(1 <= n && n <= 6);
    /* There are 10^(n-1) states. */
    nstates = 1;
    for (i=1 ; i<n ; i++)
      nstates *= 10;
    /* From every state, by pressing a key, one of 10 states is reachable. */
    for (q=0 ; q<nstates ; q++)
      for (i=0 ; i<10 ; i++)
        edge[q][i] = 1;
    /* We always start with pressing the 0 key n-1 times. */
    for (i=1 ; i<n ; i++)
      printf("0");
    /* Produce an Euler tour in reverse order and output it. */
    *(outp = out + nstates*10) = 0;
    dfs(0);
    assert(outp == out);
    printf("%s\n", out);
  }
  return 0;
}

