/* University of Ulm Programming Contest 1996
   Problem B: The Tower of Babylon
   Implementation: Mark Dettinger
   Alternative Solution */

#include <stdio.h>

#define oo 1000000000
#define max(a,b) ((a)>(b)?(a):(b))

int x[1000],y[1000],z[1000],d[1000][1000];

main()
{
  FILE* input = fopen("babylon.in","r");
  int a,b,c,i,j,k,n,numblocks,top,bottom,kase=0;

  while (1)
    {
      /* 1. Read input */

      fscanf(input,"%d",&numblocks);
      if (numblocks==0) break;
      n = 0;
      for (i=0; i<numblocks; i++)
	{
	  fscanf(input,"%d %d %d",&a,&b,&c);
	  if (a<b) {x[n] = a; y[n] = b; z[n++] = c;}
	  else     {x[n] = b; y[n] = a; z[n++] = c;}
	  if (a<c) {x[n] = a; y[n] = c; z[n++] = b;}
	  else     {x[n] = c; y[n] = a; z[n++] = b;}
	  if (b<c) {x[n] = b; y[n] = c; z[n++] = a;}
	  else     {x[n] = c; y[n] = b; z[n++] = a;}
	}

      /* 2. Construct graph */

      for (i=0; i<n; i++)
	for (j=0; j<n; j++)
	  if (x[i]<x[j] && y[i]<y[j]) d[i][j] = z[i];
	  else                        d[i][j] = -oo;
      top = n;
      bottom = n+1;
      for (i=0; i<n; i++)
	{
	  d[i][top]    = -oo;
	  d[top][i]    = 0;
	  d[i][bottom] = z[i];
	  d[bottom][i] = -oo;
	}
      d[top][bottom] = -oo;
      d[bottom][top] = -oo;
      n += 2;
	
      /* 3. Find longest path from top to bottom */

      for (k=0; k<n; k++)
	for (i=0; i<n; i++)
	  for (j=0; j<n; j++)
	    d[i][j] = max(d[i][j],d[i][k]+d[k][j]);

      /* 4. Output result */
      
      printf("Case %d: maximum height = %d\n",++kase,d[top][bottom]);
    }
  fclose(input);
  return 0;
}

      
