{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T+,V-,X+}
{$M 16384,0,655360}
program FileSystem;
const
	Infns='filesys.in';
	Outfns='filesys.out';
	LimitN=26;
	LimitTime=50;
type
	TChar=array['a'..'z'] of longint;
	TInt=array[1..LimitN] of char;
	TMap=array[1..LimitN] of longint;
	TLinear=array[0..LimitN] of longint;
var
	Name:TInt;
	Order:TChar;
	Map,UseMap:TMap;

	n,best,value,pre,endtask:longint;
	Ans,Now,
	enduse,endself,
	maxvl:TLinear;

	nowtime:longint absolute $40:$6c;
	starttime:longint;

procedure Init;
  var
	i,m,ta,tb:longint;
  function Readin:longint;
	var a:char;
	begin
		repeat read(a);
		until a in ['a'..'z'];
		if Order[a]=0
		  then begin
			inc(n); Order[a]:=n; Name[n]:=a;
		  end;
		Readin:=Order[a];
	end;
  begin
	fillchar(Map,sizeof(Map),0);
	fillchar(Order,sizeof(Order),0);
	n:=0;
	assign(input,Infns); reset(input);
	readln(m);
	for i:=1 to m do begin
		ta:=Readin;
		tb:=Readin;
{		if ta=tb then writeln('E!',ta);{}
		Map[ta]:=Map[ta] or (1 shl tb);
		Map[tb]:=Map[tb] or (1 shl ta);
	end;
	close(input); best:=maxint;
	value:=0;
	fillchar(enduse,sizeof(enduse),0);
	endself:=enduse;
	maxvl:=enduse;
	UseMap:=Map;
	pre:=0; endtask:=0;
  end;

function AboveZero(x:longint):longint;
  begin
	if x<0	then AboveZero:=0
			else AboveZero:=x;
  end;

procedure GetEnd(level,i:longint);
  var
	j,euse,t:longint;
  begin
	euse:=0;
	for j:=1 to level-1 do
	  if (1 shl now[j]) and Map[i] >0 then begin
		t:=now[j];
		dec(UseMap[t],1 shl i);
		dec(UseMap[i],1 shl t);
		if UseMap[t]=0 then begin
			inc(euse); inc(endtask,1 shl t);
		end;
	  end;
	enduse[level]:=euse;
	endself[level]:=byte(UseMap[i]=0);
  end;

procedure Resume(level,i:longint);
  var
	j,t:longint;
  begin
	UseMap[i]:=Map[i];
	for j:=1 to level-1 do
		inc(UseMap[now[j]],(1 shl i) and Map[now[j]]);
  end;

function NoExchange(level,i:longint):boolean;
  var
	w,x,y,z,level1,j,t1,t2,k,
	tw,tx,ty,tz:longint;
  begin
	level1:=level-1;
	w:=enduse[level1]; x:=enduse[level];
	y:=endself[level1]; z:=endself[level];
	j:=now[level1];
	if (1 shl j) and Map[i]>0
	  then begin
		tz:=byte((pre or (1 shl i)) and Map[j]=Map[j]);
		tw:=x-tz; ty:=0; tx:=w+z;
	  end
	  else begin
		tw:=x; ty:=z;
		tx:=w; tz:=y;
	  end;
	t2:=0; t1:=Map[j] and Map[i] and endtask and pre;
	while t1>0 do begin
		inc(t2,t1 and 1);
		t1:=t1 shr 1;
	end;
	dec(tw,t2); inc(tx,t2);
	t1:=-w-y+1+AboveZero(-x-z+1);
	t2:=-tw-ty+1+AboveZero(-tx-tz+1);
	NoExchange:=(t1<t2) or ((t1=t2) and (j<i));
  end;

procedure Search(level:longint);
  var
	i,savetask:longint;
  begin
	if level>n then begin
		best:=0;
		for i:=1 to n do begin
		  if maxvl[i]>best then best:=maxvl[i];
{		  write(maxvl[i],' ');{}
		end;
{		writeln(best,':',(nowtime-starttime)/18.2:0:2);{}
		Ans:=Now; exit;
	end;
	if value+1>=best then exit;
	if nowtime-starttime>LimitTime then exit;{}
	savetask:=endtask;
	for i:=1 to n do
	  if (1 shl i) and pre=0 then begin
		GetEnd(level,i);
		if (level=1) or NoExchange(level,i) then begin
			inc(value);
			if value>maxvl[level-1]
				then maxvl[level]:=value
				else maxvl[level]:=maxvl[level-1];
			dec(value,enduse[level]+endself[level]);
			inc(pre,1 shl i);
			Now[level]:=i;
			Search(level+1);
			dec(pre,1 shl i);
			inc(value,enduse[level]+endself[level]-1);
		end;
		Resume(level,i);
		endtask:=savetask;
		if maxvl[level]>=best then exit;
	  end;
  end;

procedure Out;
  var
	i,j,a,b:longint;
  begin
	UseMap:=Map;
	assign(output,Outfns); rewrite(output);
	writeln(best);
	for i:=1 to n do begin
		a:=Ans[i];
		write(Name[a],' ');
		for j:=1 to i-1 do
		  if (1 shl Ans[j]) and UseMap[a]>0 then begin
			b:=Ans[j];
			dec(UseMap[a],(1 shl b));
			dec(UseMap[b],(1 shl a));
			if UseMap[b]=0 then write(Name[b],' ');
		  end;
		if UseMap[a]=0 then write(Name[a],' ');
	end;
	writeln;
	close(output);
  end;

begin
	starttime:=nowtime;
	Init;
	Search(1);
	writeln(best,':',(nowtime-starttime)/18.2:0:2);
	Out;
end.
