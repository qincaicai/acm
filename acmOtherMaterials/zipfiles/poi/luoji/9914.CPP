/* POI 99 Stage 3 PIE */
#include <stdio.h>
#include <mem.h>
FILE *fin, *fout;
int fa[1001], tot[1001], degree[1001];
long ans;

int findfa(int i)
{
  int way[1001];
  int len, j;

  len = 0;
  while (i != fa[i])
    {
      i = fa[i];
      way[len++] = i;
    }
  for (j = 0; j < len; fa[way[j]] = i, j++);
  return i;
}

void join(int i, int j)
{
  int fai, faj;
  fai = findfa(i);
  faj = findfa(j);
  if (fai == faj) return;
  if (tot[fai] > tot[faj])
    fa[faj] = fai, tot[fai] += tot[faj];
  else
    fa[fai] = faj, tot[faj] += tot[fai];
}

void init()
{
  long i, j, k;
  long n;

  memset(fa,0,sizeof(fa));
  memset(degree,0,sizeof(degree));
  fin = fopen("pie.in","rt");
  fscanf(fin, "%ld", &n);
  for (i = 0; i < n; i++)
    {
      fscanf(fin, "%ld %ld", &j, &k);
      if (fa[j] == 0) fa[j] = j, tot[j] = 1;
      if (fa[k] == 0) fa[k] = k, tot[k] = 1;
      join(j,k);
      degree[j]--;
      degree[k]++;
    }
  fclose(fin);

  ans = n;
}

void print()
{
  fout = fopen("pie.out","wt");
  fprintf(fout, "%ld\n", ans);
  fclose(fout);
}

void work()
{
  int i, j;
  int need[1001];

  memset(need,0,sizeof(need));
  for (i = 1; i <= 1000; i++)
    if (fa[i] != 0 && degree[i] > 0)
    {
      j = findfa(i);
      need[j] += degree[i];
    }
  for (i = 1; i <= 1000; i++)
    if (fa[i] == i)
    {
      if (need[i] == 0) ans++;
      else ans += need[i];
    }
}

void main()
{
  init();
  work();
  print();
}