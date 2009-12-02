// Problem   Equidistance
// Algorithm 3D-Geometry
// Runtime   O(n^2)
// Author    Walter Guttmann
// Date      26.04.2000

#include <cmath>
#include <fstream>
#include <string>

ifstream in ("equidist.in");

const double cPi = 3.14159265358979323846;
const double cRad = 6378.0;

string name[128];
double lat[128], lon[128], xxx[128], yyy[128], zzz[128];
int nloc = 0;

double rad (double x)
{
  return x * cPi / 180.0;
}

int index (string s)
{
  int i;
  for (i=0 ; i<nloc ; i++)
    if (name[i] == s)
      break;
  return i;
}

main ()
{
  cout.setf (ios::fixed);
  cout.precision (0);
  while (in >> name[nloc])
  {
    if (name[nloc] == "#") break;
    in >> lat[nloc] >> lon[nloc];
    // conversion from polar to orthonormal coordinates
    xxx[nloc] = cos (rad (lat[nloc])) * sin (rad (lon[nloc]));
    yyy[nloc] = cos (rad (lat[nloc])) * cos (rad (lon[nloc]));
    zzz[nloc] = sin (rad (lat[nloc]));
    ++nloc;
  }
  string sa, sb, sm;
  while (in >> sa)
  {
    if (sa == "#") break;
    in >> sb >> sm;
    int a = index (sa);
    int b = index (sb);
    int m = index (sm);
    if (a >= nloc || b >= nloc || m >= nloc)
    {
      cout << sm << " is ? km off "
           << sa << "/" << sb << " equidistance." << endl;
      continue;
    }
    // normal vector on equidistance plane
    double nx = xxx[a] - xxx[b];
    double ny = yyy[a] - yyy[b];
    double nz = zzz[a] - zzz[b];
    if (nx == 0.0 && ny == 0.0 && nz == 0.0)
    {
      cout << sm << " is 0 km off "
           << sa << "/" << sb << " equidistance." << endl;
      continue;
    }
    // angle between meeting point and normal vector
    double an = acos ((xxx[m] * nx + yyy[m] * ny + zzz[m] * nz)
              / sqrt (nx*nx + ny*ny + nz*nz));
    // angle between meeting point and equidistance plane
    double ap = fabs (0.5 * cPi - an);
    // distance on earth's surface
    double dist = ap * cRad;
    cout << sm << " is " << dist << " km off "
         << sa << "/" << sb << " equidistance." << endl;
  }
  return 0;
}

