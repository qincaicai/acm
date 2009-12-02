/* University of Ulm Local Contest 1998
 * Problem A: Artificial Intelligence?
 * Author: Mark Dettinger
 */

#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <assert.h>

FILE* input;
int kase=0;
char line[100],*cp;
double p,u,i;
int fields;  /* for debugging only */

void read (double* res)
{
  cp++;
  if (*cp!='=') return;
  cp++;
  sscanf(cp,"%lf",res);
  while (!isalpha(*cp)) cp++;
  if (*cp=='m') *res /= 1000.0;
  if (*cp=='k') *res *= 1000.0;
  if (*cp=='M') *res *= 1000000.0;
  fields++;
}

void solve_case()
{
  fgets(line,100,input);
  p = u = i = -1;
  fields = 0;
  for (cp=line; *cp; cp++)
    switch (*cp)
      {	
      case 'P': read(&p); break;
      case 'U': read(&u); break;
      case 'I': read(&i); break;
      }
  assert(fields==2);
  printf("Problem #%d\n",++kase);
  if (p>=0 && u>=0) printf("I=%.2fA\n\n",p/u);
  if (p>=0 && i>=0) printf("U=%.2fV\n\n",p/i);
  if (u>=0 && i>=0) printf("P=%.2fW\n\n",u*i);
}

void skip_line() { while (fgetc(input)!='\n'); }

int main()
{
  int numtests;
  input = fopen("ai.in","r");
  assert(input!=NULL);
  fscanf(input,"%d",&numtests);
  skip_line();
  while (numtests--) solve_case();
  fclose(input);
  return 0;
}

