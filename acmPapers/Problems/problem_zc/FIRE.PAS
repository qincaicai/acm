{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V-,X+,Y+}
{$M 16384,0,655360}
program FireOfTheArtGallery;
const
	MaxN=100;	{N的上限}
type
	TPrevious=array [0..100,0..100] of	{保存方案信息的类型}
		record
			k,	{由5个式子的哪一个计算而得}
			t	:byte;	{决策变量t}
		end;
	TBest=array [0..100,0..100] of longint;	{最优值函数F的类型}
var
	N,			{矩阵每行的元素数N}
	K	:byte;	{子矩阵个数K}
	Value	:array [1..2,1..MaxN] of integer;	{矩阵W即矩阵V-矩阵F}
	Best	:array [0..1] of ^TBest;			{最优值函数F}
	Prev	:array [0..10] of ^TPrevious;	{保存方案信息}

procedure ReadIn;	{读如}
var
	i,j	:byte;
	t	:integer;
begin
	reset(input);
	readln(N,K);
	for i:=2 downto 1 do
	begin
		for j:=1 to N do
			read(Value[i,j]);	{此时读入的是矩阵V}
		readln;
	end;
	for i:=2 downto 1 do
	begin
		for j:=1 to N do
		begin
			read(t);				{矩阵F的(i,j)元素}
			dec(Value[i,j],t);	{对应相减得矩阵W}
		end;
		readln;
	end;
	close(input);
end;

procedure Work;	{规划主过程}
var
	s,i,j,t	:shortint;
	sum	:longint;
begin
	new(Best[0]); new(Best[1]);
	fillchar(Best[0]^,sizeof(Best[0]^),0);	{边界条件}
	new(Prev[0]);
	fillchar(Prev[0]^,sizeof(Prev[0]^),0);
	for s:=1 to K do	{阶段变量循环}
	begin
		new(Prev[s]);
		for i:=0 to N do
			for j:=0 to N do	{状态变量循环}
			begin
				Best[s and 1]^[i,j]:=0;
				Prev[s]^[i,j].k:=0;
				{下面分别计算规划方程中的五个式子}
				if (i>0) and (Best[s and 1]^[i-1,j]<Best[s and 1]^[i,j]) then
				begin	{第一个}
					Best[s and 1]^[i,j]:=Best[s and 1]^[i-1,j];
					Prev[s]^[i,j].k:=1;
				end;
				if (j>0) and (Best[s and 1]^[i,j-1]<Best[s and 1]^[i,j]) then
				begin	{第二个}
					Best[s and 1]^[i,j]:=Best[s and 1]^[i,j-1];
					Prev[s]^[i,j].k:=2;
				end;
				sum:=0;
				if i>j
				then for t:=i-1 downto 0 do	{第三个}
					begin
						inc(sum,Value[1,t+1]);
						if sum>=0 then break;	{此时递推值不可能优于传承值}
						if Best[s and 1 xor 1]^[t,j]+sum<Best[s and 1]^[i,j] then
						begin
							Best[s and 1]^[i,j]:=Best[s and 1 xor 1]^[t,j]+sum;
							Prev[s]^[i,j].k:=3;
							Prev[s]^[i,j].t:=t;
						end;
					end
				else for t:=j-1 downto 0 do	{第四个}
					begin
						inc(sum,Value[2,t+1]);
						if sum>=0 then break;
						if Best[s and 1 xor 1]^[i,t]+sum<Best[s and 1]^[i,j] then
						begin
							Best[s and 1]^[i,j]:=Best[s and 1 xor 1]^[i,t]+sum;
							Prev[s]^[i,j].k:=4;
							Prev[s]^[i,j].t:=t;
						end;
					end;
				sum:=0;
				if i=j then
					for t:=j-1 downto 0 do	{第五个}
					begin
						inc(sum,Value[1,t+1]+Value[2,t+1]);
						if sum>=0 then break;
						if Best[s and 1 xor 1]^[t,t]+sum<Best[s and 1]^[i,j] then
						begin
							Best[s and 1]^[i,j]:=Best[s and 1 xor 1]^[t,t]+sum;
							Prev[s]^[i,j].k:=5;
							Prev[s]^[i,j].t:=t;
						end;
					end;
			end;
	end;
end;

procedure Print;	{打印}
var
	s,i,j	:byte;
begin
	rewrite(output);
	s:=K; i:=N; j:=N;
	while Prev[s]^[i,j].k>0 do
		case Prev[s]^[i,j].k of
			1 : dec(i);	{1,2这两种情况属于传承，不需要子矩阵}
			2 : dec(j);
			3 : begin	{以下三种情况分别打印三种子矩阵}
					writeln('1 ',Prev[s]^[i,j].t+1,' 1 ',i);
					i:=Prev[s]^[i,j].t;
					dec(s);
				end;
			4 : begin
					writeln('2 ',Prev[s]^[i,j].t+1,' 2 ',j);
					j:=Prev[s]^[i,j].t;
					dec(s);
				end;
			5 : begin
					writeln('1 ',Prev[s]^[i,j].t+1,' 2 ',i);
					i:=Prev[s]^[i,j].t;
					j:=i;
					dec(s);
				end;
		end;
	for i:=1 to s do	{放弃的发射输出0}
		writeln('0 0 0 0');
	close(output);
end;

begin
	assign(input,'input.txt');
	assign(output,'output.txt');
	ReadIn;
	Work;
	Print;
end.
