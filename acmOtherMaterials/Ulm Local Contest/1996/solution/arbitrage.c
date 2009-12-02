/* University of Ulm Programming Contest 1996
   Problem A: Arbitrage
   Implementation: Mark Dettinger */

#include <stdio.h>
#include <string.h>

#define max(a,b) ((a)>(b)?(a):(b))

main()
{
  FILE* input = fopen("arbitrage.in","r");
  char name[50][20],a[20],b[20];
  double r[50][50],x;
  register int i,j,k;
  int n,edges,kase=0;

  while (1)
    {
      fscanf(input,"%d",&n);              /* 1. Read currency names */
      if (n==0) break;
      for (i=0; i<n; i++)
	fscanf(input,"%s",name[i]);
      for (i=0; i<n; i++)                 /* 2. Initialize exchange table */
	for (j=0; j<n; j++)
	  r[i][j] = 0.0;
      fscanf(input,"%d",&edges);          /* 3. Read exchange rates into table */
      for (i=0; i<edges; i++)
	{
	  fscanf(input,"%s %lf %s",a,&x,b);
	  for (j=0; strcmp(a,name[j]); j++);
	  for (k=0; strcmp(b,name[k]); k++);
	  r[j][k] = x;
	}
      for (i=0; i<n; i++)                 /* 4. Compute "transitive hull" */
	r[i][i] = max(1.0,r[i][i]);       /*    of exchange table         */
      for (k=0; k<n; k++)
	for (i=0; i<n; i++)
	  for (j=0; j<n; j++)
	    r[i][j] = max(r[i][j],r[i][k]*r[k][j]);
      for (i=0; i<n; i++)                 /* 5. Search main diagonal */
	if (r[i][i]>1.0) break;           /*    for a value > 1      */
      if (i<n)                            /* 6. Print answer */
	printf("Case %d: Yes\n",++kase);
      else
	printf("Case %d: No\n",++kase);
    }
  fclose(input);
  return 0;
}
