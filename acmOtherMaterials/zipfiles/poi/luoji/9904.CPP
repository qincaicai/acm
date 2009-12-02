#include <stdio.h>
void main()
{
  long n, a[3], i, j, k;
  FILE *fin, *fout;

  fin = fopen("gra.in","rt");
  fout = fopen("gra.out","wt");

  fscanf(fin, "%ld", &n);
  for (i = 0; i < 3; i++) fscanf(fin, "%ld", &a[i]);
  for (i = 0; i < 3; i++)
    for (j = i+1; j < 3; j++)
      if (a[i] > a[j]) k = a[i], a[i] = a[j], a[j] = k;
  if (n % 2 == 0 || a[0]+2 == a[2] || (a[0] == 0 && a[1] == 1 && a[2] == n-1) ||
	(a[0] == 0 && a[1] == n-2 && a[2] == n-1))
    fprintf(fout, "TAK\n");
  else
    fprintf(fout, "NIE\n");

  fclose(fin);
  fclose(fout);
}