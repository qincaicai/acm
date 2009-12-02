// Problem   106 miles to Chicago
// Algorithm Floyd Warshall
// Runtime   O(n^3)
// Author    Adrian Kuegel
// Date      2005.05.28

#include <iostream>
#include <fstream>
#include <algorithm>
#include <cassert>
using namespace std;

#define MAXN 128

int main() {
	int n, m;
	ifstream in("chicago.in");
	while(in >> n && n != 0) {
		assert(n >= 2 && n <= 100);
		in >> m;
		assert(m >= 1 && m <= n*(n-1)/2);
		double prob[MAXN][MAXN] = {{0}};
		while(m--) {
			int a,b,p;
			in >> a >> b >> p;
			assert(a>=1 && a<=n && b>=1 && b<=n && a != b && p>=1 && p<=100);
			a--;
			b--;
			// transform into a value between 0.01 and 1.0
			assert(prob[a][b] == 0.0);
			prob[a][b] = prob[b][a] = 0.01*p;
		}
		// use modified floyd warshall to calculate the probability of the safest path
		for (int mid = 0; mid < n; mid++)
			for (int from = 0; from < n; from++) {
				// if there is no path from "from" to "mid", ignore street
				if (prob[from][mid] == 0.0)
					continue;
				for (int to = 0; to < n; to++)
					prob[from][to] = max(prob[from][to],prob[from][mid] * prob[mid][to]);
			}
		assert(prob[0][n-1] > 0);
		// transform back into percent
		prob[0][n-1] *= 100;
		cout.setf(ios::fixed);
		cout.precision(6);
		cout << prob[0][n-1] << " percent" << endl;
	}
	assert(n == 0);
	return 0;
}
