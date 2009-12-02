// Problem   Phylogenetic Trees Inherited
// Algorithm Dynamic Programming
// Runtime   O(n * l)
// Author    Walter Guttmann
// Date      12.01.2000

#include <cassert>
#include <fstream>

ifstream in ("genetic.in");

static char seq[1024][1024];

main (int argc, char** argv)
{
  assert (argc >= 1);
  ifstream out (argv[1]);
  assert (! out.fail());

  int heap[2048], n, l;
  while (in >> n >> l)
  {
    if (n == 0 || l == 0) break;
    for (int k=0 ; k<n ; k++)
      in >> seq[k];
    int cost = 0;
    for (int i=0 ; i<l ; i++)
    {
      for (int k=0 ; k<n ; k++)
        heap[n+k] = 1 << (seq[k][i] - 'A');
      for (int k=n-1 ; k>0 ; k--)
        if (! (heap[k] = heap[k+k] & heap[k+k+1]))
          ++cost, heap[k] = heap[k+k] | heap[k+k+1];
      // char ch = 'A';
      // while (heap[1]>>=1) ++ch;
      // cout << ch;
      char outCh;
      assert (out >> outCh);
      assert ('A' <= outCh && outCh <= 'Z');
      assert ((heap[1] >> (outCh - 'A')) & 1);
    }
    // cout << ' ' << cost << endl;
    int outCost;
    assert (out >> outCost >> ws);
    assert (outCost == cost);
  }
  assert ((out >> ws).eof());
  return 0;
}

