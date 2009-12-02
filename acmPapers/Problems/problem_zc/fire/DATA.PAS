program Data_Fire;
var
	DataNum,N,i,j	:byte;
	K,V	:word;
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
	write('Input DataNum,N,K,V: ');
	readln(DataNum,N,K,V);
	assign(output,'input.'+NumToStr(DataNum));
	rewrite(output);
	randomize;
	writeln(N,' ',K);
	for i:=1 to 4 do
	begin
		for j:=1 to N do
		begin
			if j>1 then write(' ');
			write(random(V)+1);
		end;
		writeln;
	end;
	close(output);
end.