/* University of Ulm Programming Contest 1996
   Problem E: Eeny Meeny Moo
   Implementation: Mark Dettinger */

#include <stdio.h>

int n;          /* number of cities */
int next[200];  /* ring for josephus problem */

int suitable (int m)  /* returns whether m is a suitable choice or not */
{
  int i,p;

  for (i=1; i<n; i++)  /* construct ring */
    next[i] = i+1;
  next[n] = 1;
  p = n;  
  while (next[p]!=p)   /* do while there is more than one city remaining */
    {
      if (next[p]==2) return 0;
      next[p] = next[next[p]];   /* cut off city next[p] */
      for (i=0; i<m-1; i++)      /* count m cities forward */
	p = next[p];
    }
  return next[2]==2;   /* return true if and only if Ulm is remaining */
}

main()
{
  FILE* input = fopen("eenymeeny.in","r");
  int m;
 
  while (1)
    {
      fscanf(input,"%d",&n);         /* read n */
      if (n==0) break;
      for (m=2; !suitable(m); m++);  /* search for smallest suitable m */
      printf("%d\n",m);              /* print m  */
    }
  fclose(input);
  return 0;
}

