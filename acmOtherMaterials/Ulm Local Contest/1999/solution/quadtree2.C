#include <stdio.h>
#include <assert.h>

#define MAX_N 1024

typedef struct node* tree;

typedef struct node {
  char c;
  tree top_left;
  tree top_right;
  tree bottom_left;
  tree bottom_right;
} node;

FILE *input;
int n;
unsigned char xbm[MAX_N][MAX_N/8];

tree simplify (tree q)
{  
  if (q->c!='Q') return q;
  if (q->top_left->c=='W'    && q->top_right->c=='W' &&
      q->bottom_left->c=='W' && q->bottom_right->c=='W')
    {
      //printf("QWWWW -> W\n");
      delete q->top_left;
      delete q->top_right;
      delete q->bottom_left;
      delete q->bottom_right;
      q->c = 'W';
      return q;
    }
  if (q->top_left->c=='B'    && q->top_right->c=='B' &&
      q->bottom_left->c=='B' && q->bottom_right->c=='B')
    {
      //printf("QBBBB -> B\n");
      delete q->top_left;
      delete q->top_right;
      delete q->bottom_left;
      delete q->bottom_right;
      q->c = 'B';
      return q;
    }  
  return q;
}

tree encode (int top, int left, int size)
{
  tree q = new node;

  if (size==1)
    {
      q->c = xbm[top][left/8] & (1<<(left%8)) ? 'B' : 'W';
      q->top_left = NULL;
      q->top_right = NULL;
      q->bottom_left = NULL;
      q->bottom_right = NULL;
    }
  else
    {
      q->c = 'Q';
      q->top_left = encode(top,left,size/2);
      q->top_right = encode(top,left+size/2,size/2);
      q->bottom_left = encode(top+size/2,left,size/2);
      q->bottom_right = encode(top+size/2,left+size/2,size/2);
    }
  return simplify(q);
}

void print (tree q)
{
  putchar(q->c);
  if (q->c=='Q')
    {
      print(q->top_left);
      print(q->top_right);
      print(q->bottom_left);
      print(q->bottom_right);
    }
}

int main()
{
  char line[1000];

  input = fopen("quadtree2.in","r");
  assert(input!=NULL);
  fgets(line,1000,input);
  sscanf(line,"%*s %*s %d",&n);
  fgets(line,1000,input);
  fgets(line,1000,input);
  for (int i=0; i<n; i++)
    for (int j=0; j<n/8; j++)
      {
	int tmp;
	assert(fscanf(input," 0x%x, ",&tmp)==1);
	xbm[i][j] = tmp;
      }
  fclose(input);
  printf("%d\n",n);
  print(encode(0,0,n));
  printf("\n");
  return 0;
}
