// Problem   Histogram
// Algorithm Recursive
// Runtime   O(n)
// Author    Walter Guttmann
// Date      12.01.2003

#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>

using namespace std;

ifstream in("histogram.in");

double h[1048576], max_area;
int n;

// Let r' be the right-most rectangle such that for all r<=i<=r': low<=h[i].
// Then a call calc_max_area(r, left, low) updates max_area by considering
// the largest rectangles in the histogram in the intervals
// (1) [i..j] where r<=i<=j<=r', and
// (2) [left..j] where r<=j<=r',
// assuming that for all left<=i<=r: h[r]<=h[i], i.e., we can extend any
// rectangle in the interval [r..j] to the interval [left..j] for r<=j<=r'
// without lowering its height. The return value is 1+r'.

int calc_max_area(int r, int left, double low)
{
  assert(left <= r);
  assert(low <= h[r]);
  int next = r+1;
  if (next < n && h[r] < h[next])
    next = calc_max_area(next, next, h[r]+1);
  assert(next == n || h[next] <= h[r]);
  max_area = max(max_area, (next-left)*h[r]);
  return (next == n || h[next] < low) ? next : calc_max_area(next, left, low);
}

int main()
{
  cout.setf(ios::fixed);
  cout.precision(0);
  while (in >> n)
  {
    if (n == 0) break;
    assert(1 <= n && n <= 100000);
    for (int i=0 ; i<n ; i++)
      in >> h[i];
    max_area = 0;
    assert(calc_max_area(0, 0, 0) == n);
    cout << max_area << endl;
  }
  return 0;
}

