/* Copyright Derek Kisman (ACM ICPC ECNA 98) */

#include <stdio.h>
int w[3][2][12];
int b[3];
char buff[1000];

main() {
	char ch;
	int i, j, k, x, y, z, n;

   freopen("coins.in","r",stdin);
   freopen("coins.out","w", stdout);
	scanf( " %d", &n );
	for( ; n > 0; n-- ) {
		for( i = 0; i < 3; i++ ) {
			for( j = 0; j < 2; j++ ) {
				for( k = 0; k < 12; k++ ) w[i][j][k] = 0;
				scanf( " %s", buff );
				for( k = 0; buff[k]; k++ ) w[i][j][buff[k]-'A'] = 1;
			}
			scanf( " %s", buff );
			if( *buff == 'e' ) {
				b[i] = 0;
			} else if( *buff == 'u' ) {
				b[i] = -1;
			} else {
				b[i] = 1;
			}
		}

		for( i = 0; i < 12; i++ ) {
			for( j = -1; j <= 1; j += 2 ) {
				for( k = 0; k < 3; k++ ) {
					x = 0;
					if( w[k][0][i] ) x -= j;
					if( w[k][1][i] ) x += j;
					if( x != b[k] ) break;
				}
				if( k == 3 ) goto solved;
			}
		}
solved:
		printf( "%c is the counterfeit coin and it is ", i+'A' );
		if( j < 1 ) printf( "light.\n" ); else printf( "heavy.\n" );
	}
}
