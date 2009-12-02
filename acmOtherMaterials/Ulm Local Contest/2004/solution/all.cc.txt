// Problem   All Discs Considered
// Algorithm Breadth First Search
// Runtime   O(n)
// Author    Walter Guttmann
// Date      2004.06.06

#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>
#include <queue>
#include <vector>

using namespace std;

ifstream in("all.in");

typedef queue<int> qi;
typedef vector<int> vi;
typedef vector<vi> vvi;

int simulate(int current, vi ndeps, const vvi deps, int n1, int n2)
{
  assert(current == 0 || current == 1);
  // dvd[i] = packages on DVD i that may be installed
  qi dvd[2];
  for (int i=1 ; i<=n1+n2 ; i++)
    if (ndeps[i] == 0)
      dvd[i>n1?1:0].push(i);
  // insert current DVD
  int steps = 1;
  while (!dvd[0].empty() || !dvd[1].empty())
  {
    // install packages from current DVD
    while (!dvd[current].empty())
    {
      int p = dvd[current].front();
      dvd[current].pop();
      // update packages that depend on p
      for (vi::const_iterator it = deps[p].begin() ; it != deps[p].end() ; ++it)
        if (--ndeps[*it] == 0)
          // package *it may now be installed
          dvd[*it>n1?1:0].push(*it);
    }
    // remove/change current DVD
    current ^= 1;
    ++steps;
  }
  return steps;
}

int main()
{
  while (1)
  {
    int n1, n2, d;
    in >> n1 >> n2 >> d;
    if (n1 == 0 && n2 == 0 && d == 0) break;
    assert(1 <= n1 && n1 <=  50000);
    assert(1 <= n2 && n2 <=  50000);
    assert(0 <= d  && d  <= 100000);
    // ndeps[i] = the number of packages that package i depends on
    vi ndeps(n1+n2+1);
    // deps[i] = the packages that depend on package i
    vvi deps(n1+n2+1);
    for (int i=0 ; i<d ; i++)
    {
      int x, y;
      in >> x >> y;
      ndeps[x]++;
      deps[y].push_back(x);
    }
    // either start with DVD 0 or with DVD 1
    cout << min(simulate(0, ndeps, deps, n1, n2),
                simulate(1, ndeps, deps, n1, n2)) << endl;
  }
  return 0;
}

