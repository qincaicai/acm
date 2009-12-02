// Problem   Any fool can do it
// Algorithm CYK
// Runtime   O(n^3)
// Author    Adrian Kuegel
// Date      2005.05.26

#include <iostream>
#include <fstream>
#include <cassert>
#include <string>
using namespace std;

/* Chomsky Normal Form of the given grammar:

# 1. start rule
S -> OB
# empty set rule
S -> OP

# 2. opening bracket of a set
O -> {

# 3. closing bracket of a set
P -> }

# 4. separator of elements in a set
K -> ,

# 5. closes a set
B -> CP
# rule for only one element in list
B -> DP

# 6. rules for List
C -> DE
# 7. continue list
E -> KC
# end of a list
E -> KD

# 8. rules for Element
# open new set
D -> OB
# empty set rule
D -> OP
# atom
D -> {
D -> }
D -> ,

*/

#define MAXLEN 256
#define NRULES 9

/* solve the word problem: is given word produced by the grammar */

/* for the memoization */
int memo[MAXLEN][MAXLEN];

/* this function returns the variables of the grammar encoded as a bitmask which produce
the substring s[from] to s[to]
The k-th bit is set to 1 if the k-th variable produces the substring.
Variables are numbered in the order in which they are defined above. */

int producedBy(int from, int to, char *s, int rules[NRULES][3]) {
	if (memo[from][to]>=0)
		return memo[from][to];
	if (from == to) {
		assert(s[from] == '{' || s[from] == '}' || s[from] == ',');
		if (s[from] == '{')
			// this character is either produced by variable O or D
			return memo[from][from] = (1<<1) | (1<<7);
		if (s[from] == '}')
			// this character is either produced by variable P or D
			return memo[from][from] = (1<<2) | (1<<7);
		if (s[from] == ',')
			// this character is either produced by variable K or D
			return memo[from][from] = (1<<3) | (1<<7);
		// this should not happen
		assert(0);
	}
	int mask = 0;
	for (int mid = from; mid<to; mid++) {
		int leftSideVariables = producedBy(from,mid,s,rules);
		int rightSideVariables = producedBy(mid+1,to,s,rules);
		// check if some rule can be applied
		// note that only rules of the form A -> BC have to be considered here
		// rules use the same bit encoding
		// rules[i][0] -> rules[i][1] rules[i][2]
		// see initialization routine for details
		for (int i=0; i<NRULES; i++)
			if ((rules[i][1]&leftSideVariables)!=0 && (rules[i][2]&rightSideVariables)!=0)
				mask |= rules[i][0];
	}
	return memo[from][to] = mask;
}

/* this function initializes the rules using the bit-encoding for the variables involved. */
void initRules(int rules[9][3]) {
	// S -> OB
	rules[0][0] = (1<<0);
	rules[0][1] = (1<<1);
	rules[0][2] = (1<<4);

	// S -> OP
	rules[1][0] = (1<<0);
	rules[1][1] = (1<<1);
	rules[1][2] = (1<<2);

	// B -> CP
	rules[2][0] = (1<<4);
	rules[2][1] = (1<<5);
	rules[2][2] = (1<<2);

	// B -> DP
	rules[3][0] = (1<<4);
	rules[3][1] = (1<<7);
	rules[3][2] = (1<<2);

	// C -> DE
	rules[4][0] = (1<<5);
	rules[4][1] = (1<<7);
	rules[4][2] = (1<<6);

	// E -> KC
	rules[5][0] = (1<<6);
	rules[5][1] = (1<<3);
	rules[5][2] = (1<<5);

	// E -> KD
	rules[6][0] = (1<<6);
	rules[6][1] = (1<<3);
	rules[6][2] = (1<<7);

	// D -> OB
	rules[7][0] = (1<<7);
	rules[7][1] = (1<<1);
	rules[7][2] = (1<<4);

	// D -> OP
	rules[8][0] = (1<<7);
	rules[8][1] = (1<<1);
	rules[8][2] = (1<<2);
}

int main() {
	int rules[NRULES][3], tc;
	initRules(rules);
	char s[MAXLEN+1];
	ifstream in("fool.in");
	in >> tc;
	for (int scen=1; scen <= tc; scen++) {
		in >> s;
		cout << "Word #" << scen << ": ";
		int len = strlen(s);
		assert(len <= 200);
		// initialize
		for (int i=0; i<len; i++)
			for (int j=i; j<len; j++)
				memo[i][j] = -1;
		int variables = producedBy(0,len-1,s,rules);
		if (variables & 1)
			cout << "Set" << endl;
		else
			cout << "No Set" << endl;
	}
	return 0;
}
