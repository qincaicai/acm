// Problem   Decode the Tree
// Algorithm Priority Queue, Adjacency Lists
// Runtime   O(n*log(n))
// Author    Walter Guttmann
// Date      09.05.2001

#include <cassert>
#include <fstream>
#include <queue>
#include <string>
#include <strstream>
#include <vector>

ifstream in ("decode.in");

typedef vector<int> ivec;
typedef vector<ivec> imat;

// recursive-descent tree pretty printer
// assumes numeration from 1 .. n (for root only: p=0)
void print (imat &adj, int x, int p = 0)
{
  cout << "(" << x;
  for (ivec::iterator it = adj[x].begin() ; it != adj[x].end() ; ++it)
    if (*it != p)
    {
      cout << " ";
      print (adj, *it, x);
    }
  cout << ")";
}

int main ()
{
  string line;
  while (getline (in, line))
  {
    istrstream lstr (line.c_str());
    ivec v;
    int x;
    while (lstr >> x)
      v.push_back (x);
    int n = v.size() + 1;
    // count downward degree of each node, and find leafs
    ivec deg (n+1, 0);
    for (int i=0 ; i<n-1 ; i++)
      deg[v[i]]++;
    priority_queue< int,ivec,greater<int> > leafs;
    for (int i=1 ; i<=n ; i++)
      if (deg[i] == 0)
        leafs.push (i);
    // reconstruct the adjacency list representation of the tree
    imat adj (n+1, ivec ());
    for (int i=0 ; i<n-1 ; i++)
    {
      // all the numbers that don't occur in v[i..n-2] are leafs
      // the smallest such number will be processed now
      assert (! leafs.empty());
      x = leafs.top();
      leafs.pop();
      // v[i] is the adjacent node of x
      adj[x].push_back (v[i]);
      adj[v[i]].push_back (x);
      if (--deg[v[i]] == 0)
        leafs.push (v[i]);
    }
    print (adj, n);
    cout << endl;
  }
  return 0;
}

