{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T+,V-,X+}
{$M 16384,0,655360}
program VirusCheck;
const
	Infns='virus.in';
	Outfns='virus.out';
	LimitN=1000;
type
	TABC=array['A'..'z'] of integer;
	TLinear=array[1..LimitN] of longint;
	TString=array[1..LimitN] of char;
var
	n,m,max:longint;
	s:TString;
	first:TABC;
	next:TLinear;
	ans:array[0..1] of TLinear;
	nowtime:longint absolute $40:$6c;
	start:longint;

procedure Init;
  var
	i:integer;
  begin
	assign(input,Infns); reset(input);
	readln(n);
	for i:=1 to n do read(s[i]);
	readln(m);
	fillchar(first,sizeof(first),0);
	for i:=n downto 1 do begin
		next[i]:=first[s[i]];
		first[s[i]]:=i;
	end;
	max:=0;
  end;

procedure GetAnswer;
  var
	i,p,pre,now:longint;
	prech,ch:char;
  begin
	fillchar(ans,sizeof(ans),0);
	prech:=#96;
	for i:=1 to m do begin
		now:=i and 1;	pre:=1-now;
		read(ch);	p:=first[ch];
		if p=1 then begin
			ans[now,p]:=ans[pre,n]+1;
			if ans[now,p]>max then max:=ans[now,p];
			p:=next[p];
		end;
		while p>0 do begin
			ans[now,p]:=ans[pre,p-1]+1;
			if ans[now,p]>max then max:=ans[now,p];
			p:=next[p];
		end;
		p:=first[prech];
		while p>0 do begin
			ans[pre,p]:=0;
			p:=next[p];
		end;
		prech:=ch;
	end;
  end;

procedure Out;
  begin
	assign(output,Outfns); rewrite(output);
	writeln(max);
	close(output);
  end;

begin
	start:=nowtime;
	Init;
	GetAnswer;
	writeln((nowtime-start)/18.2:0:2);
	Out;
end.
