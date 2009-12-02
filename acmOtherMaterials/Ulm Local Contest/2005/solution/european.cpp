// Problem   European railroad tracks
// Algorithm backtracking
// Runtime   O(2^n * (n!)^2)
// Author    Adrian Kuegel
// Date      2005.05.27

#include <iostream>
#include <fstream>
#include <cassert>
#include <set>
using namespace std;

#define MAXN 8

int best;
set<int> solution;

void backtrack(int n, int tracks, set<int> &positions, int required[MAXN]) {
	if (tracks >= best)
		return;
	bool stop = true;
	// first check if one length is already covered by selected positions
	for (int i=1; i<n; i++) {
		if (!required[i])
			continue;
		stop = false;
		int old = required[i];
		for (set<int>::iterator it=positions.begin(); it!=positions.end(); it++) {
			if (positions.find(*it+old) != positions.end() || positions.find(*it-old) != positions.end()) {
				required[i] = 0;
				backtrack(n, tracks, positions, required);
				required[i] = old;
				return;
			}
		}
	}
	// if no required length is left, update best result and return
	if (stop) {
		best = tracks;
		solution = positions;
		return;
	}
	// if not, place another rail track
	// brute force over remaining lengths
	for (int i=1; i<n; i++) {
		if (!required[i])
			continue;
		int old = required[i];
		required[i] = 0;
		// place track in required distance of an old track
		for (set<int>::iterator it=positions.begin(); it!=positions.end(); it++) {
			positions.insert(*it+old);
			backtrack(n, tracks+1, positions, required);
			positions.erase(*it+old);
			positions.insert(*it-old);
			backtrack(n, tracks+1, positions, required);
			positions.erase(*it-old);
		}
		required[i] = old;
	}
}

int main() {
	int tc;
	ifstream in("european.in");
	in >> tc;
	for (int scen=1; scen<=tc; scen++) {
		cout << "Scenario #" << scen << endl;

		int n, required[MAXN];
		in >> n;
		assert(n >= 1 && n <= 8);
		solution.clear();
		solution.insert(0);
		for (int i=0; i<n; i++) {
			in >> required[i];
			assert(required[i]>=1000 && required[i]<=5000);
			solution.insert(required[i]);
		}
		set<int> positions;
		positions.insert(0);
		positions.insert(required[0]);
		required[0] = 0;
		best = n+1;
		backtrack(n, 2, positions, required);
		assert(best<=n+1 && best == solution.size());
		cout << best << ":";
		int offset = *(solution.begin());
		for (set<int>::iterator it = solution.begin(); it!=solution.end(); it++)
			cout << " " << *it-offset;
		cout << endl << endl;
	}
	return 0;
}
