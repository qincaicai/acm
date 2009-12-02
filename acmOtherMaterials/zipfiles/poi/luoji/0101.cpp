/* POI VIII Stage 1 Problem 1 */
#include <stdio.h>
#include <mem.h>

FILE *fin, *fout;
int n, r;
long map[250][250];
long tot[250][250];

void init()
{
  int i, j;

  memset(map,0,sizeof(map));
  fin = fopen("MAP.IN","rt");
  fscanf(fin, "%d %d", &n, &r);
  for (i = 1; i <= n; i++)
    for (j = 1; j <= n; j++)
      fscanf(fin, "%ld", &map[i][j]);
  fclose(fin);
}

void work()
{
  long i, j, k;
  memset(tot,0,sizeof(tot));
  for (i = 1; i <= n; i++)
    {
      k = 0;
      for (j = 1; j <= n; j++)
      {
        k += map[i][j];
        tot[i][j] = k+tot[i-1][j];
      }
    }
}

void print()
{
  long i, j, minx, miny, maxx, maxy;

  fout = fopen("MAP.OUT","wt");
  for (i = 1; i <= n; i++)
  {
    for (j = 1; j <= n; j++)
    {
      minx = i-r; maxx = i+r;
      miny = j-r; maxy = j+r;
      if (minx < 1) minx = 1;
      if (maxx > n) maxx = n;
      if (miny < 1) miny = 1;
      if (maxy > n) maxy = n;
      fprintf(fout, "%ld ", tot[maxx][maxy]-(tot[minx-1][maxy]-tot[minx-1][miny-1]+tot[maxx][miny-1]));
    }
    fprintf(fout, "\n");
  }
  fclose(fout);
}

void main()
{
  init();
  work();
  print();
}
