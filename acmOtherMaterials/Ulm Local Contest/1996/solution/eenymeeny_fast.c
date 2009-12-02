/* University of Ulm Programming Contest 1996
   Problem E: Eeny Meeny Moo
   Fast algorithm by Falk Bartels */

#include <stdio.h>

int n,m;

int suitable (int m)
{
  int cities,p;
  
  cities = n-1;
  p = (m-1)%cities;
  while (cities>1)
    {
      if (p==0) return 0;
      cities--;
      p = (p+m-1)%cities;
    }
  return 1;
}

main()
{
  FILE* input = fopen("eenymeeny.in","r");

  while (1)
    {
      fscanf(input,"%d",&n);
      if (n==0) break;
      for (m=2; !suitable(m); m++);
      printf("%d\n",m);
    }
  fclose(input);
  return 0;
}
