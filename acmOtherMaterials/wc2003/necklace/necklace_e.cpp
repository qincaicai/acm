#include<stdio.h>

/*
  Parameters:  .in  .out  .ans
  Eval: 
  - first line:  score
  - second line: message
*/

void main(int argc, char * argv[])
{
	FILE *out, *ans, *eval;
	int score;
	int ans1, ans2;

	out = fopen(argv[1], "r");
	ans = fopen(argv[2], "r");
	eval = fopen("/tmp/_eval.score", "w");
	if(out == NULL){
		fprintf(eval, "0\nOutput file not found!\n");
		fclose(eval);
	}else{
		fscanf(out, "%d", &ans1);
		fscanf(ans, "%d", &ans2);
		if(ans1 == ans2)
			fprintf(eval, "10\nCorrect!\n");
		else
			fprintf(eval, "0\nWrong Answer!");
		fclose(eval);
	}
        fclose(out);
        fclose(ans);
}
