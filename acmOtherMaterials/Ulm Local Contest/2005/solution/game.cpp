// Problem   Game schedule required
// Algorithm greedy
// Runtime   O(n^2)
// Author    Adrian Kuegel
// Date      2005.05.24

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cassert>
#include <cctype>
#include <algorithm>

using namespace std;

#define MAXN 1024

typedef vector<int> VI;
VI adj[MAXN];

int main() {
	int n;
	ifstream in("game.in");
	while(in >> n && n!=0) {
		assert(n>0 && n<=1000);
		// read name of all teams
		string tnames[MAXN];
		for (int i=0; i<n; i++) {
			in >> tnames[i];
			assert(tnames[i].size() <= 25);
			for (int j=0; j<(int)tnames[i].size(); j++)
				assert(isalpha(tnames[i][j]));
			// check that names are different
			for (int j=0; j<i; j++)
				assert(tnames[i] != tnames[j]);
			adj[i].clear();
		}
		sort(tnames,tnames+n);

		// read the games and build an adjacency graph
		for (int i=1; i<n; i++) {
			string team1,team2;
			in >> team1 >> team2;
			int a = distance(tnames,lower_bound(tnames,tnames+n,team1));
			int b = distance(tnames,lower_bound(tnames,tnames+n,team2));
			assert(a>=0 && a<n && b>=0 && b<n && a!=b);
			adj[a].push_back(b);
			adj[b].push_back(a);
		}
		int rem = n;
		int round = 0;
		bool eliminated[MAXN] = {false},used[MAXN];

		// while number of remaining teams > 1
		while(rem>1) {
			// In each round, there must be n div 2 teams which will be eliminated from the tournament.
			// Obviously, only teams with one remaining game are candidates for elimination.
			// If there are an even number of teams in this round, each team to be eliminated gets exactly
			// one opponent. However with an odd number of teams, one team has to get a wildcard.
			// A team which gets a wildcard could have only one remaining game,
			// and still won't be eliminated in this round. But in that case, there must be a
			// conflict in the selection of opponents for each such team (there are only n div 2
			// opponents, but n div 2 + 1 teams require an opponent which eliminates them.
			// This conflict is resolved by giving either of the two teams requesting this opponent
			// the wildcard. If there is no such conflict, give the wildcard to the team which has no
			// game scheduled in the current round.

			for (int i=0; i<n; i++)
				used[i] = eliminated[i];
			int wildcard = -1, n_eliminated = 0;
			cout << "Round #" << ++round << endl;
			for (int i=0; i<n; i++) {
				if (used[i])
					continue;
				// if only one game for a team is left, the team could be eliminated in this round
				if (adj[i].size() == 1) {
					int opponent = adj[i][0];
					// check for conflict -> is resolved by giving one of the teams a wildcard
					if (used[opponent]) {
						wildcard = i;
						used[i] = true;
						continue;
					}
					used[i] = used[opponent] = true;
					cout << tnames[opponent] << " defeats " << tnames[i] << endl;
					eliminated[i] = true;
					n_eliminated++;
					// delete eliminated team from play list of opponent
					// there are O(n) entries in all adjacency list
					// each deletion takes O(n) time -> overall O(n^2) time
					for (VI::iterator it=adj[opponent].begin(); it!=adj[opponent].end(); it++)
						if (*it == i) {
							adj[opponent].erase(it);
							break;
						}
				}
			}
			// check if a wildcard is needed in this round
			if (rem%2 != 0) {
				// if wildcard is still available, it is given to a team that does not have a game in this round
				for (int i=0; i<n && wildcard<0; i++)
					if (!used[i])
						wildcard = i;
				assert(wildcard>=0);
				cout << tnames[wildcard] << " advances with wildcard" << endl;
			}
			assert(n_eliminated == rem/2);
			rem = (rem+1)/2;
		}
		for (int i=0; i<n; i++)
			if (!eliminated[i]) {
				cout << "Winner: " << tnames[i] << endl;
				break;
			}
		cout << endl;
	}
	assert( n == 0 );
	return 0;
}
