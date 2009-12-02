/* POI 99 Stage 2 LUN */

#include <stdio.h>
#include <string.h>
#define LIMIT 60
FILE *fin, *fout;
/* E 0 N 1 W 2 S 3 */
int n;
int way[9] = {0,1,2,5,8,7,4,3,6};
int ans1[LIMIT], ans2[LIMIT], x[LIMIT], y[LIMIT];
int three[61][LIMIT], sqr[61][LIMIT];
char s1[LIMIT], s2[LIMIT];

void print(int ans[])
{
  int i, j;
  for (i = LIMIT-1; i > 0; i--)
    if (ans[i] > 0) break;
  for (j = i; j >= 0; j--)
    fprintf(fout, "%d", ans[j]);
  fprintf(fout, "\n");
}

void update(int a[])
{
  int i;
  for (i = 0; i < LIMIT-1; i++)
    while (a[i] < 0)
      a[i] += 10, a[i+1] --;
  for (i = 0; i < LIMIT-1; i++)
    {
      a[i+1] += a[i] / 10;
      a[i] = a[i] % 10;
    }
}

void sub(int a[], int b[])
{
  int i;
  for (i = 0; i < LIMIT; i++)
    a[i] -= b[i];
  update(a);
}

void add(int a[], int b[])
{
  int i;
  for (i = 0; i < LIMIT; i++)
    a[i] += b[i];
  update(a);
}

int cmp(int a[], int b[])
{
  int i;
  for (i = LIMIT-1; i >= 0; i--)
    {
      if (a[i] > b[i]) return 1;
      if (a[i] < b[i]) return -1;
    }
  return 0;
}

void copy(int a[], int b[])
{
  for (int i = 0; i < LIMIT; a[i] = b[i], i++);
}

void swap(int a[], int b[])
{
  int tmp[LIMIT];
  copy(tmp,a);
  copy(a,b);
  copy(b,tmp);
}

int find(int step, int x[], int y[])
{
  int i, j, k;
  int x0[LIMIT], x1[LIMIT], y0[LIMIT], y1[LIMIT];

  for (i = 0; i < 3; i++)
    for (j = 0; j < 3; j++)
    {
      for (k = 0; k < LIMIT; x0[k] = three[step-1][k] * j, k++);
      for (k = 0; k < LIMIT; y0[k] = three[step-1][k] * i, k++);
      update(x0); update(y0);
      copy(x1,x0); copy(y1,y0);
      add(x1,three[step-1]); add(y1,three[step-1]);
      x1[0]--; y1[0]--;
      update(x1); update(y1);

      if (cmp(x,x0)>=0 && cmp(x,x1)<=0 &&
	  cmp(y,y0)>=0 && cmp(y,y1)<=0)
      {
	if (j == 2 || (i == 2 && j == 0)) {sub(x,x0); sub(y,y0);}
	if (i == 0 && j < 2) // a
	{
	  sub(x,x0); sub(y,y0);
	  swap(x,y);
	}
	if (i == 1 && j < 2) // b
	{
	  sub(x1,x); sub(y1,y);
	  copy(x,y1); copy(y,x1);
	}
	if (i == 2 && j == 1) // c
	{
	  sub(x1,x); sub(y1,y);
	  copy(x,x1); copy(y,y1);
	}
	return (i*3+j);
      }
    }
  return 0;
}

void work(int step, int x[], int y[], int ans[])
{
  int i, address;

  while (step > 0)
  {
    address = find(step,x,y);
    for (i = 0; i < 9; i++)
      if (way[i] != address)
	add(ans,sqr[step-1]);
      else
	break;
    step--;
  }
}

void count(char s1[], char s2[], int ans[])
{
  int i;
  for (i = 0; i < LIMIT; ans[i] = x[i] = y[i] = 0, i++);
  for (i = 0; i <  strlen(s1); x[i] = s1[strlen(s1)-1-i] - '0', i++);
  for (i = 0; i <  strlen(s2); y[i] = s2[strlen(s2)-1-i] - '0', i++);
  x[0]--; y[0]--; update(x); update(y);
  work(n,x,y,ans);
}

void init()
{
  int i, j, k;
  for (three[0][0] = 1, i = 1; i < LIMIT; three[0][i] = 0, i++);
  for (i = 1; i <= 60; i++)
  {
    for (j = 0; j < LIMIT; three[i][j] = three[i-1][j]*3, j++);
    update(three[i]);
  }
  for (i = 0; i <= 60; i++)
  {
    for (j = 0; j < LIMIT; sqr[i][j] = 0, j++);
    for (j = 0; j < LIMIT; j++)
      for (k = 0; k < LIMIT; k++)
	sqr[i][j+k] += three[i][j]*three[i][k];
    update(sqr[i]);
  }
}

void main()
{
  init();
  fin = fopen("lun.in","rt");
  fscanf(fin, "%d\n", &n);
  fscanf(fin, "%s %s\n", &s1, &s2);
  count(s1,s2,ans1);
  fscanf(fin, "%s %s\n", &s1, &s2);
  count(s1,s2,ans2);
  fclose(fin);
  fout = fopen("lun.out","wt");
  sub(ans2,ans1);
  print(ans2);
  fclose(fout);
}