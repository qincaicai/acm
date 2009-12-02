{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 65520,0,655360}
type
  node=record
         f,c:shortint;
       end;
  arr=array[1..201] of node;
  node1=record
          p,t:integer;
        end;
var
  n,m:integer;
  mp,np:array[1..100,1..2] of integer;
  map:array[1..201] of ^arr;
  lt:array[1..201] of node1;
function dis(a,b,c,d:integer):real;
  begin
    dis:=sqrt(sqr(longint(a-b))+sqr(longint(c-d)));
  end;
procedure init;
  var i,j:integer;
  begin
    readln(n,m);
    for i:=1 to n do
      read(np[i,1],np[i,2]);
    readln;
    for i:=1 to m do
      read(mp[i,1],mp[i,2]);
    readln;
    for i:=1 to m+n+1 do
      begin
        new(map[i]);
        fillchar(map[i]^,sizeof(map[i]^),0);
      end;
    for i:=1 to n-1 do
      map[1]^[i+1].c:=1;
    for i:=1 to m do
      map[i+n]^[m+n+1].c:=1;
    for i:=1 to n-1 do
      for j:=1 to m do
        if dis(np[i,1],mp[j,1],np[i,2],mp[j,2])+dis(np[i+1,1],mp[j,1],
        np[i+1,2],mp[j,2])<=2*dis(np[i,1],np[i+1,1],np[i,2],np[i+1,2])
        then map[i+1]^[j+n].c:=1;
  end;
function find(var i:integer):boolean;
  begin
    find:=false;
    i:=0;
    while (i<=m+n) and not ((lt[i].p<>0) and (lt[i].t=0)) do inc(i);
    if i>m+n then exit
    else find:=true;
  end;
function success:boolean;
  var i,j,min:integer;
  begin
    fillchar(lt,sizeof(lt),0);
    lt[1].p:=1;
    success:=false;
    repeat
      if not find(i) then exit;
      for j:=1 to n+m+1 do
        if (lt[j].p=0) and (map[i]^[j].f<map[i]^[j].c) then
          lt[j].p:=i;
      lt[i].t:=1;
    until lt[m+n+1].p<>0;
    success:=true;
  end;
procedure ford;
  var i,j:integer;
  begin
    i:=n+m+1;
    while lt[i].p<>i do
      begin
        j:=lt[i].p;
        inc(map[j]^[i].f);
        map[i]^[j].f:=-map[j]^[i].f;
        i:=j;
      end;
  end;
procedure print;
  var i,j,t:integer;
  begin
    t:=n;
    for i:=2 to n do
      if map[1]^[i].f=1 then
        inc(t);
    writeln(t);
    for i:=1 to n-1 do
      begin
        write(np[i,1],' ',np[i,2],' ');
        for j:=1 to m do
          if map[i+1]^[j+n].f=1 then write(mp[j,1],' ',mp[j,2],' ');
      end;
    writeln(np[n,1],' ',np[n,2]);
  end;
begin
  assign(input,'dog.in');
  reset(input);
  init;
  close(input);
  while success do ford;
  assign(output,'dog.out');
  rewrite(output);
  print;
  close(output);
end.