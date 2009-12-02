{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V-,X+,Y+}
{$M 16384,0,655360}
program NewHouse;
const
	Dire	:array [0..3,0..1] of shortint=	{四个方向的坐标增量}
		((1,0),(0,1),(0,-1),(-1,0));
const
	MaxN=20;	{N的上限}
type
	TRequest=	{纪录一个要求的类型}
		record
			x1,y1,x2,y2	:byte;
		end;
var
	N,
	S,			{最多能满足多少要求}
	S1	:byte;	{当前能满足多少要求}
	Request :array [1..MaxN*2] of TRequest;	{要求}
	Mirror,		{纪录每个位置的镜子。0表示没有镜子}
	Mark,		{在处理一个要求时纪录从控制区出发的第一条光线}
	Best	:array [1..MaxN,1..MaxN] of byte;	{最优的镜子方案}
	Free	:array [1..MaxN,1..MaxN] of boolean;	{值为false表示该位置已有光路}

procedure ReadIn;	{读入要求}
var
	i	:byte;
begin
	reset(input);
	readln(N);
	for i:=1 to N+N do
		with Request[i] do
			readln(x1,y1,x2,y2);
	close(input);
end;

procedure Transmit(i,j:byte);	{从(i,j)引出一条光线并将它记录在Mark中}
var
	d	:byte;
begin
	fillchar(Mark,sizeof(Mark),9);
	if i=0
	then d:=0
	else if j=0
		then d:=1
		else if j>N
			then d:=2
			else d:=3;
	repeat
		inc(i,Dire[d,0]);
		inc(j,Dire[d,1]);
		if (i=0) or (i>N) or (j=0) or (j>N) then
			break;
		Mark[i,j]:=d;
		d:=d xor Mirror[i,j];
	until false;
end;

function Meet(i,j:byte):boolean;
	{从(i,j)引出一条光线并判断它能否和Mark中的光线相会}
var
	d,x,y,k,t	:byte;
begin
	Meet:=true;
	if i=0
	then d:=0
	else if j=0
		then d:=1
		else if j>N
			then d:=2
			else d:=3;
	repeat
		inc(i,Dire[d,0]);
		inc(j,Dire[d,1]);
		if (i=0) or (i>N) or (j=0) or (j>N) then
			break;
		d:=d xor Mirror[i,j];
		if Mark[i,j] xor d=3 then	{如果直接相会那么不用镜子}
			exit;
		if (Mark[i,j]<9) and Free[i,j] then	{如果相交那么放一面镜子}
		begin
			Mirror[i,j]:=Mark[i,j] xor d xor 3;
			exit;
		end;
		if Free[i,j] then
			for k:=1 to 2 do	{尝试在当前位置放上镜子k}
			begin
				x:=i; y:=j; t:=d xor k;
				repeat
					inc(x,Dire[t,0]);
					inc(y,Dire[t,1]);
					if (x=0) or (x>N) or (y=0) or (y>N) or
						(x=i) and (y=j) then
						break;
					if (Mark[x,y]<9) and Free[x,y] then	{放两面镜子}
					begin
						Mirror[x,y]:=Mark[x,y] xor t xor 3;
						Mirror[i,j]:=k;
						exit;
					end;
					t:=t xor Mirror[x,y];
				until false;
			end;
	until false;
	Meet:=false;
end;

procedure Fill(i,j:byte);	{将从(i,j)出发的光路的Free值标为false}
var
	d	:byte;
begin
	if i=0
	then d:=0
	else if j=0
		then d:=1
		else if j>N
			then d:=2
			else d:=3;
	repeat
		inc(i,Dire[d,0]);
		inc(j,Dire[d,1]);
		if (i=0) or (i>N) or (j=0) or (j>N) then
			break;
		Free[i,j]:=false;
		d:=d xor Mirror[i,j];
	until false;
end;

procedure PutMirror;	{按照Request中的顺序来处理各个要求}
var
	i	:byte;
begin
	fillchar(Mirror,sizeof(Mirror),0);
	fillchar(Free,sizeof(Free),true);
	S1:=0;
	for i:=1 to N+N do
	begin
		Transmit(Request[i].x1,Request[i].y1);
		if Meet(Request[i].x2,Request[i].y2) then
		begin
			Fill(Request[i].x1,Request[i].y1);
			inc(S1);
		end;
	end;
end;

procedure Work;	{主过程}
var
	tmp	:TRequest;
	Time	:word;
	k,i,j	:byte;
begin
	randomize;
	S:=0;
	for Time:=1 to 100 do	{决定随机化的次数}
	begin
		i:=1; tmp:=Request[1];
		for k:=1 to N+N do	{打乱Request的顺序}
		begin
			j:=random(N+N)+1;
			Request[i]:=Request[j];
			i:=j;
		end;
		Request[i]:=tmp;
		PutMirror;
		if S1>S then	{更新最优解}
		begin
			S:=S1;
			Best:=Mirror;
		end;
	end;
end;

procedure Print;	{打印最优解}
var
	i,j	:byte;
	M	:word;
begin
	M:=0;
	for i:=1 to N do
		for j:=1 to N do
			if Best[i,j]>0 then
				inc(M);
	rewrite(output);
	writeln(M);
	for i:=1 to N do
		for j:=1 to N do
			if Best[i,j]>0 then
				writeln(i,' ',j,' ',Best[i,j]);
	close(output);
end;

begin
	assign(input,'input.txt');
	assign(output,'output.txt');
	ReadIn;
	Work;
	Print;
end.
