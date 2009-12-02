%{
/* Ulm Local Contest 1999                              */ 
/* Problem F: Friends                                  */
/* Author:    Mark Dettinger                           */
/* Solution in YACC (not an official contest language) */

#include <stdio.h>
#include <assert.h>

#define YYSTYPE int

FILE *input;

void print_set (int s)
{
  int i;
  printf("{");
  for (i=0; i<26; i++)
    if (s&(1<<i)) printf("%c",'A'+i);
  printf("}\n");
}

int yyerror()
{
  exit(1);
}

int yylex()
{
  int c = fgetc(input);
  if (feof(input)) return 0;
  return c;
}

%}

%left '+','-'
%left '*'
%start file

%%

file : line
     | line file

line : expr '\n' { print_set($1); }

expr : expr '+' expr { $$ = $1 | $3;  }
     | expr '-' expr { $$ = $1 & ~$3; }
     | expr '*' expr { $$ = $1 & $3;  }
     | '(' expr ')'  { $$ = $2;       }
     | '{' set '}'   { $$ = $2;       }
     | '{' '}'       { $$ = 0;        }

set : letter     { $$ = $1;      }
    | letter set { $$ = $1 | $2; }

letter : 'A' { $$ = 0x0000001; }
       | 'B' { $$ = 0x0000002; }
       | 'C' { $$ = 0x0000004; }
       | 'D' { $$ = 0x0000008; }
       | 'E' { $$ = 0x0000010; }
       | 'F' { $$ = 0x0000020; }
       | 'G' { $$ = 0x0000040; }
       | 'H' { $$ = 0x0000080; }
       | 'I' { $$ = 0x0000100; }
       | 'J' { $$ = 0x0000200; }
       | 'K' { $$ = 0x0000400; }
       | 'L' { $$ = 0x0000800; }
       | 'M' { $$ = 0x0001000; }
       | 'N' { $$ = 0x0002000; }
       | 'O' { $$ = 0x0004000; }
       | 'P' { $$ = 0x0008000; }
       | 'Q' { $$ = 0x0010000; }
       | 'R' { $$ = 0x0020000; }
       | 'S' { $$ = 0x0040000; }
       | 'T' { $$ = 0x0080000; }
       | 'U' { $$ = 0x0100000; }
       | 'V' { $$ = 0x0200000; }
       | 'W' { $$ = 0x0400000; }
       | 'X' { $$ = 0x0800000; }
       | 'Y' { $$ = 0x1000000; }
       | 'Z' { $$ = 0x2000000; }

%%

int main()
{
  input = fopen("friends.in","r");
  assert(input!=NULL);
  yyparse();
  fclose(input);
  return 0;
}
