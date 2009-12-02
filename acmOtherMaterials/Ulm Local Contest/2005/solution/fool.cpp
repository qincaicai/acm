// Problem   Any fool can do it
// Algorithm Memoization
// Runtime   O(n^3)
// Author    Adrian Kuegel
// Date      2005.05.27

#include <iostream>
#include <fstream>
#include <cassert>
#include <string>
using namespace std;

#define MAXLEN 256

/* solve the word problem: is the given word produced by the grammar */

/* for the memoization */
char memo[MAXLEN][MAXLEN];
char memo2[MAXLEN][MAXLEN];

int isList(int,int,char *);

/* this function returns 1 if the substring s[from..to] is a set and 0 otherwise */
int isSet(int from, int to, char *s) {
	// check if result has already been calculated
	if (memo[from][to]>=0)
		return memo[from][to];
	if (from >= to)
		return memo[from][to] = 0;
	// set must have opening and closing bracket
	if (s[from] != '{' || s[to] != '}')
		return memo[from][to] = 0;
	// empty set
	if (from+1 == to)
		return memo[from][to] = 1;
	// inside a set is a list
	return memo[from][to] = isList(from+1,to-1,s);
}

/* this function returns 1 if the substring s[from..to] is an Element and 0 otherwise */
int isElement(int from, int to, char *s) {
	// check if element is an atom
	if (from == to) {
		assert(s[from] == '{' || s[from] == '}' || s[from] == ',');
		return 1;
	}
	// otherwise it must be a set
	return isSet(from,to,s);
}

/* this function returns 1 if the substring s[from..to] is a List and 0 otherwise */
int isList(int from, int to, char *s) {
	// check if result has already been calculated
	if (memo2[from][to]>=0)
		return memo2[from][to];
	// only one element in list
	if (isElement(from,to,s))
		return memo2[from][to] = 1;
	// more than one element in list
	// split in two parts: element and remaining list
	// try all possible splits
	for (int k=from+1; k<to; k++)
		// check for separator
		if (s[k] == ',')
			if (isElement(from,k-1,s) && isList(k+1,to,s))
				return memo2[from][to] = 1;
	return memo2[from][to] = 0;
}

int main() {
	char s[MAXLEN+1];
	ifstream in("fool.in");
	int tc;
	in >> tc;
	for (int scen=1; scen <= tc; scen++) {
		in >> s;
		cout << "Word #" << scen << ": ";
		int len = strlen(s);
		assert(len <= 200);
		// initialize
		for (int i=0; i<len; i++)
			for (int j=i; j<len; j++)
				memo[i][j] = memo2[i][j] = -1;
		if (isSet(0,len-1,s))
			cout << "Set" << endl;
		else
			cout << "No Set" << endl;
	}
	return 0;
}
