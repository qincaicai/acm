/* POI VI Stage 3 Problem 6 WOD */
#include <stdio.h>
int dire[4][2] = {{-1,0},{1,0},{0,-1},{0,1}};
int high[100][100];
int water[100][100];
/* -1:  has not been reached
   -2:  waiting in the Heap Cannot be filled water!!!
   -3:  has been used, and removed from the Heap
   otherwise: the waterlevel
*/
int Heap[100*100][3];
int n, m, HeapLen;
FILE *fin, *fout;

void init()
{
  int i, j;
  fin = fopen("wod.in","rt");
  fscanf(fin, "%d %d", &m, &n);
  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
      fscanf(fin, "%d", &high[i][j]);
  fclose(fin);
}

void print()
{
  long i, j, total;
  fout = fopen("wod.out","wt");
  for (total = 0, i = 0; i < m; i++)
    for (j = 0; j < n; j++)
      if (water[i][j] > high[i][j])
      total += water[i][j]-high[i][j];
  fprintf(fout, "%ld\n", total);
  fclose(fout);
}

void swap(int i, int j)
/* swap the data between Heap[i] and Heap[j] */
{
  int k, tmp;
  
  for (k = 0; k < 3; k++)
  {
    tmp = Heap[i][k];
    Heap[i][k] = Heap[j][k];
    Heap[j][k] = tmp;
  }
}

void add(int x, int y)
/* add a point into the Heap
   But the condition is : water[x][y] == 1 */
{
  int i;
  
  water[x][y] = -2;
  Heap[HeapLen][0] = x;
  Heap[HeapLen][1] = y;
  Heap[HeapLen][2] = high[x][y];
  HeapLen++;

  i = HeapLen-1;
  while (i > 0)
    if ( Heap[i/2][2] > Heap[i][2] )
    {
      swap(i/2,i);
      i /= 2;
    } else break;
}

void del()
/* remove the first point in the Heap */
{
  int i, j;
  swap(0,HeapLen-1);
  HeapLen--;

  i = 0;
  while (i*2 < HeapLen)
  {
    j = i*2;
    if (j+1 < HeapLen && Heap[j+1][2] < Heap[j][2]) j++;
    if (Heap[i][2] <= Heap[j][2])
      break;
    else
      {
        swap(i,j);
        i = j;
      }
  }
}

int checkinside(int x1, int y1)
/* careful check of point(x1,y1)
   avoid outside */
{
  if (x1 < 0 || y1 < 0 || x1 >= m || y1 >= n) return 0;
  return 1;
}

void fill(int x, int y, int lvl)
/* start from (x,y), fill water in it */
{
  int i, x1, y1;
  
  if (checkinside(x,y) == 0) return;
  if (water[x][y] != -1) return;
  if (high[x][y] >= lvl)
  {
    add(x,y);
    return;
  } else
  {
    water[x][y] = lvl;
    for (i = 0; i < 4; i++)
    {
      x1 = x+dire[i][0]; y1 = y+dire[i][1];
      fill(x1,y1,lvl);
    }
  }
}

void work()
{
  int i, j, x, y, x1, y1;

  HeapLen = 0;
  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
    {
      water[i][j] = -1;
      if (i == 0 || j == 0 || i == m-1 || j == n-1) add(i,j);
    }

  while (HeapLen > 0)
  {
    x = Heap[0][0];
    y = Heap[0][1];
    if (water[x][y] == -2)
    {
      water[x][y] == -3;
      for (i = 0; i < 4; i++)
      {
        x1 = x+dire[i][0]; y1 = y+dire[i][1];
        if (checkinside(x1,y1)) fill(x1,y1,high[x][y]);
      } /* end of for */
    }
    del();
  } /* end of while */
}

void main()
{
  init();
  work();
  print();
}
