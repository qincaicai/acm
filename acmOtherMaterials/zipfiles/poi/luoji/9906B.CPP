/* POI 99 Stage 2 GRO */
/* flow */
#include <stdio.h>
#include <math.h>
#include <alloc.h>
long far *map[201];
long far *flow[201];
long n, maxflow;
long fa[201], data[201];
FILE *fin, *fout;

void init()
{
  long i, j, k, h;

  fin = fopen("gro.in","rt");
  fscanf(fin, "%ld", &n);

  for (i = 1; i <= n; i++)
  {
    map[i] = (long far *) farcalloc(n+1,sizeof(long));
    flow[i] = (long far *) farcalloc(n+1,sizeof(long));
    for (j = 1; j <= n; *(map[i]+j) = 0, *(flow[i]+j) = 0, j++);
  }

  for (i = 1; i < n; i++)
  {
    fscanf(fin, "%ld", &j);
    for (k = 0; k < j; k++)
    {
      fscanf(fin, "%ld", &h);
      if (i != 1 && i != n && h != 1 && h != n)
	*(map[i]+h) = n;
      else
	*(map[i]+h) = 1;
    }
  }
  fclose(fin);
}

long min(long a, long b)
{
  if (a < b) return a;
  return b;
}

void find()
{
  long i, best, j;
  long use[201];

  for (i = 1; i <= n; use[i] = 0, data[i] = 0, i++);
  data[1] = n;
  while (1 == 1)
  {
    for (best = 0, i = 1; i <= n; i++)
      if (use[i] == 0 && (best == 0 || data[best] < data[i])) best = i;
    if (best == 0) break;
    use[best] = 1;
    for (i = 1; i <= n; i++)
    {
      j = min(*(map[best]+i)-*(flow[best]+i),data[best]);
      if (j > data[i]) data[i] = j, fa[i] = best;
      j = min(*(flow[i]+best),data[best]);
      if (j > data[i]) data[i] = j, fa[i] = -best;
    }
  }
}

void update()
{
  long i, j, a;
  i = n; a = data[n]; maxflow += a;
  while (i != 1)
  {
    j = fa[i];
    if (j > 0) *(flow[j]+i) += a;
    if (j < 0) *(flow[i]-j) -= a;
    i = labs(j);
  }
}

void work()
{
  maxflow = 0;
  find();
  while (data[n] > 0)
  {
    update();
    find();
  }
}

void print()
{
  fout = fopen("gro.out","wt");
  fprintf(fout, "%ld\n", maxflow);
  fclose(fout);
}

void main()
{
  init();
  work();
  print();
}