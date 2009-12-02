program Mark_House;
const
	Dire	:array [0..3,0..1] of shortint=
		((1,0),(0,1),(0,-1),(-1,0));
const
	MaxN=20;
type
	TRequest=
		record
			x1,y1,x2,y2	:byte;
		end;
var
	N	:byte;
	M	:word;
	Request	:array [1..MaxN*2] of TRequest;
	Mirror	:array [1..MaxN,1..MaxN] of byte;

procedure ReadRequest;
var
	i	:byte;
begin
	assign(input,'input.txt');
	reset(input);
	readln(N);
	for i:=1 to N+N do
		with Request[i] do
			readln(x1,y1,x2,y2);
	close(input);
end;

procedure ShowMark(Mark:real);
begin
	writeln('Your mark for this test point is ',round(Mark),
		' (',Mark:0:2,')');
end;

procedure Error(Message:string);
begin
	writeln('Error: ',Message);
	ShowMark(0);
	halt;
end;

function IntToStr(i:integer):string;
var
	s	:string;
begin
	Str(i,s);
	IntToStr:=s;
end;

procedure ReadSolution;
var
	i	:word;
	j	:byte;
	P	:array [0..2] of longint;
begin
	{$i-}
	assign(input,'output.txt');
	reset(input);
	if IOResult<>0 then
		Error('File not exists');
	if SeekEoln then
		Error('Invalid file format');
	read(M);
	if (IOResult<>0) or not SeekEoln then
		Error('Invalid file format');
	readln;
	fillchar(Mirror,sizeof(Mirror),0);
	for i:=1 to M do
	begin
		for j:=0 to 2 do
		begin
			if SeekEoln then
				Error('Invalid file format');
			read(P[j]);
			if IOResult<>0 then
				Error('Invalid file format');
			if (j<2) and ((P[j]<1) or (P[j]>N)) or
				(j=2) and (P[j]<>1) and (P[j]<>2) then
				Error('Range overflow');
		end;
		if not SeekEoln then
			Error('Invalid file format');
		readln;
		if Mirror[P[0],P[1]]>0 then
			Error('You can only put one mirror at position ('+
				IntToStr(P[0])+','+IntToStr(P[1])+')');
		Mirror[P[0],P[1]]:=P[2];
	end;
	if not SeekEof then
		Error('Invalid file format');
	close(input);
	{$i+}
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

procedure Check;
var
	i,x,y,S	:byte;
begin
	S:=0;
	for i:=1 to N+N do
	begin
		Transmit(Request[i].x1,Request[i].y1,x,y);
		if (x=Request[i].x2) and (y=Request[i].y2) then
			inc(S);
	end;
	Writeln('Correct');
	if S<N
		then ShowMark(0)
		else ShowMark(10*(S/N-1)+1E-9);
end;

begin
	ReadRequest;
	ReadSolution;
	Check;
end.