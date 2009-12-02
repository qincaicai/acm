program Mark_Trade;
const
	MaxN=100;
var
	N,K	:byte;
	Value,V1	:array [1..2,1..MaxN] of integer;
	Std,Usr	:longint;

procedure ReadIn;
var
	i,j	:byte;
	t	:integer;
begin
	assign(input,'fire\input.'+ParamStr(1));
	reset(input);
	readln(N,K);
	for i:=2 downto 1 do
	begin
		for j:=1 to N do
			read(Value[i,j]);
		readln;
	end;
	for i:=2 downto 1 do
	begin
		for j:=1 to N do
		begin
			read(t);
			dec(Value[i,j],t);
		end;
		readln;
	end;
	close(input);
end;

procedure ShowMark(Mark:byte);
begin
	writeln('Your mark for this test point is ',Mark);
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

procedure ReadSolution(Name:string; var Sum:longint);
var
	i,j,x,y	:byte;
	R	:array [1..4] of longint;
begin
	assign(input,Name);
	{$i-}
	reset(input);
	if IOResult<>0 then
		Error('File not exists');
	Sum:=0; V1:=Value;
	for i:=1 to K do
	begin
		for j:=1 to 4 do
		begin
			if SeekEoln then
				Error('Invalid file format');
			Read(R[j]);
			if IOResult<>0 then
				Error('Invalid file format');
		end;
		if not SeekEoln then
			Error('Invalid file format');
		readln;
		if (R[1]=0) and (R[2]=0) and (R[3]=0) and (R[4]=0) then
			continue;
		if (R[1]<1) or (R[3]<R[1]) or (R[3]>2) or
			(R[2]<1) or (R[4]<R[2]) or (R[4]>N) then
			Error('Range overflow');
		for x:=R[1] to R[3] do
			for y:=R[2] to R[4] do
			begin
				inc(Sum,V1[x,y]);
				V1[x,y]:=0;
			end;
	end;
	if not SeekEof then
		Error('Invalid file format');
	close(input);
	{$i+}
end;

begin
	ReadIn;
	ReadSolution('fire\output.'+ParamStr(1),Std);
	ReadSolution('output.txt',Usr);
	if Std=Usr
	then begin
		writeln('Correct');
		ShowMark(10);
	end
	else Error('Solution not optimized');
end.