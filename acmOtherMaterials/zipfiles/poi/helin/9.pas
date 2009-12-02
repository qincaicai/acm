const
  fin = 'tan.in';
  fout = 'tan.out';
  maxn = 1005;
  walkday = 800;

type
  tnode = record
    day : integer;
    cost : longint;
  end;
  tcount = array[0 .. maxn] of tnode;

var
  n : integer;
  last, dis : array[0 .. maxn] of integer;
  pay : array[0 .. maxn] of integer;
  f : tcount;

procedure getinfo;
var
  i : integer;
begin
  assign(input, fin); reset(input);
  readln(i, n); dis[n + 1] := i; pay[0] := 0;
  for i := 1 to n do readln(dis[i], pay[i]);
  pay[n + 1] := 0;
  close(input);
end;

procedure show;
var
  i, l : integer;
  lst : array[0 .. maxn] of integer;
begin
  l := 0; i := n + 1;
  repeat
    i := last[i]; inc(l); lst[l] := i;
  until i = 0;
  for i := l - 1 downto 1 do write(dis[lst[i]], ' ');
  writeln;
end;

procedure dycnamic1;
var
  i, j : integer;

procedure update(cost : longint; day: integer; var node : tnode);
begin
  if cost > node.cost then exit;
  if cost < node.cost then begin
    node.cost := cost; node.day := day; last[j] := i;
  end else if day < node.day then begin
    node.cost := cost; node.day := day; last[j] := i;
  end;
end;

begin
  for i := 0 to n + 1 do begin f[i].day := maxint; f[i].cost := maxlongint end;
  fillchar(f[0], sizeof(f[0]), 0);
  for i := 0 to n do if f[i].cost <> maxlongint then
    for j := i + 1 to n + 1 do if dis[j] - dis[i] > walkday then break else
      update(f[i].cost + pay[j], f[i].day + 1, f[j]);
  show;
end;

procedure dycnamic2;
var
  i, j : integer;

procedure update(cost : longint; day: integer; var node : tnode);
begin
  if day > node.day then exit;
  if day < node.day then begin
    node.cost := cost; node.day := day; last[j] := i;
  end else if cost < node.cost then begin
    node.cost := cost; node.day := day; last[j] := i;
  end;
end;

begin
  for i := 0 to n + 1 do begin f[i].day := maxint; f[i].cost := 0 end;
  f[0].day := 0; f[0].cost := 0;
  for i := 0 to n do
    for j := i + 1 to n + 1 do if dis[j] - dis[i] > walkday then break else
      update(f[i].cost + pay[j], f[i].day + 1, f[j]);
  show;
end;

begin
  getinfo;
  assign(output, fout); rewrite(output);
  dycnamic1;
  dycnamic2;
  close(output);
end.
