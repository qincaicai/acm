/* POI 99 Stage 3 MAG */
/* the best one!!! */
#include <stdio.h>
#include <ctype.h>
int dire[4][2] = {{0,1},{0,-1},{-1,0},{1,0}};
int op[4] = {1,0,3,2};

char map[100][100];

int manx, many, sx, sy, tx, ty;
int n, m;

long ans[100][100][4];
int way[100*100*4][3];

int reach[100][100]; /* for dfs */

int totalmark;
int mark[100][100];
int low[100][100];

int regmark;

int totalreg[100][100];
int reg[100][100][10];

FILE *fin, *fout;

void init()
{
  int i, j;
  char c;

  fin = fopen("mag.in","rt");
  fscanf(fin, "%d %d", &n, &m);
  for (i = 0; i < n; i++)
    for (j = 0; j < m; j++)
      {
        c = fgetc(fin);
        while (!isupper(c) && !islower(c)) c = fgetc(fin);
        if (c == 'M') manx = i, many = j, c = 'w';
        if (c == 'P') sx = i, sy = j, c = 'w';
        if (c == 'K') tx = i, ty = j, c = 'w';
        map[i][j] = c;
      }
  fclose(fin);
}

void print()
{
  long min, i;
  fout = fopen("mag.out","wt");
  for (min = ans[tx][ty][0], i = 1; i < 4; i++)
    if (ans[tx][ty][i] < min) min = ans[tx][ty][i];
  if (min == 1000000000) fprintf(fout, "NIE\n");
  else fprintf(fout, "%ld\n", min);
  fclose(fout);
}

int avail(int x, int y)
{
  if (x < 0 || y < 0 || x >= n || y >= m) return 0;
  if (map[x][y] != 'w') return 0;
  return 1;
}

int min(int x, int y)
{
  if (x < y) return x;
  return y;
}

void put(int x, int y, int fax, int fay)
{
  int i, x1, y1;

  if (x == fax && y == fay) return;
  if (reach[x][y] == 2) return; /* 2 is deleted */

  reg[x][y][totalreg[x][y]] = regmark;
  totalreg[x][y]++;
  reach[x][y] = 2;

  for (i = 0; i < 4; i++)
  {
    x1 = x+dire[i][0]; y1 = y+dire[i][1];
    if (avail(x1,y1) == 1) put(x1,y1,fax,fay);
  }
}

void fill(int x, int y)
{
  int x1, y1;
  int i;

  for (i = 0; i < 4; i++)
  {
    x1 = x+dire[i][0]; y1 = y+dire[i][1];
    if (avail(x1,y1) == 1)
    {
      if (mark[x1][y1] == -1)
      {
        mark[x1][y1] = totalmark; totalmark++;
        fill(x1,y1);
        low[x][y] = min(low[x][y], low[x1][y1]);
        if (low[x1][y1] >= mark[x][y])
        {
          regmark++;
          put(x1,y1,x,y);
          reg[x][y][totalreg[x][y]] = regmark;
          totalreg[x][y]++;
          reach[x][y] = 1;
        }
      } else low[x][y] = min(low[x][y], mark[x1][y1]);
    }
  }
}

void work()
{
  int i, j;

  totalmark = 0;
  regmark = 0;
  for (i = 0; i < n; i++)
    for (j = 0; j < m; j++)
    {
      mark[i][j] = -1;
      low[i][j] = 20000;
      totalreg[i][j] = 0;
      reach[i][j] = -1;
    }

  for (i = 0; i < n; i++)
    for (j = 0; j < m; j++)
      if (avail(i,j) == 1 && mark[i][j] == -1) fill(i,j);
}

int check(int x1, int y1, int x2, int y2)
{
  int i, j;

  for (i = 0; i < totalreg[x1][y1]; i++)
    for (j = 0; j < totalreg[x2][y2]; j++)
      if (reg[x1][y1][i] == reg[x2][y2][j]) return 1;

  return 0;
}

void dfs(int x, int y)
{
  int i , x1, y1;
  if (reach[x][y] == 1) return;
  reach[x][y] = 1;
  for (i = 0; i < 4; i++)
  {
    x1 = x+dire[i][0];
    y1 = y+dire[i][1];
    if (avail(x1,y1)==1 && (x1 != sx || y1 != sy)) dfs(x1,y1);
  }
}

void solve()
{
  int i, j, k, x, y, x1, y1, d;
  long h, t;

  for (i = 0; i < n; i++)
    for (j = 0; j < m; j++)
    {
      reach[i][j] = 0;
      for (k = 0; k < 4; k++)
        ans[i][j][k] = 1000000000;
    }
  dfs(manx,many);
  h = 0; t = -1;
  for (i = 0; i < 4; i++)
  {
    x = sx+dire[i][0];
    y = sy+dire[i][1];
    if (avail(x,y) == 1&& reach[x][y] == 1)
    {
      t++;
      ans[sx][sy][i] = 0;
      way[t][0] = sx; way[t][1] = sy; way[t][2] = i;
    }
  }
  while (h <= t)
  {
    d = way[h][2];
    x = way[h][0]+dire[op[d]][0]; y = way[h][1]+dire[op[d]][1];
    if (avail(x,y) == 1 && ans[x][y][d] > ans[way[h][0]][way[h][1]][d]+1)
    {
      t++;
      ans[x][y][d] = ans[way[h][0]][way[h][1]][d]+1;
      way[t][0] = x; way[t][1] = y; way[t][2] = d;

      for (i = 0; i < 4; i++)
      if (i != d)
      {
        x1 = x+dire[i][0]; y1 = y+dire[i][1];
        if (avail(x1,y1) == 1 && check(x1,y1,way[h][0],way[h][1]) &&
           ans[x][y][i] > ans[x][y][d])
        {
          t++;
          ans[x][y][i] = ans[x][y][d];
          way[t][0] = x; way[t][1] = y; way[t][2] = i;
        }
      }
    }
    h++;
  }
}

void main()
{
  init();
  work();
  solve();
  print();
}
