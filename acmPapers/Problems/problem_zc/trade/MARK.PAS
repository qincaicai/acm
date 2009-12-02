program Mark_Trade;
const
	MaxN=100;
var
	N	:byte;
	Value	:array [1..MaxN,1..MaxN] of word;
	Std,Usr	:longint;

procedure ReadIn;
var
	M	:word;
	i,j	:byte;
	k,v	:word;
begin
	assign(input,'trade\input.'+ParamStr(1));
	reset(input);
	readln(N,M);
	for k:=1 to M do
	begin
		readln(i,j,v);
		Value[i,j]:=v;
		Value[j,i]:=v;
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
	i	:byte;
	Remain	:array [1..MaxN,1..MaxN] of boolean;
	Destination	:array [1..MaxN] of longint;
begin
	assign(input,Name);
	{$i-}
	reset(input);
	if IOResult<>0 then
		Error('File not exists');
	for i:=1 to N do
	begin
		if SeekEoln then
			Error('Invalid file format');
		read(Destination[i]);
		if IOResult<>0 then
			Error('Invalid file format');
		if (Destination[i]<0) or (Destination[i]>N) then
			Error('Range overflow');
	end;
	if not SeekEof then
		Error('Invalid file format');
	close(input);
	{$i+}
	Sum:=0;
	fillchar(Remain,sizeof(Remain),true);
	for i:=1 to N do
		if (Destination[i]>0) and (Remain[i,Destination[i]]) then
			if Value[i,Destination[i]]=0
			then Error('Road between city '+IntToStr(i)+' and '
				+IntToStr(Destination[i])+' doesn''t exist')
			else inc(Sum,Value[i,Destination[i]]);
end;

begin
	ReadIn;
	ReadSolution('trade\output.'+ParamStr(1),Std);
	ReadSolution('output.txt',Usr);
	if Std=Usr
	then begin
		writeln('Correct');
		ShowMark(10);
	end
	else Error('Solution not optimized');
end.