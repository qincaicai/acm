// Problem   European railroad tracks
// Algorithm backtracking
// Runtime   O(n^2 * n^(2*n))
// Author    Adrian Kuegel
// Date      2005.05.27

import java.util.*;
import java.io.*;

public class european {
	static StreamTokenizer in;
	static int nextInt() throws IOException {
		if (in.nextToken() != StreamTokenizer.TT_NUMBER)
			throw new RuntimeException("number expected");
		return (int) in.nval;
	}
	public static void main(String [] args) throws IOException {
		in = new StreamTokenizer(new BufferedReader(new FileReader("european.in")));
		int tc = nextInt();
		for(int scen = 1; scen <= tc; scen++) {
			int n = nextInt();
			int [] l = new int[n];
			for( int i = 0 ;i < n; i++ ) {
				l[i] = nextInt();
			}
			int [] left = new int[n];
			int [] right = new int[n];
			int bestcnt = n+1;
			try {
				for (bestcnt=1; bestcnt<=5; bestcnt++)
					backtrack(0,n,l,left,right,bestcnt);
			}catch(Exception e) {}
			System.out.println("Scenario #"+scen);
			System.out.print(bestcnt+":");
			for (int i=0; i<bestcnt; i++)
				for (int j=i+1; j<bestcnt; j++)
					if (solution[j] < solution[i]) {
						int t = solution[j];
						solution[j] = solution[i];
						solution[i] = t;
					}
			for (int i=0; i<bestcnt; i++)
				System.out.print(" "+(solution[i]-solution[0]));
			System.out.println("\n");
		}
	}
	static int[] solution;
	// this function tries to find a solution using "rails" rails
	// if it finds such a solution, it throws an exception
	static void backtrack( int act , int n, int [] l, int [] left, int [] right, int rails) throws Exception {
		if( act == n ) {
			// position of the rails
			int [] tmp = new int[rails];
			int oo = 1000000;
			// initialize to undefined
			for( int i = 0; i < rails; i++ )
				tmp[i] = oo;
			// one rail gets position 0
			tmp[0] = 0;
			for( int i = 0; i < n; i++ ) {
				int cnt = 0;
				for( int j = 0; j < n; j++ ) {
					// if both rails of a gauge have a position, check that the distance is correct
					if( tmp[left[j]] != oo && tmp[right[j]] != oo ) {
						if( tmp[right[j]] != tmp[left[j]] +l[j] ) return;
						cnt++;
					}
					// if the left position is known, assign the right position
					else if( tmp[left[j]] != oo ) {
						tmp[right[j]] = tmp[left[j]] + l[j];
						cnt++;
					}
					// if the right position is known, assign the left position
					else if( tmp[right[j]] != oo ) {
						tmp[left[j]] = tmp[right[j]] - l[j];
						cnt++;
					}
				}
				// all gauges have been found
				if( cnt == n ) {
					solution = tmp;
					throw new Exception("done");
				}
			}
			return;
		}
		// first, assign gauges to rails without assigning any position to the rails
		for( int j = 0; j < rails; j++ )
			for( int k = j+1; k < rails ;k++ ) {
				left[act] = j;
				right[act] = k;
				backtrack( act+1, n, l, left, right, rails);
			}
	}
}