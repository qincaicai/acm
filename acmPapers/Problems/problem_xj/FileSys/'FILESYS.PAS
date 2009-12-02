{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V-,X+,Y+}
{$M 16384,0,655360}
program FileSystemTest;
const
	Infns='filesys.in';
	Outfns='filesys.out';
	Stdfns='filesys.std';
type
	TPlanar=array['a'..'z','a'..'z'] of boolean;
	TLinear=array['a'..'z'] of integer;
var
	n:integer;
	Map:TPlanar;
	degree:TLinear;
	ans,standard:integer;
procedure Init;
  var
	i:integer;
	a,b:char;
  begin
	fillchar(Map,sizeof(Map),false);
	assign(input,Infns); reset(input);
	readln(n);
	for i:=1 to n do begin
		repeat read(a);
		until a in ['a'..'z'];
		repeat read(b);
		until b in ['a'..'z'];
		Map[a,b]:=true;
		Map[b,a]:=true;
	end;
	close(input);
	n:=0;
	for a:='a' to 'z' do begin
		Map[a,a]:=false; Degree[a]:=0;
		for b:='a' to 'z' do
			inc(Degree[a],byte(Map[a,b]));
		if Degree[a]>0 then inc(n);
	end;
	assign(input,Stdfns); reset(input);
	readln(standard);
	close(input);
  end;

procedure CheckAnswer;
  var
	i,max,now:integer;
	a,b:char;
	remain:array['a'..'z'] of boolean;
  begin
	fillchar(remain,sizeof(remain),false);
	assign(input,Outfns); reset(input);
	readln(ans);
	now:=0; max:=0;
	for i:=1 to n+n do begin
		repeat read(a);
		until a in ['a'..'z'];
		inc(now); remain[a]:=true;
		if now>max then max:=now;
		for b:='a' to 'z' do
		  if remain[b] and Map[a,b] then begin
			Map[a,b]:=false;
			Map[b,a]:=false;
			dec(degree[a]); dec(degree[b]);
			if degree[b]=0 then begin
				remain[b]:=false; dec(now);
			end;
		  end;
		if degree[a]=0 then begin
			remain[a]:=false; dec(now);
		end;
	end;
	close(input);
	if max<>ans then begin
		writeln('Error!',max); halt;
	end;
	for a:='a' to 'z' do
		if degree[a]>0 then begin
			writeln('Error.');   halt;
		end;
  end;

begin
	Init;
	CheckAnswer;
	writeln('Standard Answer:',standard);
	writeln('Your Answer:',ans);
	if ans<standard*2
		then writeln(10*(2-ans/standard):0:2)
		else writeln(0);
end.