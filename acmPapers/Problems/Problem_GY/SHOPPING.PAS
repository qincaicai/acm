program Shopping;
const
  inputfile='shopping.in';
  outputfile='shopping.out';
  maxn = 50;
type
  graphtype = array[0..maxn,0..maxn]of integer;
var
  graph,list:graphtype;
  no,temp,prev:array[0..maxn]of integer;
  mark:array[0..maxn]of boolean;
  minprice,num,minedge:array[0..maxn]of integer;
  head,n: integer;
  cost : longint;
  found:boolean;

procedure select;
var i,j: integer;
begin
  for i:=1 to n do begin
    prev[i] := -1;
    minedge[i] := maxint;
  end;
  for i := 0 to n do
    for j := 1 to n do
      if (no[i] <> no[j]) and (graph[i,j] >= 0) then
        if graph[i,j] < minedge[no[j]] then begin
          minedge[no[j]] := graph[i,j];
          prev[no[j]] := no[i];
        end;
end;

procedure append(a,b:integer);
var i:integer;
begin
  for i:=1 to list[a,0] do begin
    inc(list[b,0]);
    list[b,list[b,0]] := list[a,i];
    no[list[a,i]] := b;
  end;
  list[a,0] := 0;
end;

procedure go(id : integer);
var i,j,s: integer;
begin
  if mark[id] then begin
    found := true;
    s := id;
    temp := no;
    repeat
      inc(cost,minedge[id]);
      id := prev[id];
      if id <> s then append(id,s);
    until id = s;
    for j := 1 to n do if no[j] = s then
      for i := 0 to n do if (no[i] <> s) and (graph[i,j] >= 0) then
        dec(graph[i,j], minedge[temp[j]]);
    exit;
  end;
  mark[id] := true;
  for i:=0 to n do
    if (no[i] <> no[id]) and (prev[no[i]] = id)
      then if not mark[no[i]] or (i=head)
             then go(i)
end;

function mincost : longint;
var i,j : integer;
    stop : boolean;
begin
  cost := 0;
  for i:=0 to n do begin
    no[i] := i;
    list[i,0] := 1;
    list[i,1] := i;
  end;
  repeat
    select;
    stop := true;
    fillchar(mark,sizeof(mark),0);
    for i:=1 to n do if not mark[i] and (list[i,0] > 0) then begin
      found := false;
      head := i;
      go(i);
      if found then stop := false;
    end;
  until stop;
  for i:=0 to n do if prev[i] >= 0 then
    inc(cost,minedge[i]);
  mincost := cost;
end;

procedure init;
var i,j,t,p,m,a,b,k: integer;
    x: real;
    ch: char;
    no:array[1..maxn]of integer;
begin
  readln(m);
  t:=m;
  n := 0;
  for i:=1 to m do begin
    readln(x,k);
    p := trunc(x * 10);
    if (p<=0) or (p > 10000) or (k<0) or (k>100) then
      writeln('ERROR');
    if  k > 0 then begin
      inc(n);
      minprice[n] := p;
      num[n] := k;
      no[i] := n;
    end
    else
      no[i] := 0;
  end;
  readln(m);
  for i:=0 to n do
    for j:=0 to n do
      graph[i,j] := -1;
  for i:=1 to n do graph[0,i] := minprice[i];
  for i:=1 to m do begin
    readln(a,b,x);
    if (a <= 0) or (a>t) or (b<=0) or (b>t) then
      writeln('ERROR');
    p := trunc(x * 10);
    if p<0 then
      writeln('ERROR');
    if (no[a] > 0) and (no[b] > 0) then begin
      if p < minprice[no[b]] then minprice[no[b]] := p;
      if no[a] <> no[b] then graph[no[a],no[b]] := p;
    end;
  end;
end;

procedure solve;
var
  ans : longint;
  i,j:integer;
begin
  ans := mincost;
  for i:=1 to n do ans := ans + longint(minprice[i]) * (num[i] - 1);
  writeln(ans / 10 : 0 : 2);
end;

begin
  assign(input,inputfile);
  reset(input);
  assign(output,outputfile);
  rewrite(output);
  init;
  solve;
  close(input);
  close(output);
end.