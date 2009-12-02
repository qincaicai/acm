program naj; {POI98_13}
var
  maxmap,minmap,max,min,w:array[1..10000] of longint;
  sum,s,r,t,m,n,i,j:longint;

procedure down_max(no:longint);
var
  i,t:longint;
begin
  i:=no+no;
  if (i<s) and (max[i+1]>max[i]) then i:=i+1;
  while (i<=s) and (max[i]>max[no]) do
    begin
      t:=max[i]; max[i]:=max[no]; max[no]:=t;
      minmap[maxmap[i]]:=no; minmap[maxmap[no]]:=i;
      t:=maxmap[i]; maxmap[i]:=maxmap[no]; maxmap[no]:=t;
      no:=i; i:=no+no;
      if (i<s) and (max[i+1]>max[i]) then i:=i+1;
    end;
end;

procedure down_min(no:longint);
var
  i,t:longint;
begin
  i:=no+no;
  if (i<s) and (min[i+1]<min[i]) then i:=i+1;
  while (i<=s) and (min[i]<min[no]) do
    begin
      t:=min[i]; min[i]:=min[no]; min[no]:=t;
      maxmap[minmap[i]]:=no; maxmap[minmap[no]]:=i;
      t:=minmap[i]; minmap[i]:=minmap[no]; minmap[no]:=t;
      no:=i; i:=no+no;
      if (i<s) and (min[i+1]<min[i]) then i:=i+1;
    end;
end;

procedure up_max(no:longint);
var
  i,t:longint;
begin
  i:=no div 2;
  while (i>0) and (max[i]<max[no]) do
    begin
      t:=max[i]; max[i]:=max[no]; max[no]:=t;
      minmap[maxmap[i]]:=no; minmap[maxmap[no]]:=i;
      t:=maxmap[i]; maxmap[i]:=maxmap[no]; maxmap[no]:=t;
      no:=i; i:=no div 2;
    end;
end;

procedure up_min(no:longint);
var
  i,t:longint;
begin
  i:=no div 2;
  while (i>0) and (min[i]>min[no]) do
    begin
      t:=min[i]; min[i]:=min[no]; min[no]:=t;
      maxmap[minmap[i]]:=no; maxmap[minmap[no]]:=i;
      t:=minmap[i]; minmap[i]:=minmap[no]; minmap[no]:=t;
      no:=i; i:=no div 2;
    end;
end;

procedure add(no:longint);
var
  i:longint;
begin
  if s<n then
    begin
      s:=s+1;
      max[s]:=no; min[s]:=no;
      maxmap[s]:=s; minmap[s]:=s;
      up_max(s); up_min(s);
      sum:=sum+no;
    end
  else if no<max[1] then
    begin
      sum:=sum+no-max[1];
      i:=maxmap[1];
      max[1]:=no; down_max(1);
      min[i]:=no; up_min(i); down_min(i);
    end;
end;

procedure delmin;
var
  i:longint;
begin
  i:=minmap[1]; sum:=sum-min[1];
  if 1<>s then
    begin
      min[1]:=min[s];
      minmap[1]:=minmap[s]; maxmap[minmap[s]]:=1;
    end;
  if i<>s then
    begin
      max[i]:=max[s];
      maxmap[i]:=maxmap[s]; minmap[maxmap[s]]:=i;
    end;
  s:=s-1;
  down_min(1); down_max(i); up_max(i);
end;

begin
  assign(input,'naj.in');
  reset(input);
  readln(n,m);
  for i:=1 to m do
    read(w[i]);
  for i:=1 to m do
    for j:=1 to m-1 do
      if w[j]>w[j+1] then
        begin
          t:=w[j]; w[j]:=w[j+1]; w[j+1]:=t;
        end;
  s:=0; r:=maxlongint; sum:=0;
  for i:=1 to m do
    add(w[i]);
  repeat
    if (s=n) and (sum<r) then
      r:=sum;
    t:=min[1];
    delmin;
    for i:=1 to m do
      add(t+w[i]);
  until (s=n) and (sum>=r);
  assign(output,'naj.out');
  rewrite(output);
  writeln(r);
  close(output);
end.
