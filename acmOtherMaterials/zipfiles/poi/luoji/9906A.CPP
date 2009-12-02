/* POI 99 Stage 2 GRO */
/* match */
#include <stdio.h>
#include <mem.h>
char map[201][201];
char x[201], y[201], op[201], tmpx[201], tmpy[201];
FILE *fin, *fout;
int n, total;

void init()
{
  int i, j, k, h;

  fin = fopen("gro.in","rt");
  fscanf(fin, "%d", &n);
  memset(map,0,sizeof(map));
  memset(x,0,sizeof(x));
  memset(y,0,sizeof(y));
  for (i = 1; i < n; i++)
  {
    fscanf(fin, "%d", &j);
    for (k = 0; k < j; k++)
    {
      fscanf(fin, "%d", &h);
      if (i == 1 && h != n) x[h] = 1;
      if (h == n && i != 1) y[i] = 1;
      map[i][h] = 1;
    }
  }
  total = (map[1][n] == 1) ? 1 : 0;
  fclose(fin);
}

int path(int a)
{
  int i;

  if (tmpx[a] == 0) return 0;
  tmpx[a] = 0;
  for (i = 1; i <= n; i++)
    if (map[a][i] == 1 && tmpy[i] == 1)
    {
      tmpy[i] = 0;
      if (y[i] == 1)
      {
	y[i] = 0;
	op[i] = a;
	return 1;
      }
      if (path(op[i]) > 0)
      {
	op[i] = a;
	return 1;
      }
    }
  return 0;
}

void work()
{
  int i, j, k, ok;

  for (i = 1; i <= n; map[i][i] = 1, i++);
  for (k = 1; k <= n; k++)
    for (i = 1; i <= n; i++)
      if (map[i][k] == 1)
      for (j = 1; j <= n; j++)
	if (map[k][j] == 1) map[i][j] = 1;
  ok =1;
  while (ok == 1)
  {
    ok = 0;
    for (i = 1; i <= n; i++)
      if (x[i] == 1)
      {
	memset(tmpx,1,sizeof(tmpx));
	memset(tmpy,1,sizeof(tmpy));
	if (path(i) > 0)
	{
	  total++; ok = 1;
	  x[i] = 0;
	}
      }
  }
}

void print()
{
  fout = fopen("gro.out","wt");
  fprintf(fout, "%d\n", total);
  fclose(fout);
}

void main()
{
  init();
  work();
  print();
}