/* POI 99 Stage 2 BIT */
#include <stdio.h>
#include <alloc.h>
FILE *fin, *fout;
int dire[4][2] = {{1,0},{0,1},{-1,0},{0,-1}};
long n, m;
char map[182][182];
int far *wayx[182];
int far *wayy[182];
int far *dis[182];

void main()
{
  long i, j, h, t, x, y, x1, y1, distance;

  for (i = 0; i < 182; i++)
  {
    wayx[i] = (int far *) farcalloc(182,sizeof(int));
    wayy[i] = (int far *) farcalloc(182,sizeof(int));
    dis[i] = (int far *) farcalloc(182,sizeof(int));
  }

  fin = fopen("bit.in","rt");
  fscanf(fin, "%ld %ld", &n, &m);
  for (i = 0; i < n; i++)
    for (j = 0; j < m; *(dis[i]+j) = 400, j++)
      while ((map[i][j]=fgetc(fin)) != '0' && map[i][j] != '1');
  fclose(fin);

  h = 0; t = -1;
  for (i = 0; i < n; i++)
    for (j = 0; j < m; j++)
    if (map[i][j] == '1')
    {
      *(dis[i]+j) = 0, t++;
      *(wayx[t/182]+(t % 182)) = i;
      *(wayy[t/182]+(t % 182)) = j;
    }
  while (h <= t)
  {
    x = *(wayx[h/182]+(h%182));
    y = *(wayy[h/182]+(h%182));
    distance = *(dis[x]+y);
    for (i = 0; i < 4; i++)
    {
      x1 = x+dire[i][0], y1 = y+dire[i][1];
      if (x1 >= 0 && x1 < n && y1 >= 0 && y1 < m && *(dis[x1]+y1) > distance+1)
      {
	*(dis[x1]+y1) = distance+1, t++;
	*(wayx[t/182]+(t % 182)) = x1;
	*(wayy[t/182]+(t % 182)) = y1;
      }
    }
    h++;
  }

  fout = fopen("bit.out","wt");
  for (i = 0; i < n; i++)
  {
    fprintf(fout, "%d", *(dis[i]));
    for (j = 1; j < m; j++)
      fprintf(fout, " %d", *(dis[i]+j));
    fprintf(fout, "\n");
  }
  fclose(fout);
}