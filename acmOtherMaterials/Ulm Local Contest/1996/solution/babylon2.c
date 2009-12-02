/* University of Ulm Programming Contest 1996
   Problem B      : Babylon
   Implementation : Mark Dettinger */

#include <stdio.h>
#include <stdlib.h>

#define max(a,b) ((a)>(b)?(a):(b))

typedef struct {int x; int y; int z;} block;

block b[1200];  /* array to store the dimensions of the blocks */
int h[1200];    /* h[i] = height of the tallest tower with block i on top */

int blockcmp (const void* a, const void* b)  /* comparison function for block sort */
{
  return ((block*)b)->x - ((block*)a)->x;
}

main()
{
  FILE* input = fopen("babylon.in","r");
  int i,j,n,x,y,z,height;
  int set = 0;            /* number of completed test cases */

  while (1)
    {
      /* 1. Read Input */

      fscanf(input,"%d",&n);
      if (n==0) break;
      for (i=0; i<n; i++)
	{
	  fscanf(input,"%d %d %d",&x,&y,&z);
	  b[6*i].x   = x; b[6*i].y   = y; b[6*i].z   = z;
	  b[6*i+1].x = x; b[6*i+1].y = z; b[6*i+1].z = y;
	  b[6*i+2].x = y; b[6*i+2].y = x; b[6*i+2].z = z;
	  b[6*i+3].x = y; b[6*i+3].y = z; b[6*i+3].z = x;
	  b[6*i+4].x = z; b[6*i+4].y = x; b[6*i+4].z = y;
	  b[6*i+5].x = z; b[6*i+5].y = y; b[6*i+5].z = x;
	}

      /* 2. Sort blocks by descending width */

      qsort(b,6*n,sizeof(block),blockcmp);
      
      /* 3. Successively compute h[0], h[1], h[2],..., h[6*n-1] */

      h[0] = b[0].z;
      for (i=1; i<6*n; i++)
	{
	  height = 0;
	  for (j=0; j<i; j++)
	    if (b[j].x>b[i].x && b[j].y>b[i].y && h[j]>height)
	      height = h[j];
	  h[i] = height+b[i].z;
	}

      /* 4. Now the desired result is the maximum value in array h */

      height = h[0];
      for (i=1; i<6*n; i++) 
	height = max(height,h[i]);
      printf("Case %d: maximum height = %d\n",++set,height);
    }
  fclose(input);
  return 0;
}





