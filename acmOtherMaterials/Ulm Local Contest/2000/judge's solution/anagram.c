// Problem   Anagram Groups
// Algorithm Equivalence Relation, Sort
// Runtime   O(n log(n))
// Author    Walter Guttmann
// Date      31.07.1999

#include <algorithm>
#include <fstream>
#include <map>
#include <set>
#include <string>

ifstream in ("anagram.in");

typedef multiset<string> strset;
typedef map<string,strset> strsetmap;

typedef pair<int,string> intstr;
typedef map<intstr,string> intstrmap;

main ()
{
  // read and split to equivalence classes
  strsetmap group;
  string s;
  while (in >> s)
  {
    // find representative
    string sorted = s;
    sort (sorted.begin(), sorted.end());
    group[sorted].insert (s);
  }

  // sort in order of group size and smallest member
  intstrmap gsize;
  for (strsetmap::iterator it = group.begin() ; it != group.end() ; ++it)
  {
    // larger groups come first, if group sizes are negative
    intstr p ( - it->second.size() , * it->second.begin() );
    gsize[p] = it->first;
  }

  // maximal number of groups output
  int count = 5;
  for (intstrmap::iterator it = gsize.begin() ; it != gsize.end() ; ++it)
  {
    if (count-- == 0) break;
    cout << "Group of size " << - it->first.first << ": ";

    // output unique members of classes in sorted order
    unique_copy (group[it->second].begin(), group[it->second].end(),
      ostream_iterator<string> (cout, " "));
    cout << "." << endl;
  }

  return 0;
}

