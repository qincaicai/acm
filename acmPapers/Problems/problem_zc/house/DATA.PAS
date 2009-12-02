program Data_Fire;
const
	Dire	:array [0..3,0..1] of shortint=
		((1,0),(0,1),(0,-1),(-1,0));
var
	DataNum,N	:byte;
	Mirror	:array [0..21,0..21] of byte;

function NumToStr(n:byte):string;
var
	s	:string;
begin
	Str(n,s);
	while s[0]<#3 do
		insert('0',s,1);
	NumToStr:=s;
end;

procedure PutMirror;
var
	i,j	:byte;
begin
	assign(output,'standard.'+NumToStr(DataNum));
	rewrite(output);
	fillchar(Mirror,sizeof(Mirror),0);
	Mirror[0,0]:=1; Mirror[N+1,N+1]:=1;
	Mirror[0,N+1]:=1; Mirror[N+1,0]:=1;
	for i:=1 to N do
	begin
		for j:=1 to N do
		begin
			Mirror[i,j]:=random(3);
			case Mirror[i,j] of
				0: write(' .');
				1: write(' \');
				2: write(' /');
			end;
		end;
		writeln;
	end;
	close(output);
end;

procedure Transmit(i,j:byte; var x,y:byte);
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
		d:=d xor Mirror[i,j];
	until false;
	x:=i; y:=j;
end;

procedure GiveRequest;
var
	i,j,x,y	:byte;
begin
	for i:=0 to N+1 do
		for j:=0 to N+1 do
		begin
			if (i>0) and (i<=N) and (j>0) and (j<=N) then
				continue;
			if Mirror[i,j]=1 then
				continue;
			Transmit(i,j,x,y);
			writeln(i,' ',j,' ',x,' ',y);
			Mirror[i,j]:=1;
			Mirror[x,y]:=1;
		end;
end;

begin
	write('Input DataNum,N: ');
	readln(DataNum,N);
	randomize;
	PutMirror;
	assign(output,'input.'+NumToStr(DataNum));
	rewrite(output);
	writeln(N);
	GiveRequest;
	close(output);
end.