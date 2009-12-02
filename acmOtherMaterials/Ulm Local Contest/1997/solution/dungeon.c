/* Contest   : Ulm Local Contest 1997 
 * Problem D : Dungeon Master
 * Method    : Breadth-First Search
 * Author    : Mark Dettinger
 * Date      : May 29, 1997
 */

#include <stdio.h>
#include <assert.h>

#define WHITE 0
#define GRAY 1
#define BLACK 2
#define oo 1000000000

typedef struct { int lev,row,col; } cell;

FILE *input;

int rows,cols,levels;
char dungeon[40][40][40];
int d[40][40][40],color[40][40][40];
cell queue[30000];
int head,tail;

void skip_line() { while (fgetc(input)!='\n'); }

void enqueue (int l, int i, int j)
{
  queue[tail].lev = l;
  queue[tail].row = i;
  queue[tail].col = j;
  tail++;
  color[l][i][j] = GRAY;
}

void dequeue (int *l, int *i, int *j)
{
  *l = queue[head].lev;
  *i = queue[head].row;
  *j = queue[head].col;
  head++;
  color[*l][*i][*j] = BLACK;
}

void visit (int level, int row, int col, int distance)
{
  if (level<0 || level>=levels || row<0 || row>=rows || col<0 || col>=cols || 
      dungeon[level][row][col]=='#' || color[level][row][col]!=WHITE) return;
  d[level][row][col] = distance;
  enqueue(level,row,col);
}

int read_case()
{
  int l,i;

  fscanf(input,"%d %d %d",&levels,&rows,&cols);
  if (levels==0 && rows==0 && cols==0) return 0;
  skip_line();
  for (l=0; l<levels; l++)
    for (i=0; i<=rows; i++)
      fgets(dungeon[l][i],40,input);
  return 1;
}

void solve_case()
{
  cell start;
  int l,i,j,newd;
  
  /* 1. Initialization */

  for (l=0; l<levels; l++)
    for (i=0; i<rows; i++)
      for (j=0; j<cols; j++)
	{
	  color[l][i][j] = WHITE;
	  d[l][i][j] = oo;
	  if (dungeon[l][i][j]=='S')
	    { start.lev = l; start.row = i; start.col = j; }
	}

  /* 2. Breadth-First Search */

  head = tail = 0;
  visit(start.lev,start.row,start.col,0);
  while (head!=tail)
    {
      dequeue(&l,&i,&j);
      if (dungeon[l][i][j]=='E') break;
      newd = d[l][i][j]+1;
      visit(l  , i-1, j  , newd);  /* North */
      visit(l  , i+1, j  , newd);  /* South */
      visit(l  , i  , j+1, newd);  /* East  */
      visit(l  , i  , j-1, newd);  /* West  */
      visit(l+1, i  , j  , newd);  /* Up    */
      visit(l-1, i  , j  , newd);  /* Down  */
    }

  /* 3. Output */

  if (dungeon[l][i][j]=='E')
    printf("Escaped in %d minute(s).\n",d[l][i][j]);
  else
    printf("Trapped!\n");
}

int main()
{
  input = fopen("dungeon.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
