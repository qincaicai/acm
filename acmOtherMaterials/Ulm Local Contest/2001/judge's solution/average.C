// Problem   Average is not Fast Enough!
// Algorithm Straight-Forward
// Runtime   O(n)
// Author    Marc Meister
// Date      08.06.2001

#include <fstream>
#include <string>

#define A(x) (x-'0')

ifstream in("average.in");

int main() {
  int n;
  double d;
  in >> n >> d;
  for (int team; in >>team; ) {
    int t = 0;
    bool dsq = false;
    for (int i=0; i<n; i++) {
      string s;
      in >> s;
      if (s[0] != '-')
	t += A(s[0])*3600 + A(s[2])*600 + A(s[3])*60 + A(s[5])*10 + A(s[6]);
      else
	dsq = true;
    }    
    cout.form ("%3d: ", team);
    if (dsq)
      cout << "-\n" ;
    else {
      t = (int)((double)t/d+0.5); 
      cout.form ("%d:%.2d min/km\n", t/60, t%60);
    }
  }
  return 0;
}

