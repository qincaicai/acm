#include <stdio.h>
#include <mem.h>
#define LIMIT 50000

int prime[10] = {2,3,5,7,11,13,17,19,23,27};

FILE *fin, *fout;

long double num[LIMIT][11];
char mark[LIMIT];

long double n;

void init()
{
  fin = fopen("ANT.IN","rt");
  fscanf(fin, "%Lf", &n);
  fclose(fin);
}

void work()
{
  long i, j, use;
  long double k;
   
  memset(num,0,sizeof(num));
  memset(mark,'0',sizeof(mark));
  num[1][0] = 1; mark[1] = '1';

  for (i = 1; i < LIMIT; i++)
    if (mark[i] == '1')
    for (j = 0; j < 11; j++)
    if (num[i][j] > 0)
    {
      use = 2; k = prime[j];
      while (k*num[i][j] <= n)
      {
        if (num[use*i][j+1] == 0 || num[use*i][j+1] > k*num[i][j])
        {
          num[use*i][j+1] = k*num[i][j];
          mark[use*i] = '1';
        }
        use++; k *= prime[j];
      }
    }
}

void print()
{
  long i, j;
  long double best;

  fout = fopen("ANT.OUT","wt");
  for (i = LIMIT-1; i >= 1; i--)
    if (mark[i] == '1')
    {
      best = 1e50;
      for (j = 0; j < 11; j++)
        if (num[i][j] <= n && num[i][j] > 0 && num[i][j] < best)
          best = num[i][j];
      if (best <1e40)
      {
        fprintf(fout, "%0.0Lf\n", best);
        break;
      }
    }
  fclose(fout);
}

void main()
{
  init();
  work();
  print();
}