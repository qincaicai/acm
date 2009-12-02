// Problem   Bullshit Bingo
// Algorithm straight-forward
// Runtime   O(n * log(n))
// Author    Adrian Kuegel
// Date      2005.05.27

#include <iostream>
#include <fstream>
#include <cassert>
#include <cctype>
#include <string>
#include <set>
using namespace std;

// calculate greatest common divisor of a and b
int gcd(int a, int b) {
	// if b equals 0, return a
	// else return gcd(b,a%b)
	return b?gcd(b,a%b):a;
}

int main() {
	string line;
	set<string> words;
	int number_of_games = 0, numerator = 0;
	ifstream in("bingo.in");
	bool last_inserted = false;
	while(getline(in,line)) {
		string w = "";
		assert(line.size()<=100);
		// add a "." as sentinel
		line += ".";
		for (int i=0; i<(int)line.size(); i++) {
			// if it is a letter, add to current word
			if (isalpha(line[i]))
				w += toupper(line[i]);
			else {
				// check for end of game
				if (w == "BULLSHIT") {
					number_of_games++;
					assert(words.size()>=4);
					assert(last_inserted);
					numerator += words.size();
					words.clear();
				}
				// otherwise insert the word into the set of different words
				else if (w.size()>0) {
					assert(w.size()<=25);
					if (words.find(w) == words.end()) {
						words.insert(w);
						last_inserted = true;
					}
					else
						last_inserted = false;
				}
				w = "";
			}
		}
	}
	int t = gcd(numerator, number_of_games);
	cout << numerator/t << " / " << number_of_games/t << endl;
	return 0;
}
