{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V-,X+,Y+}
{$M 16384,0,655360}
program CamelTrading;
const
	MaxN=100;	{N的上限}
var
	N	:byte;	{图中点数N}
	Value	:array [1..MaxN,1..MaxN] of word;	{边上的权}
	Degree,		{点的度数}
	Destination	:array [1..MaxN] of byte;	{每个点中商队的目的地}

procedure ReadIn;	{读入}
var
	M	:word;	{图中的边数}
	i,j	:byte;
	k,v	:word;
begin
	reset(input);
	readln(N,M);
	fillchar(Degree,sizeof(Degree),0);
	for k:=1 to M do
	begin
		readln(i,j,v);
		Value[i,j]:=v;
		Value[j,i]:=v;
		inc(Degree[i]);
		inc(Degree[j]);
	end;
	close(input);
end;

procedure DeleteEdge(u,v:byte);	{删去边(u,v)}
begin
	Value[u,v]:=0;
	Value[v,u]:=0;
	dec(Degree[u]);
	dec(Degree[v]);
end;

procedure DealOneDegree;	{处理所有度为1的点}
var
	i,j	:byte;
	ok	:boolean;
begin
	repeat
		ok:=true;
		for i:=1 to N do
			if Degree[i]=1 then
			begin
				for j:=1 to N do
					if Value[i,j]>0 then
						break;
				Destination[i]:=j;	{将边(i,j)分配给i}
				DeleteEdge(i,j);
				if (j<i) and (Degree[j]=1) then
					ok:=false;
			end;
	until ok;
end;

procedure Work;	{主过程}
var
	u,v,i	:byte;
	Mark	:array [1..MaxN] of boolean;	{查找连通分量时用到的标志}
	SubM,SubN,	{连通分量中的边数和点数}
	MinV	:word;	{连通分量中最小的权}
	procedure DFS(k:byte);	{深度搜索查找连通分量}
	var	i:byte;
	begin
		Mark[k]:=false;
		inc(SubN); inc(SubM,Degree[k]);
		for i:=1 to N do
			if Value[k,i]>0 then
			begin
				if Value[k,i]<MinV then
				begin
					MinV:=Value[k,i];
					u:=k; v:=i;
				end;
				if Mark[i] then
					DFS(i);
			end;
	end;
begin
	repeat
		DealOneDegree;
		for u:=1 to N do
			if Degree[u]>0 then
				break;
		if Degree[u]=0 then break;	{如果图中已没有边了则结束算法}
		fillchar(Mark,sizeof(Mark),true);
		SubM:=0; SubN:=0;
		MinV:=high(MinV);
		DFS(u);	{这里计算出来SubM实际上是边数*2}
		if SubM=SubN+SubN	{如果边数等于点数}
		then for i:=1 to SubN do	{取出所有的边}
			begin
				for v:=1 to N do
					if Value[u,v]>0 then
						break;
				Destination[u]:=v;
				DeleteEdge(u,v);
				u:=v;
			end
		else DeleteEdge(u,v);	{删除权最小的边}
	until false;
end;

procedure Print;	{打印}
var
	i	:byte;
begin
	rewrite(output);
	for i:=1 to N do
		write(Destination[i],' ');
	writeln;
	close(output);
end;

begin
	assign(input,'input.txt');
	assign(output,'output.txt');
	ReadIn;
	Work;
	Print;
end.
