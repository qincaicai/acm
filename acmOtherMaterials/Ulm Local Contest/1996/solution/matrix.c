/* University of Ulm Programming Contest 1996
   Problem G: Matrix Chain Multiplication
   Implementation: Mark Dettinger */

#include <stdio.h>

typedef struct {int mults; int rows; int cols;} triple;  

int rows[256],cols[256];  /* sizes of the matrices               */
char e[100];              /* the expression that is to be parsed */
int p;                    /* current position during parsing     */
char error;               /* error flag                          */

triple expression()
{
  /* Precondition: The expression to be parsed begins at &e[p]. */

  triple t;
  if (e[p]=='(')  /* Case 1: Expr -> ( Expr Expr ) */
    {
      triple t1,t2;
      p++;
      t1 = expression();
      t2 = expression();
      p++;
      if (t1.cols!=t2.rows) error = 1;  /* matrices are incompatible */
      t.rows  = t1.rows;
      t.cols  = t2.cols;
      t.mults = t1.mults+t2.mults+t1.rows*t1.cols*t2.cols;
    }
  else            /* Case 2: Expr -> Matrix */ 
    {
      t.rows = rows[e[p]];
      t.cols = cols[e[p]];
      t.mults = 0;
      p++;
    }
  return t;  

  /* Return Value: a triple consisting of three integers representing
                   - the number of needed multiplications 
		   - the number of rows of the resulting matrix
		   - the number of columns of the resulting matrix */

  /* Postcondition: &e[p] points to the character after the expression
     that has been parsed */
}

main()
{
  FILE* input = fopen("matrix.in","r");
  char c;
  int i,n,ro,co;
  triple t;
  
  fscanf(input,"%d%c",&n,&c);  /* read number of matrices */
  for (i=0; i<n; i++)          /* read sizes of matrices */
    {
      fgets(e,99,input);
      sscanf(e,"%c %d %d",&c,&ro,&co);
      rows[c] = ro;
      cols[c] = co;
    }
  while (1)               /* for each expression do */
    {
      fgets(e,99,input);       /* read expression */
      if (feof(input)) break;
      p = error = 0;           /* parse expression */
      t = expression();      
      if (error)               /* print result */
	puts("error");
      else
	printf("%d\n",t.mults);
    }
  fclose(input);
  return 0;
}
