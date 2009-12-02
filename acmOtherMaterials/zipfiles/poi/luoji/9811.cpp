#include <stdio.h>
#include <string.h>
#define LIMIT 35
#define MAX 100

FILE *fin, *fout;

int m[LIMIT], bakm[LIMIT];
int n;

int zero()
{
  int i;
  for (i = 0; i < LIMIT; i++)
    if (m[i] != 0) return 0;
  return 1;
}

void work(int signal)
{
   int step, i;
   int use[MAX];

   step = 0;
   memset(use,0,sizeof(use));

   while (zero() == 0)
   {
     if (step >= MAX)
     {
       fprintf(fout, "NIE\n");
       return;
     }
     if (m[0] % 2 == 1)
     {
       if (signal == 0)
         m[0]++;
       else
         m[0]--;
       use[step] = 1;
     }
     for (i = LIMIT-1; i >= 0; i--)
     {
       if (m[i] % 2 == 1) m[i-1] += 10;
       m[i] /= 2;
     }
     signal = 1-signal;
     step++;
   }

   for (i =MAX-1; i >=0; i--)
     if (use[i] == 1) fprintf(fout, "%d ", i);
   fprintf(fout, "\n");
}

void main()
{
  int i, j;
  char s[35];

  fin = fopen("BAN.IN","rt");
  fout = fopen("BAN.OUT","wt");

  fscanf(fin, "%d\n", &n);
  for (i = 0; i < n; i++)
  {
    fscanf(fin, "%s\n", &s);
    memset(bakm,0,sizeof(bakm));
    for (j = 0; j < strlen(s); j++)
      bakm[j] = s[strlen(s)-1-j] - '0';

    memcpy(m,bakm,sizeof(m));
    work(1);

    memcpy(m,bakm,sizeof(m));
    work(0);
  }

  fclose(fout);
  fclose(fin);
}