// Problem   Ambiguous Permutations
// Algorithm straight-forward
// Runtime   O(n)
// Author    Adrian Kuegel
// Date      2005.06.14

import java.io.*;

public class ambiguous {
	public static void main(String [] args) throws IOException {
		BufferedReader in = new BufferedReader(new FileReader("ambiguous.in"));
		int n;
		while( ( n = Integer.parseInt( in.readLine() ) ) > 0 ) {

			// permutation
			int [] perm = new int[n];

			// inverse permutation
			int [] inv_perm = new int[n];

			// read line with integers
			String [] values = in.readLine().split(" ");

			// read the permutation
			for( int i = 0; i < n; i++ ) {
				perm[i] = Integer.parseInt( values[i] )-1;

				// create the inverse permutation
				inv_perm[ perm[i] ] = i;
			}

			// check if permutation and inverse permutation are equal
			for ( int i=0; i < n; i++ )
				if ( perm[i] != inv_perm[i] ) {
					System.out.print("not ");
					break;
				}
			System.out.println("ambiguous");
		}
	}
}
