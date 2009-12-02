/*
	Problem: 	Rails
	Author:		Jan Kotas
	Algorithm:	stack
	Complexity:	linear
*/

#include <stdio.h>

#define bool int
#define true 1
#define false 0

int stack[1024];

void main()
{
	int i, n, x, sp, to_go;
	bool ok;
	
   freopen("rails.in","r",stdin);
   freopen("rails.out","w", stdout);
	for(;;)
	{
		scanf("%d", &n);

		if(!n) break;

		for(;;)
		{
			scanf("%d", &x);

			if(!x) break;

			ok = true;
			sp = 0;
			to_go = 1;

			for(i = 1; i < n; i++)
			{
				for(; to_go <= x; to_go++)
					stack[sp++] = to_go;

				if(sp <= 0 || stack[--sp] != x) ok = false;

				scanf("%d", &x);
			}

			if((to_go != x) && (sp <= 0 || stack[--sp] != x)) ok = false;

			printf(ok ? "Yes\n" : "No\n");
		}

		printf("\n");
	}
}
