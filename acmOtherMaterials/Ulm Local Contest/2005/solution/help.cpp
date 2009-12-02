// Problem   Help the judge
// Algorithm Depth first search
// Runtime   O(n)
// Author    Adrian Kuegel
// Date      2005.05.29

#include <iostream>
#include <fstream>
#include <cassert>
using namespace std;

#define MAXN 64

int left_child[MAXN],right_child[MAXN];
unsigned long long frequency[MAXN];

/* use a depth first search to calculate sum of frequencies in a substree.
Each node gets as frequency the sum of the frequencies in the
left and right subtree + 1.
This ensures that using another node as root of this subtree increases
the cost by more than could be saved.
*/
unsigned long long dfs(int act) {
	if (act < 0)
		return 0;
	// assertion that there are no cycles
	assert(frequency[act] == 0);
	unsigned long long sum = dfs(left_child[act]) + dfs(right_child[act]);
	frequency[act] = sum + 1;
	return 2 * sum + 1;
}

int main() {
	ifstream in("help.in");
	int n;
	while (in >> n && n > 0) {
		assert(n<=50);
		bool ischild[MAXN] = {false};
		for (int i=0; i<n; i++) {
			frequency[i] = 0;
			in >> left_child[i] >> right_child[i];
			assert(left_child[i] == -1 || left_child[i] > 0 && left_child[i] < i+1);
			assert(right_child[i] == -1 || right_child[i] > i+1 && right_child[i] <= n);
			if (left_child[i]>0) {
				// convert to zero indexed enumeration
				left_child[i]--;
				assert(ischild[left_child[i]] == false);
				ischild[left_child[i]] = true;
			}
			if (right_child[i]>0) {
				// convert to zero indexed enumeration
				right_child[i]--;
				assert(ischild[right_child[i]] == false);
				ischild[right_child[i]] = true;
			}
		}
		int root = -1;
		for (int i=0; i<n; i++)
			if (!ischild[i]) {
				root = i;
				break;
			}
		dfs(root);
		for (int i=0; i<n; i++) {
			assert(frequency[i] > 0);
			if (i)
				cout << " ";
			cout << frequency[i];
		}
		cout << endl;
	}
	assert( n == 0 );
	return 0;
}
