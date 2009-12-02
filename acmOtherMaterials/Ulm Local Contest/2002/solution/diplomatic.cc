// Problem   Diplomatic License
// Algorithm Geometry
// Runtime   O(n)
// Author    Walter Guttmann
// Date      30.05.2002

#include <fstream>

#ifdef VERIFY
#define in cin
#else
ifstream in ("diplomatic.in");
#endif

int main ()
{
  int n;
  while (in >> n)
  {
    double x[n], y[n];
    for (int i=0 ; i<n ; i++)
      in >> x[i] >> y[i];
    cout << n;
    for (int i=0 ; i<n ; i++)
      cout.form (" %f %f", (x[i]+x[(i+1)%n])/2.0, (y[i]+y[(i+1)%n])/2.0);
    cout << endl;
  }
  return 0;
}

