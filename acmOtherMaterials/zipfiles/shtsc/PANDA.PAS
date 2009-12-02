type
  arr=array[0..999] of longint;
var
  n,k:longint;
  prime,point:array[1..100] of longint;
  num:array[0..100] of ^arr;
procedure init;
  var i:integer;
  begin
    readln(n,k);
    for i:=1 to n do
      read(prime[i]);
    readln;
    fillchar(point,sizeof(point),0);
    for i:=0 to k div 1000 do
      new(num[i]);
  end;
function p(i:longint):integer;
  begin
    p:=i div 1000;
  end;
function q(i:longint):integer;
  begin
    q:=i mod 1000;
  end;
procedure solve;
  var i,j,min,t:longint;
      times:array[1..100] of integer;
      s:integer;
  begin
    num[0]^[0]:=1;
    for i:=1 to k do
      begin
        min:=maxlongint;
        s:=0;
        for j:=1 to n do
          begin
            t:=prime[j]*num[p(point[j])]^[q(point[j])];
            if t<min then
              begin
                min:=t;
                s:=1;
                times[s]:=j;
              end
              else if t=min then
                begin
                  inc(s);
                  times[s]:=j;
                end;
          end;
        num[p(i)]^[q(i)]:=min;
        for j:=1 to s do
          inc(point[times[j]]);
      end;
  end;
begin
  assign(input,'panda.in');
  reset(input);
  init;
  close(input);
  solve;
  assign(output,'panda.out');
  rewrite(output);
  writeln(num[p(k)]^[q(k)]);
  close(output);
end.
