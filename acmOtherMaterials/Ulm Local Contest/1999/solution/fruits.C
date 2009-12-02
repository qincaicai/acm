#include <stdio.h>
#include <assert.h>

#define MAX 200

FILE *input;
char a[MAX],b[MAX];
int memo[MAX][MAX];

int scs (int i, int j)
{
  if (memo[i][j]<0)
    {
      if (a[i]==0)
	memo[i][j] = strlen(b+j);
      else if (b[j]==0)
	memo[i][j] = strlen(a+i);
      else if (a[i]==b[j])
	memo[i][j] = scs(i+1,j+1) + 1;
      else
	memo[i][j] = (scs(i+1,j) <? scs(i,j+1)) + 1;
    }
  return memo[i][j];
}

void solve_case()
{
  int i,j;

  for (i=0; i<=strlen(a); i++)
    for (j=0; j<=strlen(b); j++)
      memo[i][j] = -1;
  scs(0,0);
  for (i=j=0;;)
    {
      if (a[i]==0)
	{
	  printf("%s\n",b+j);
	  break;
	}
      else if (b[j]==0)
	{
	  printf("%s\n",a+i);
	  break;
	}
      else if (a[i]==b[j])
	{
	  putchar(a[i]);
	  i++; j++;
	}
      else if (memo[i+1][j] <= memo[i][j+1])
	{
	  putchar(a[i]);
	  i++;
	}
      else
	{
	  putchar(b[j]);
	  j++;
	}
    }
}

int main()
{
  input = fopen("fruits.in","r");
  assert(input!=NULL);
  while (fscanf(input,"%s %s",a,b)==2) solve_case();
  fclose(input);
  return 0;
}
