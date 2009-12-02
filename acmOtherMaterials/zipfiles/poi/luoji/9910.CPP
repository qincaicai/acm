/* POI 99 Stage 3 TRO */
#include <stdio.h>
#include <alloc.h>
char s[10001];
int son[10001][2];
int far *min[3];
int far *max[3];
int p, tot, minans, maxans;
FILE *fin, *fout;

void build()
{
  int node[10001], mark[10001];
  int step, p;
  step = 0; p = 0;
  node[0] = 0; mark[0] = -1;
  while (step >= 0)
  {
    if (mark[step] == -1)
    {
      mark[step] = s[p]-'0';
      p++;
      continue;
    }
    if (mark[step] == 0) {step--; continue;}
    if (mark[step] > 0)
    {
      tot++;
      mark[step]--;
      son[node[step]][mark[step]] = tot;
      node[++step] = tot;
      mark[step] = -1;
      continue;
    }
  }
}

void work(int now)
{
  int i, j, k, h;

  if (son[now][0] == -1)
  {
    *(min[0]+now) = *(max[0]+now) = 1;
    *(min[1]+now) = *(max[1]+now) = *(min[2]+now) = *(max[2]+now) = 0;
    return;
  }
  if (son[now][1] == -1)
  {
    for (i = 0; i < 3; i++)
      {
	*(min[i]+now) = 10001, *(max[i]+now) = 0;
	if (i == 0) h = 1;
	else h = 0;
	for (j = 0; j < 3; j++)
	  if (i != j)
	  {
	    if (*(min[i]+now) > *(min[j]+son[now][0])+h)
	    *(min[i]+now) = *(min[j]+son[now][0])+h;
	    if (*(max[i]+now) < *(max[j]+son[now][0])+h)
	    *(max[i]+now) = *(max[j]+son[now][0])+h;
	  }
      }
    return;
  }
  for (i = 0; i < 3; i++)
  {
    *(min[i]+now) = 10001, *(max[i]+now) = 0;
    if (i == 0) h = 1;
    else h = 0;
    for (j = 0; j < 3; j++)
      if (i != j)
      for (k = 0; k < 3; k++)
	if (k != i && k != j)
	{
	  if (*(min[i]+now)>*(min[j]+son[now][0])+*(min[k]+son[now][1])+h)
	    *(min[i]+now) = *(min[j]+son[now][0])+*(min[k]+son[now][1])+h;
	  if (*(max[i]+now)<*(max[j]+son[now][0])+*(max[k]+son[now][1])+h)
	    *(max[i]+now) = *(max[j]+son[now][0])+*(max[k]+son[now][1])+h;
	}
  }
}

void main()
{
  int i;

  for (i = 0; i < 3; i++)
  {
    min[i] = (int far *) farcalloc(10000,sizeof(int));
    max[i] = (int far *) farcalloc(10000,sizeof(int));
  }
  fin = fopen("tro.in","rt");
  fscanf(fin,"%s\n", s);
  fclose(fin);
  for (p = 0, tot = 0, i = 0; i < 10001; son[i][0] = son[i][1] = -1, i++);
  build();
  for (i = tot; i >= 0; i--)
    work(i);

  fout = fopen("tro.out","wt");
  if (*(min[0]) < *(min[1]))
    minans = (*(min[0]) < *(min[2])) ? *(min[0]) : *(min[2]);
  else
    minans = (*(min[1]) < *(min[2])) ? *(min[1]) : *(min[2]);

  if (*(max[0]) > *(max[1]))
    maxans = (*(max[0]) > *(max[2])) ? *(max[0]) : *(max[2]);
  else
    maxans = (*(max[1]) > *(max[2])) ? *(max[1]) : *(max[2]);
  fprintf(fout, "%d %d\n", maxans, minans);
  fclose(fout);
}