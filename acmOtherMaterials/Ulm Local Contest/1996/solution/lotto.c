/* University of Ulm Programming Contest 1996
   Problem F: Lotto
   Implementation: Mark Dettinger */

#include <stdio.h>

main()
{
  FILE* input = fopen("lotto.in","r");
  int number[15],k,i1,i2,i3,i4,i5,i6,kase=0;

  while (1)
    {
      fscanf(input,"%d",&k);
      if (k==0) break;
      for (i1=0; i1<k; i1++)
	fscanf(input,"%d",&number[i1]);
      if (kase++>0) printf("\n");
      for (i1=0; i1<k-5; i1++)
	for (i2=i1+1; i2<k-4; i2++)
	  for (i3=i2+1; i3<k-3; i3++)
	    for (i4=i3+1; i4<k-2; i4++)
	      for (i5=i4+1; i5<k-1; i5++)
		for (i6=i5+1; i6<k; i6++)
		  printf("%d %d %d %d %d %d\n",number[i1],number[i2],
			 number[i3],number[i4],number[i5],number[i6]);
    }
  fclose(input);
  return 0;
}

