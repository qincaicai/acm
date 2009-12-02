/* Ulm Local Contest 1999    */
/* Problem F: Friends        */
/* Author:    Mark Dettinger */

#include <stdio.h>
#include <ctype.h>
#include <assert.h>

typedef int set;

#define EmptySet   0
#define IsValid(s) ((s)>=0 && (s)<0x4000000)
#define IsIn(x,s)  ((s)&(1<<(x)))

FILE *input;

char line[1000];
int p;

int read_case()
{
  fgets(line,1000,input);
  if (feof(input)) return 0;
  return 1;
}

set expr();

set atomic_expr()
{
  set s;

  if (line[p]=='{')
    {
      p++;
      s = EmptySet;
      while (isupper((int)line[p]))
	{
	  s |= 1 << (line[p]-'A');
	  p++;
	}
      assert(line[p]=='}');
      p++;
    }
  else if (line[p]=='(')
    {
      p++;
      s = expr();
      assert(line[p]==')');
      p++;
    }
  else
    {
      printf("atomic_expr: unexpected character %c\n",line[p]);
      assert(0);
    }
  assert(IsValid(s));
  return s;
}

set simple_expr()
/* Parses an expression of the form "e1 * e2 * e3 ...". */
{
  set s;

  s = atomic_expr();
  while (line[p]=='*')
    {
      set s2;
      p++;
      s2 = atomic_expr();
      s = s & s2;
    }
  assert(line[p]=='+' || line[p]=='-' || line[p]==')' || line[p]=='\n');
  assert(IsValid(s));
  return s;
}

set expr()
/* Parses an expression of the form "e1 [+|-] e2 [+|-] e3 ...". */
{
  set s;

  s = simple_expr();
  while (line[p]=='+' || line[p]=='-')
    {
      set s2;
      if (line[p]=='+')
	{
	  p++;
	  s2 = simple_expr();
	  s = s | s2;
	}
      else /* if (line[p]=='-') */
	{
	  p++;
	  s2 = simple_expr();
	  s = s & ~s2;
	}
    }
  assert(line[p]==')' || line[p]=='\n');
  assert(IsValid(s));
  return s;
}

void solve_case()
{
  set s;
  int i;

  p = 0;
  s = expr();
  printf("{");
  for (i=0; i<26; i++)
    if (IsIn(i,s))
      printf("%c",'A'+i);
  printf("}\n");
}

int main()
{
  input = fopen("friends.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
