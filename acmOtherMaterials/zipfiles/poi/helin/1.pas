const
  fin = 'bit.in';
  fout = 'bit.out';
  maxn = 182;
  dx : array[1 .. 4] of integer = (-1, 1, 0, 0);
  dy : array[1 .. 4] of integer = (0, 0, -1, 1);

type
  pnode = ^tnode;
  tnode = record
    x, y : byte;
    next : pnode;
  end;
  tmap = array[0 .. maxn, 0 .. maxn] of integer;

var
  n, m : integer;
  head, tail : pnode;
  res : tmap;

procedure delete;
var
  tmp : pnode;
begin
  tmp := head; head := head^.next; dispose(tmp);
  if head = nil then tail := nil;
end;

procedure update(x, y, v : integer);
var
  tmp : pnode;
begin
  if (x < 1) or (y < 1) or (x > n) or (y > m) or (v >= res[x, y]) then exit;
  res[x, y] := v;
  new(tmp); tmp^.x := x; tmp^.y := y; tmp^.next :=nil;
  if head = nil then head := tmp else tail^.next := tmp;
  tail := tmp;
end;

procedure prepare;
var
  i, j : integer;
  s : string;
begin
  head := nil; tail := nil;
  assign(input, fin); reset(input);
  readln(n, m);
  for i := 1 to n do for j := 1 to m do res[i, j] := maxint;
  for i := 1 to n do begin
    readln(s);
    for j := 1 to m do if s[j] = '1' then update(i, j, 0);
  end;
  close(input);
end;

procedure print;
var
  i, j : integer;
begin
  assign(output, fout); rewrite(output);
  for i := 1 to n do begin
    for j := 1 to m do write(res[i, j], ' ');
    writeln;
  end;
  close(output);
end;

procedure main;
var
  i : integer;
  cur : tnode;
begin
  while head <> nil do begin
    cur := head^; delete;
    for i := 1 to 4 do
      update(cur.x + dx[i], cur.y + dy[i], res[cur.x, cur.y] + 1);
  end;
end;

begin
  prepare;
  main;
  print;
end.
