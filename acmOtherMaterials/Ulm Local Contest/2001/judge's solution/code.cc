// Problem   Code the Tree
// Algorithm Recursive Descent Parser, Priority Queue, Adjacency Sets
// Runtime   O(n*log(n))
// Author    Walter Guttmann
// Date      09.05.2001

#include <cassert>
#include <fstream>
#include <queue>
#include <set>
#include <vector>

#ifdef VERIFY
#define in cin
#else
ifstream in ("code.in");
#endif

typedef set<int> iset;
typedef vector<iset> imat;

// assume that the leading '(' has already been parsed
void parse (imat &adj, unsigned int p = 0)
{
  unsigned int x;
  assert (in >> ws >> x);
  if (p)
  {
    // do this for all nodes but the root
    assert (0 <= p && p < adj.size());
    assert (0 <= x && x < adj.size());
    adj[p].insert (x);
    adj[x].insert (p);
  }
  while (1)
  {
    char ch;
    assert (in >> ws >> ch);
    if (ch == ')') break;
    assert (ch == '(');
    parse (adj, x);
  }
}

int main ()
{
  while (1)
  {
    imat adj (1024, iset());
    char ch;
    if (! (in >> ws >> ch)) break;
    assert (ch == '(');
    parse (adj);
    // gather all leafs
    priority_queue< int,vector<int>,greater<int> > leafs;
    int n = 0;
    for (unsigned int i=0 ; i<adj.size() ; i++)
      if (adj[i].size())
      {
        n++;
        if (adj[i].size() == 1)
          leafs.push (i);
      }
    // compute the Prufer code
    for (int k=1 ; k<n ; k++)
    {
      assert (! leafs.empty());
      unsigned int x = leafs.top();
      leafs.pop();
      // find adjacent node
      assert (0 <= x && x < adj.size());
      assert (adj[x].size() == 1);
      unsigned int p = *(adj[x].begin());
      if (k > 1)
        cout << " ";
      cout << p;
      // remove link from adjacent node to this node
      assert (0 <= p && p < adj.size());
      adj[p].erase(x);
      // check if adjacent node is a leaf node now
      if (adj[p].size() == 1)
        leafs.push (p);
    }
    cout << endl;
  }
  return 0;
}

