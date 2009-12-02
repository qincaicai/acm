// Problem   Polygon Programming with Ease
// Algorithm Geometry
// Runtime   O(n)
// Author    Walter Guttmann
// Date      30.05.2002

#include <fstream>

#ifdef VERIFY
#define in cin
#else
ifstream in ("ease.in");
#endif

int main ()
{
  int n;
  while (in >> n)
  {
    double x[n], y[n];
    for (int i=0 ; i<n ; i++)
      in >> x[i] >> y[i];
    double xx = x[0], yy = y[0];
    for (int i=0 ; i<n ; i++)
      xx = x[i] + (x[i] - xx), yy = y[i] + (y[i] - yy);
    xx = (x[0] + xx) / 2.0, yy = (y[0] + yy) / 2.0;
    cout << n;
    for (int i=0 ; i<n ; i++)
      cout.form (" %f %f", xx, yy),
      xx = x[i] + (x[i] - xx), yy = y[i] + (y[i] - yy);
    cout << endl;
  }
  return 0;
}

