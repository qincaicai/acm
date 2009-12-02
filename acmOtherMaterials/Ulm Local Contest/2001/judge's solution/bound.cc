// Problem   Bound Found
// Algorithm Partial Sums, Sort, Two Pointers
// Runtime   O(n*log(n))
// Author    Walter Guttmann
// Date      16.10.1999

#include <algorithm>
#include <cassert>
#include <fstream>

ifstream in ("bound.in");

static int seq[131072], psum[131072], perm[131072];

bool psum_cmp (const int a, const int b)
{
  return (psum[a] <= psum[b]);
}

int main ()
{
  int n, k;
  while (in >> n >> k)
  {
    if (n == 0) break;
    assert (1 <= n && n <= 100000);

    // read sequence
    for (int i = 0 ; i < n ; i++)
      in >> seq[i];
    for (int i = 0 ; i < n ; i++)
      assert (-10000 <= seq[i] && seq[i] <= 10000);

    // calculate partial sums (of which there are n+1)
    psum[0] = 0;
    for (int i = 0 ; i < n ; i++)
      psum[i+1] = psum[i] + seq[i];

    // sort partial sums indirectly
    for (int i = 0 ; i <= n ; i++)
      perm[i] = i;
    sort (perm, perm+n+1, psum_cmp);

    while (k--)
    {
      int t;
      in >> t;
      assert (0 <= t && t <= 1000000000);

      // optimal result in range [0..p2]
      int bestT = psum[perm[1]] - psum[perm[0]];
      int bestLo = perm[0];
      int bestHi = perm[1];

      // walk sorted partial sums with two pointers
      int p1 = 0;
      int p2 = 1;
      while (p2 <= n)
      {
        assert (p1 < p2);
        int sum = psum[perm[p2]] - psum[perm[p1]];
        assert (sum >= 0);
        // update optimal subvector
        if (abs (sum - t) < abs (bestT - t))
        {
          bestT = sum;
          bestLo = perm[p1];
          bestHi = perm[p2];
        }
        // update pointers ; don't let the subvector get empty
        if (p1 + 1 == p2 || sum < t)
          p2++;
        else
          p1++;
      }

      // pay attention to the bounds of the subvector
      cout << bestT << " " << min (bestLo, bestHi) + 1 << " "
           << max (bestLo, bestHi) << endl;
    }
  }
  return 0;
}

