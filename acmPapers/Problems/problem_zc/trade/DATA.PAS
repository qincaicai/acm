program Data_Trade;
var
	DataNum,N,i,j	:byte;
	M,k,V	:word;
	Remain	:array [1..100,1..100] of boolean;

function NumToStr(n:byte):string;
var
	s	:string;
begin
	Str(n,s);
	while s[0]<#3 do
		insert('0',s,1);
	NumToStr:=s;
end;

begin
	write('Input DataNum,N,M,V: ');
	readln(DataNum,N,M,V);
	assign(output,'input.'+NumToStr(DataNum));
	rewrite(output);
	randomize;
	writeln(N,' ',M);
	fillchar(Remain,sizeof(Remain),true);
	for k:=1 to M do
	begin
		repeat
			i:=random(N)+1;
			j:=random(N)+1;
		until (i<>j) and Remain[i,j];
		writeln(i,' ',j,' ',random(V)+1);
		Remain[i,j]:=false;
		Remain[j,i]:=false;
	end;
	close(output);
end.