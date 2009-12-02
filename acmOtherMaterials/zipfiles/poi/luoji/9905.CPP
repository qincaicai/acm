#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <time.h>
extern unsigned _stklen = 65000;
FILE *fin, *fout;
struct point {
  int x, y, mark;
};
struct point *p[2];

int n;
int op[10000];

time_t start,finish;

void init()
{
  long i, j;

  fin = fopen("rak.in","rt");
  fscanf(fin, "%d", &n);
  for (i = 0; i < 2; i++)
  {
    p[i] = (point far *) farcalloc(10000,sizeof(point));
    for (j = 0; j < n; (*(p[i]+j)).mark = j, j++)
      fscanf(fin, "%d %d", &((*(p[i]+j)).x), &((*(p[i]+j)).y));
  }
  fclose(fin);
}

void print()
{
  fout = fopen("rak.out","wt");
  for (int i = 0; i < n; i++)
    fprintf(fout, "%d\n", op[i]+1);
  fclose(fout);
}

void swap(int ob, int i, int j)
{
  struct point tmp;
  tmp = *(p[ob]+i);
  *(p[ob]+i) = *(p[ob]+j);
  *(p[ob]+j) = tmp;
}

int calc(long x0, long y0, long x1, long y1, long x, long y)
{
  return (y0-y)*(x1-x) <= (y1-y)*(x0-x);
}

int count(int ob, int h, int t, long x0, long y0, long x1, long y1)
{
  int i, j;

  i = h; j = t;
  do {
    while (i <= t && calc(x0,y0,x1,y1,(*(p[ob]+i)).x,(*(p[ob]+i)).y)) i++;
    while (j >= h && !calc(x0,y0,x1,y1,(*(p[ob]+j)).x,(*(p[ob]+j)).y)) j--;
    if (i <= j) {swap(ob,i,j);i++;j--;}
    else return j;
  } while (i <= j);
  return j;
}

int count1(int ob, int h, int t, long x0, long y0, long x1, long y1, int half)
{
  int i, j;

  i = h; j = t;
  do {
    while (i <= t && calc(x0,y0,x1,y1,(*(p[ob]+i)).x,(*(p[ob]+i)).y)) i++;
    while (j >= h && !calc(x0,y0,x1,y1,(*(p[ob]+j)).x,(*(p[ob]+j)).y)) j--;
    if (i <= j) {
      if (half == i) half = j;
      else if (half == j) half = i;
      swap(ob,i,j);i++;j--;
    }
    else break;
  } while (i <= j);
  swap(ob,half,j);
  return j;
}

int find(int ob, int h, int t)
{
  int mid, num, min1, max1, min2, max2, half;
  long x0, y0, x1, y1;

  x0 = (*(p[ob]+h)).x; y0 = (*(p[ob]+h)).y;
  min1 = min2 = h; max1 = max2 = t;
  min1++;

  do {
    half = random(max2-min2+1)+min2;
    x1 = (*(p[1-ob]+half)).x; y1 = (*(p[1-ob]+half)).y;
    mid = count1(1-ob,min2,max2,x0,y0,x1,y1,half);
    num = count(ob,min1,max1,x0,y0,x1,y1);

    if (num <= mid)
    {
      max1 = num;
      max2 = mid;
    } else
    {
      min1 = num+1;
      min2 = mid+1;
    }
  } while (mid != num);
  return mid;
}

void work(int h, int t)
{
  int i, j, ob, low, best;

  while (h < t)
  {
    for (ob = 0, low = h, i = 0; i < 2; i++)
      for (j = h; j <= t; j++)
      if ((*(p[i]+j)).y<(*(p[ob]+low)).y) ob = i, low = j;

    swap(ob,h,low);
    best = find(ob,h,t);
    swap(1-ob,h,best);

    op[(*(p[0]+h)).mark] = (*(p[1]+h)).mark;

    if (best-h > t-best)
      {	work(best+1,t);
	t = best; h++;}
    else
      {	work(h+1,best);
	h = best+1;}
  }
  if (h == t)
  op[(*(p[0]+h)).mark] = (*(p[1]+h)).mark;
}

void main()
{
  time(&start);
  randomize();
  init();
  work(0,n-1);
  print();
  time(&finish);
//  printf("%ld\n", finish-start);
}