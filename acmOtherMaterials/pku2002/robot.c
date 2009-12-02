/*
	Problem: 	Robot
	Author1:		Jan Kotas
	Algor1ithm:	breadth search + heap
	Complexity:	n * m
*/

#include <stdio.h>

char mat[64][64]; /* source */

unsigned tm[64][64]; /* time */
int or1[64][64]; /* reachable orientation */
int hp[64][64]; /* heap index, -1 - not used */

struct { int x, y; } heap[4096]; /* the heap */

int dx[4] = { -1,  0,  1,  0 };
int dy[4] = {  0, -1,  0,  1 };

int reg(int x)
{
	return x
		| ((x & 15) << 4)
		| ((x &  7) << 5)
		| ((x &  8) << 1)
		| ((x & 14) << 3)
		| ((x &  1) << 7);
}

#define VAL(i) (tm[heap[(i)].x][heap[(i)].y])

void swap(int i, int j)
{
	int x1, y1, x2, y2;
	
	x1 = heap[i].x;
	y1 = heap[i].y;
	x2 = heap[j].x;
	y2 = heap[j].y;
	
	heap[i].x = x2;
	heap[i].y = y2;
	heap[j].x = x1;
	heap[j].y = y1;
	
	hp[x1][y1] = j;
	hp[x2][y2] = i;
}

#define PRED(i) (((i+1)>>1)-1)
#define SUCC(i) (((i+1)<<1)-1)

void up(int i) /* bubla s prvkem i nahor1u */
{
	while(i)
	{
		int j = PRED(i);
		if(VAL(j) <= VAL(i)) return;
		swap(i, j);
		i = j;
	}
}

void down(int hs) /* bubla s prvkem 0 dolu */
{
	int i = 0;
	for(;;)
	{
		int j = SUCC(i);
		if(j >= hs) return;
		if(j+1 < hs) j += VAL(j) > VAL(j+1);
		if(VAL(i) <= VAL(j)) return;
		swap(i,j);
		i = j;
	}
}

int main()
{
	int i, j, m, n, x, y, xx, yy, o, tox, toy, hs;
	unsigned t;
	char s[32];
	
   freopen("robot.in","r",stdin);
   freopen("robot.out","w", stdout);
	for(;;)
	{
		scanf("%d %d\n", &m, &n);
		
		if( !m && !n) break;
				
		for(i = 1; i<=m; i++)
			for(j = 1; j<=n; j++)
			{
				mat[i][j] = getchar();
				getchar();
			}

		scanf("%d %d %d %d %s\n", &x, &y, &tox, &toy, s);
		
		switch(s[0])
		{
		case 'n': o = 1; break;
		case 'w': o = 2; break;
		case 's': o = 4; break;
		case 'e': o = 8; break;
		}
		
		for(i = 0; i<=m+1; i++) mat[i][0] = mat[i][n+1] = '1';
		for(j = 1; j<=n; j++)   mat[0][j] = mat[m+1][j] = '1';
		
		for(i = 0; i <= m+1; i++)
			for(j = 0; j <= n+1; j++)
			{
				or1[i][j] = 0;
				hp[i][j] = (unsigned)-1;
				tm[i][j] = (unsigned)-1;
			}
			
		or1[x][y] = reg(o);
		tm[x][y] = 0;
		hp[x][y] = 0;
		
		heap[0].x = x;
		heap[0].y = y;
		hs = 1;
		
		while(hs > 0)
		{
			x = heap[0].x;
			y = heap[0].y;
		
			swap(0, --hs);
			down(hs);
			
			for(i = 0; i < 4; i++)
			{
				t = tm[x][y] + !((1 << i) & or1[x][y]) + !((16 << i) & or1[x][y]) + 1;
				
				xx = x;
				yy = y;
				
				for(j = 0; j < 3; j++)
				{
					xx += dx[i];
					yy += dy[i];
					
					if((mat[xx][yy] != '0') ||
					   (mat[xx][yy+1] != '0') ||
					   (mat[xx+1][yy] != '0') ||
					   (mat[xx+1][yy+1] != '0')) break;
					
					if(t < tm[xx][yy])
					{
						o = 1 << i;
						if(tm[xx][yy] == t + 1)
							o |= (or1[xx][yy] & 15) << 4;
						or1[xx][yy] = reg(o);
						tm[xx][yy] = t;
					}
					else
					if(t == tm[xx][yy] && !(or1[xx][yy] & (1 << i)))
					{
						or1[xx][yy] = reg(or1[xx][yy] | (1 << i));
					}
					else continue;
						
					if(hp[xx][yy] == -1)
					{
						heap[hs].x = xx;
						heap[hs].y = yy;
						hp[xx][yy] = hs++;
					}
					
					up(hp[xx][yy]);	
				}
				
			}
			
			if(or1[tox][toy]) break;
		}
		
		printf("%d\n", tm[tox][toy]);
	}
}
