const
  fin = 'pie.in';
  fout = 'pie.out';
  maxvalue = 1000;

type
  tline = array[0 .. maxvalue + 1] of longint;

var
  result : longint;
  degree, f : tline;

function root(p : integer) : integer;
var
  res : integer;
begin
  res := p; while f[res] > 0 do res := f[res];
  root := res;
  while f[p] > 0 do begin f[p] := res; p := f[p] end;
end;

procedure getinfo;
var
  l, i : longint;
  s, t : integer;
  more : boolean;

procedure insert(s, t : integer);
var
  tmp : integer;
begin
  s := root(s); t := root(t);
  if s = t then exit;
  if f[s] > f[t] then begin tmp := s; s := t; t := tmp end;
  inc(f[s], f[t]); f[t] := s;
end;

begin
  for i := 1 to maxvalue do f[i] := -1;
  fillchar(degree, sizeof(degree), 0);
  assign(input, fin); reset(input);
  readln(l); result := l;
  for i := 1 to l do begin
    readln(s, t);
    dec(degree[s]); inc(degree[t]);
    insert(s, t);
  end;
  more := false;
  for i := 1 to maxvalue do if degree[i] > 0 then begin
    inc(result, degree[i]); more := true;
  end;
  close(input);
end;

procedure main;
var
  i, last : integer;
  break : tline;
begin
  fillchar(break, sizeof(break), 0);
  for i := 1 to maxvalue do begin
    last := root(i);
    if (f[last] < -1) and (degree[i] <> 0) then break[last] := 1;
  end;
  for i := 1 to maxvalue do
    if (f[i] < -1) and (break[i] = 0) then inc(result);
end;

procedure print;
begin
  assign(output, fout); rewrite(output);
  writeln(result);
  close(output);
end;

begin
  getinfo;
  main;
  print;
end.
