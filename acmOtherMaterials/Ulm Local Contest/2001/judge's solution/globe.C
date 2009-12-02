// Problem   Global Roaming
// Algorithm 3D-Geometry
// Runtime   O(n)
// Author    Marc Meister
// Date      02.07.2001

#include <fstream>
#include <string>
#include <cmath>

using namespace std;

typedef struct pos {
  double x, y, z;
} tPos;

#define EarthR 6378.0

ifstream in("globe.in");

tPos polar2cartesian(double lat, double lon, double r) {
  tPos p;
  lat *= atan(1.0)/45.0;
  lon *= atan(1.0)/45.0;
  p.x = r * cos(lon) * cos(lat);
  p.y = r * sin(lon) * cos(lat);
  p.z = r * sin(lat);
  return p;
}

int main() {
  double lat, lon, r;
  for (int kase = 1; ; kase++){
    int n;
    in >> n >> lat >> lon >> r;
    if (!n)
      break;
    cout << "Test case " << kase << ":" << endl;
    tPos p1 = polar2cartesian(lat, lon, r + EarthR);
    for (int i=0; i<n; i++) {
      string s;
      in >> s >> lat >> lon;
      tPos p2 = polar2cartesian(lat, lon, EarthR);
      if ( (p1.x-p2.x)*p2.x + (p1.y-p2.y)*p2.y + (p1.z-p2.z)*p2.z > 0.0)
        cout << s << endl;
    }
    cout << endl;
  }
  return 0;
}

