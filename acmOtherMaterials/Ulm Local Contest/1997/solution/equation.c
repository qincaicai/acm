/* Contest   : Ulm Local Contest 1997 
 * Problem E : Equation Solver 
 * Method    : ELL(1)-Parser
 * Author    : Mark Dettinger
 * Date      : June 3, 1997
 */

#include <stdio.h>
#include <ctype.h>
#include <assert.h>

typedef struct { int a0,a1; } linexpr;

FILE *input;
int equation=0;
char e[100];
int p;

int read_case()
{
  fgets(e,100,input);
  if (feof(input)) return 0;
  return 1;
}

linexpr expression();

linexpr factor()  /* Factor ::= Number | 'x' | '(' Expression ')' */
{
  linexpr f;

  if (e[p]=='x')
    {
      p++;
      f.a1 = 1;
      f.a0 = 0;
    }
  else if (e[p]=='(')
    {
      p++;
      f = expression();
      p++;
    }
  else
    {
      f.a1 = f.a0 = 0;
      while (isdigit(e[p]))
	f.a0 = 10*f.a0 + e[p++]-'0';
    }
  return f;
}

linexpr term()  /* Term ::= Factor { * Factor } */
{
  linexpr f,f2;

  f = factor();
  while (e[p]=='*')
    {
      p++;
      f2 = factor();
      f.a1 = f.a1*f2.a0 + f.a0*f2.a1;
      f.a0 = f.a0 * f2.a0;
    }
  return f;
}

linexpr expression()  /* Expression ::= Term { (+|-) Term } */
{
  linexpr t,t2;

  t = term();
  while (e[p]=='+' || e[p]=='-')
    {
      if (e[p]=='+')
	{
	  p++;
	  t2 = term();
	  t.a0 += t2.a0;
	  t.a1 += t2.a1;
	}
      else if (e[p]=='-')
	{
	  p++;
	  t2 = term();
	  t.a0 -= t2.a0;
	  t.a1 -= t2.a1;
	}
    }
  return t;
}

void solve_case()
{
  linexpr lhs,rhs;

  /* 1. parse equation */

  p = 0;
  lhs = expression();
  p++;
  rhs = expression();

  /* 2. solve equation */

  printf("Equation #%d\n",++equation);
  if (lhs.a1==rhs.a1)
    if (lhs.a0==rhs.a0) printf("Infinitely many solutions.\n\n");
    else                printf("No solution.\n\n");
  else
    printf("x = %f\n\n",(double)(rhs.a0-lhs.a0)/(lhs.a1-rhs.a1));
}

int main()
{
  input = fopen("equation.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
