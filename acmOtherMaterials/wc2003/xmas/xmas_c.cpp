#include<stdio.h>
#include<stdlib.h>
#include<assert.h>

/* Declarations */
void StartGame(void);
void Rotate(long k);
long Drop(void);

long _started = 0;
long _call;
long _n, _rot;
long _discA[100000];
int	 _real;

void _EndGame(int k)
{
	FILE	*fp;
	if(!_real){
		if(k > 0) printf("Yes!\n");
		else printf("No\n");
	}
	else{
		fp = fopen("xmas.out", "w");
		assert(fp != NULL);
                fprintf(fp, "%d\n", _call);
                fclose(fp);
	}
	exit(0);
}

void _Error(void)
{
	FILE	*fp;
	if(!_real)
		printf("Error\n");
	else{
		fp = fopen("xmas.out", "w");
		assert(fp != NULL);
		fprintf(fp, "-1\n");
    	fclose(fp);
	}
	exit(1);
}

void StartGame(void)
{
	FILE	*fp;
	long	i;

        if(_started) _Error();

	fp = fopen("xmas.in", "r");
	assert(fp != NULL);
	fscanf(fp, "%ld%ld", &_n, &_rot);
	_real = 0;
	if(_rot == -1){
		fscanf(fp, "%ld", &_rot);
		_real = 1;
	}
	for(i = 0; i < _n; i++)
		fscanf(fp, "%ld", &_discA[i]);
	fclose(fp);
	fp = fopen("xmas.dat", "w");
	assert(fp != NULL);
	fprintf(fp, "%ld\n", _n);
	for(i = 0; i < _n; i++)
		fprintf(fp, "%ld ", _discA[i]);
	fprintf(fp, "\n");
	fclose(fp);
	_call = 0;
        _started = 1;
}

void Rotate(long k)
{
        if(!_started) _Error();
        _rot = (_rot + k) % _n;
}

long Drop(void)
{
	long max = -_n;
	long i, v;

        if(!_started) _Error();
	_call++;
	
	for(i = 0; i < _n; i++){
		v = _discA[i] - _discA[(i - _rot + _n) % _n];
		if(v > max) max = v;
	}
	if(max == 0) _EndGame(_call);
        if(_call >= 5) _EndGame(0);
	return max;
}
