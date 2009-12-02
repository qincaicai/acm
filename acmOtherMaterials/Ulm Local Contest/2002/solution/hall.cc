// Problem   Hall of Fountains
// Algorithm Breadth First Search
// Runtime   O(n*lcm(2,4,6,8,10,12,14,16,18,20))
// Author    Walter Guttmann
// Date      07.05.2001

#include <cassert>
#include <fstream>
#include <queue>

ifstream in ("hall.in");

typedef pair<int,int> ipair;

// the system of fountains is in one of lcm(2,4,6,...,18,20) = 5040 states
const int LCM = 5040;
const int OO = 1000000000;

int t[128][8192];

bool on (int p, int q, int t)
{
  assert (t >= 0);
  // special case: out of order
  if (p == 0) return false;
  t %= 2 * p;
  // fountain is on in the range [q ... q+p-1]
  if (q < p)
    return q <= t && t < q+p;
  return q <= t || t < q-p;
}

bool off (int p, int q, int t)
{
  return ! on (p, q, t);
}

int main ()
{
  while (1)
  {
    int n;
    in >> n;
    if (n == 0) break;
    assert (1 <= n && n <= 100);
    int p[128], q[128];
    for (int i=1 ; i<=n ; i++)
      in >> p[i];
    for (int i=1 ; i<=n ; i++)
      in >> q[i];
    for (int i=0 ; i<=n+1 ; i++)
      for (int j=0 ; j<LCM ; j++)
        t[i][j] = OO;
    queue<ipair> que;
    t[0][0] = 0;
    que.push (ipair (0, 0));
    while (! que.empty())
    {
      int i = que.front().first;
      int j = que.front().second;
      if (i > n)
      {
        cout << j << endl;
        break;
      }
      que.pop();
      // step forward, if possible
      if (i <= n)
      {
        if (i == n || off(p[i+1], q[i+1], j+1))
        {
          if (t[i+1][(j+1)%LCM] > j+1)
          {
            t[i+1][(j+1)%LCM] = j+1;
            que.push (ipair (i+1, j+1));
          }
        }
      }
      // stay, if possible
      if (i < 1 || i > n || off(p[i], q[i], j+1))
      {
        if (t[i][(j+1)%LCM] > j+1)
        {
          t[i][(j+1)%LCM] = j+1;
          que.push (ipair (i, j+1));
        }
      }
      // step forward, if possible
      if (i >= 1)
      {
        if (i == 1 || off(p[i-1], q[i-1], j+1))
        {
          if (t[i-1][(j+1)%LCM] > j+1)
          {
            t[i-1][(j+1)%LCM] = j+1;
            que.push (ipair (i-1, j+1));
          }
        }
      }
    }
    if (que.empty())
      cout << 0 << endl;
  }
  return 0;
}

