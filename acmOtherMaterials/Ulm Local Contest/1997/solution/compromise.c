/* Contest   : Ulm Local Contest 1997 
 * Problem C : Compromise 
 * Method    : Dynamic Programming
 * Author    : Mark Dettinger
 * Date      : June 3, 1997
 */

#include <stdio.h>
#include <string.h>
#include <assert.h>

#define MAX(a,b) ((a)>(b)?(a):(b))

FILE *input;
int kase=0;
char a[1000][50],b[1000][50];
int an,bn;
int tab[1000][1000];

int read_case()
{
  for (an=0; 1; an++)
    {
      fscanf(input,"%s",a[an]);
      if (feof(input)) return 0;
      if (strcmp(a[an],"#")==0) break;
    }
  for (bn=0; 1; bn++)
    {
      fscanf(input,"%s",b[bn]);
      if (strcmp(b[bn],"#")==0) break;
    }
  return 1;
}

void solve_case()
{
  int i,j;

  /* 1. compute table */

  for (i=0; i<=an; i++)
    tab[i][bn] = 0;
  for (j=0; j<=bn; j++)
    tab[an][j] = 0;
  for (i=an-1; i>=0; i--)
    for (j=bn-1; j>=0; j--)
      if (strcmp(a[i],b[j]))
	tab[i][j] = MAX(tab[i][j+1],tab[i+1][j]);
      else
	tab[i][j] = 1+tab[i+1][j+1];

  /* 2. generate output */

  i=j=0;
  while (tab[i][j])
    {
      if (strcmp(a[i],b[j])==0) 
	{ 
	  printf("%s%c",a[i],tab[i][j]>1?' ':'\n');
	  i++;
	  j++;
	}
      else if (tab[i+1][j]>=tab[i][j+1]) i++;
      else j++;
    }
}

int main()
{
  input = fopen("compromise.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
