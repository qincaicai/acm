// Problem   Let it Bead
// Algorithm Brute Force, Generating Group of Movements
// Runtime   O(c^s * s^2)
// Author    Walter Guttmann
// Date      24.11.1999

#include <algorithm>
#include <cassert>
#include <fstream>

ifstream in ("bead.in");

const int maxn = 65536;
static bool used[maxn];

void decode (int x, int c, int s, int *a)
{
  for (int k=0 ; k<s ; k++)
  {
    a[s-k-1] = x % c;
    x /= c;
  }
}

int encode (int c, int s, int *a)
{
  int x = 0;
  for (int k=0 ; k<s ; k++)
  {
    x *= c;
    x += a[k];
  }
  return x;
}

main ()
{
  int c, s;
  while (in >> c >> s)
  {
    if (c == 0 || s == 0) break;
    assert (1 <= c && 1 <= s && c * s <= 32);

    // n = c^s
    int n = 1;
    for (int k=0 ; k<s ; k++)
      n *= c;
    assert (n <= maxn);
    fill_n (used, n, false);

    int a[32], b[32];
    // count representatives
    int count = 0;
    for (int i=0 ; i<n ; i++)
      if (! used[i])
      {
        ++count;
        decode (i, c, s, a);
        reverse_copy (a, a+s, b);
        // rotate
        for (int k=0 ; k<s ; k++)
        {
          used[encode (c, s, a)] = true;
          rotate (a, a+1, a+s);
          // flip
          used[encode (c, s, b)] = true;
          rotate (b, b+1, b+s);
        }
      }

    cout << count << endl;
  }
  return 0;
}

