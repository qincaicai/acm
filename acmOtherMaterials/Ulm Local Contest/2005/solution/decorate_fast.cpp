// Problem   Decorate the wall
// Algorithm interval compression, scanline
// Runtime   O(n^2)
// Author    Adrian Kuegel
// Date      2005.05.28

#include <iostream>
#include <fstream>
#include <algorithm>
#include <cassert>
#include <map>
#include <vector>
using namespace std;

#define MAXN 256

typedef map<int,int> MII;
typedef vector<int> VI;

int main() {
	int tc;
	ifstream in("decorate.in");
	in >> tc;
	while(tc-- > 0) {
		int n,w,h;
		in >> n >> w >> h;
		assert(n>=0 && n<=200 && w>=1 && h>=1 && w<=1000000 && h<=1000000);
		int x1[MAXN],y1[MAXN],x2[MAXN],y2[MAXN];
		// store all necessary x and y-values in a map
		// note that only boundary coordinates are required
		// The new painting must be bounded at the bottom and the left; otherwise,
		// there would be another position where it fits which is preferred
		MII allx, ally;
		allx[0] = ally[0] = 0;
		allx[w] = ally[h] = 0;
		// read the already hanging paintings
		for (int i=0; i<n; i++) {
			in >> x1[i] >> y1[i] >> x2[i] >> y2[i];
			assert(x1[i]<x2[i] && x1[i]>=0 && x2[i]<=w);
			assert(y1[i]<y2[i] && y1[i]>=0 && y2[i]<=h);
			// assert that there are no overlapping paintings
			for (int j=0; j<i; j++)
				assert(max(x1[i],x1[j])>=min(x2[i],x2[j])
					|| max(y1[i],y1[j])>=min(y2[i],y2[j]));
			// first, assign each coordinate a dummy value
			// later, relabel them in order
			allx[x1[i]] = allx[x2[i]] = 0;
			ally[y1[i]] = ally[y2[i]] = 0;
		}
		int needed_w, needed_h;
		int best_x = w,best_y = h;
		in >> needed_w >> needed_h;
		assert(needed_w > 0 && needed_w <= w && needed_h > 0 && needed_h <= h);
		// now relabel the x-values such that smallest x-value is 0, largest is allx.size()-1
		int label = 0;
		for (MII::iterator it=allx.begin(); it!=allx.end(); it++)
			it->second = label++;
		int neww = label-1;
		// now relabel the y-values such that smallest y-value is 0, largest is ally.size()-1
		label = 0;
		for (MII::iterator it=ally.begin(); it!=ally.end(); it++)
			it->second = label++;
		int newh = label-1;
		assert(neww < MAXN*2+2 && newh < MAXN*2 + 2);
		VI top_of_painting[MAXN*2 + 2];
		for (int i=0; i<n; i++) {
			// use the new labels instead of old y-values
			// for each upper boundary of a painting, store the index of the painting
			top_of_painting[ally[y2[i]]].push_back(i);
		}
		// use a scanline algorithm over y-values in descending order
		MII::iterator cur_height = ally.end();
		// for each x-value, store the y-value of the last time this place was covered
		int last_covered[MAXN*2 + 2];
		for (int i=0; i<=neww; i++)
			last_covered[i] = h;
		for (int i=newh; i>=0; i--) {
			--cur_height;
			// last x-value with required height available
			int last = 0;
			// linear scan through all x-values
			for (MII::iterator it = allx.begin(); it != allx.end();) {
				// check if the required width is available
				if (it->first - last >= needed_w) {
					// update best solution
					if (cur_height->first < best_y || cur_height->first == best_y && last < best_x) {
						best_y = cur_height->first;
						best_x = last;
					}
				}
				int height_available = last_covered[it->second] - cur_height->first;
				it++;
				// if there is not enough height available, update left boundary
				if (height_available<needed_h && it != allx.end())
					last = it->first;
			}
			// insert the ranges of pictures which are beginning at the current height
			for (VI::iterator it = top_of_painting[i].begin(); it != top_of_painting[i].end(); it++) {
				int end = allx[x2[*it]];
				// update last_covered with the value when the painting ends (bottom boundary)
				// since there are only O(n) different x-values in allx, this loop runs in O(n)
				// this loop is executed exactly once for each painting, so overall O(n^2) complexity
				for (int i=allx[x1[*it]]; i<end; i++)
					last_covered[i] = y1[*it];
			}
		}
		if (best_x == w && best_y == h)
			cout << "Fail!" << endl;
		else
			cout << best_x << " " << best_y << endl;
	}
	return 0;
}
