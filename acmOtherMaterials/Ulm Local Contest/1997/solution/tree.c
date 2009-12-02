/* Contest   : Ulm Local Contest 1997 
 * Problem H : Tree Recovery 
 * Method    : Recursive Descent
 * Author    : Mark Dettinger
 * Date      : June 13, 1997
 */

#include <stdio.h>
#include <string.h>
#include <assert.h>

FILE *input;

char preord[30],inord[30];

int read_case()
{
  fscanf(input,"%s %s",preord,inord);
  if (feof(input)) return 0;
  return 1;
}

void recover (int preleft, int preright, int inleft, int inright)
{
  int root,leftsize,rightsize;

  assert(preleft<=preright && inleft<=inright);

  /* 1. find root in inorder traversal */

  for (root=inleft; root<=inright; root++)
    if (preord[preleft]==inord[root]) break;

  /* 2. compute sizes of subtrees */

  leftsize = root-inleft;
  rightsize = inright-root;

  /* 3. recover subtrees */

  if (leftsize>0)  recover(preleft+1,preleft+leftsize,inleft,root-1);
  if (rightsize>0) recover(preleft+leftsize+1,preright,root+1,inright);

  /* 4. print root */

  printf("%c",inord[root]);
}

void solve_case()
{
  int n = strlen(preord);
  recover(0,n-1,0,n-1);
  printf("\n");
}

int main()
{
  input = fopen("tree.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
