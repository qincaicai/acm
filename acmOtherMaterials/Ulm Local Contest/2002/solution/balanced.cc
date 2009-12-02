// Problem   Balanced Food
// Algorithm Backtracking, Mechanics, 2D-Geometry
// Runtime   O(n!)
// Author    Walter Guttmann
// Date      08.05.2000

#include <algorithm>
#include <cassert>
#include <complex>
#include <fstream>

ifstream in ("balanced.in");

typedef complex<double> comp;

int ccw (comp a, comp b, comp c)
{
  double d = real(b-a) * imag(c-a) - real(c-a) * imag (b-a);
  return d < 0 ? -1 : d > 0 ? +1 : 0;
}

const double cPi = 3.14159265358979323846;

comp p, t, u, v, s[16];
double r;
int n, eat[16];
bool used[16];

bool backtrack (int x, comp c)
{
  // finished ?
  if (x == n) return true;
  // falling down ?
  if (ccw(t,u,c) < 0 || ccw(t,v,c) > 0 || abs(c-t) > abs(u-t)) return false;
  // try eating each remaining slice
  for (int i=0 ; i<n ; i++)
    if (!used[i])
    {
      used[i] = true;
      // adjust center of gravity of remaining pizza
      if (backtrack (x+1, (comp(n-x)*c - s[i]) / comp(n-x-1 == 0 ? 1 : n-x-1)))
      {
        eat[x] = i+1;
        return true;
      }
      used[i] = false;
    }
  // didn't succeed
  return false;
}

main ()
{
  while (in >> n)
  {
    if (n == 0) break;
    assert (1 <= n && n <= 10);

    fill_n (used, n, false);
    in >> p >> r >> t >> u >> v;

    // centers of gravity for each slice
    for (int i=0 ; i<n ; i++)
    {
      double a = 2.0 * cPi / n;
      double a1 = a * i;
      double a2 = a * (i+1);
      s[i] = p + comp (sin(a2)-sin(a1), cos(a1)-cos(a2)) * 2.0 * r / 3.0 / a;
    }

    if (backtrack (0, p))
      copy_n (eat, n, ostream_iterator<int> (cout, " "));
    else
      cout << "impossible";
    cout << endl;
  }
  return 0;
}

