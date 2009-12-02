const
  fin = 'mag.in';
  fout = 'mag.out';
  maxn = 102;
  dirs = 4;
  dx : array[1 .. dirs] of integer = (-1, 0, 0, 1);
  dy : array[1 .. dirs] of integer = (0, -1, 1, 0);

type
  tpoint = record x, y : byte end;
  tline = array[0 .. maxn + 1] of integer;
  tmap = array[0 .. maxn + 1] of tline;
  tnode = record
    p : tpoint;
    side : byte;
    dep : integer;
  end;
  pcell = ^tcell;
  tcell = record
    x : integer;
    next : pcell;
  end;
  tbase = object
    n, m : integer;
    pusher, start, target : tpoint;
    empty : tmap;
    belong : array[0 .. maxn + 1, 0 .. maxn + 1] of pcell;

    procedure calcbelong;
    procedure prepare;
    function sameb(x0, y0, x1, y1 : integer) : boolean;
  end;

function tbase.sameb(x0, y0, x1, y1 : integer) : boolean;
var
  t0, t1 : pcell;
begin
  sameb := true;
  t0 := belong[x0, y0];
  while t0 <> nil do begin
    t1 := belong[x1, y1];
    while t1 <> nil do begin
      if t0^.x = t1^.x then exit;
      t1 := t1^.next;
    end;
    t0 := t0^.next;
  end;
  sameb := false;
end;

var
  doing : array[0 .. maxn * maxn + 1] of byte;
  where : array[0 .. maxn * maxn + 1] of tpoint;
  tmpl : array[0 .. maxn * maxn + 1] of integer;

procedure tbase.calcbelong;
var
  part, p, tot : integer;
  dfs, low : tmap;
  stack : array[1 .. maxn * maxn + 1, 1 .. 2] of integer;
  i, j : integer;

procedure setin(x, y, p : integer);
var
  xtmp : pcell;
begin
  new(xtmp); xtmp^.x := p;
  xtmp^.next := belong[x, y];
  belong[x, y] := xtmp;
end;

procedure search(x, y : byte);
var
  nx, ny, now : integer;
begin
  now := 1; doing[now] := 0; where[now].x := x; where[now].y := y;
  dfs[x, y] := 1; low[x, y] := 1; tot := 1;
  p := 1; stack[1, 1] := x; stack[1, 2] := y;
  while now > 0 do begin
    inc(doing[now]);
    if doing[now] > dirs then begin
      if low[where[now].x, where[now].y] < low[where[now - 1].x, where[now - 1].y] then
        low[where[now - 1].x, where[now - 1].y] := low[where[now].x, where[now].y];
      if (now > 1) and (low[where[now].x, where[now].y] >= dfs[where[now - 1].x, where[now - 1].y]) then begin
        inc(part);
        inc(p); stack[p, 1] := where[now - 1].x; stack[p, 2] := where[now - 1].y;
        while p <> tmpl[now - 1] do begin
          setin(stack[p, 1], stack[p, 2], part);
          dec(p);
        end;
      end;
      dec(now); continue
    end;
    nx := where[now].x + dx[doing[now]];
    ny := where[now].y + dy[doing[now]];
    if empty[nx, ny] = 1 then
    if dfs[nx, ny] = 0 then begin
      inc(tot); dfs[nx, ny] := tot; low[nx, ny] := tot;
      inc(p); stack[p, 1] := nx; stack[p, 2] := ny; tmpl[now] := p - 1;
      inc(now); doing[now] := 0;
      where[now].x := nx; where[now].y := ny;
    end else if dfs[nx, ny] < low[where[now].x, where[now].y] then
      low[where[now].x, where[now].y] := dfs[nx, ny];
  end;
end;

begin
  fillchar(belong ,sizeof(belong), 0);
  part := 0; tot := 0; p := 0; fillchar(dfs, sizeof(dfs), 0);
  for i := 1 to n do
    for j := 1 to m do if (empty[i, j] = 1) and (dfs[i, j] = 0) then begin
      search(i, j);
    end;
end;

procedure tbase.prepare;
var
  p : tpoint;
  s : string;
  i : integer;
begin
  fillchar(empty, sizeof(empty), 0);
  assign(input, fin); reset(input);
  readln(n, m);
  for p.x := 1 to n do begin
    readln(s);
    i := 1; while i <= length(s) do if s[i] = ' ' then delete(s, i, 1) else inc(i);
    for p.y := 1 to m do begin
      s[p.y] := upcase(s[p.y]);
      if s[p.y] <> 'S' then empty[p.x, p.y] := 1;
      if s[p.y] = 'M' then pusher := p else
      if s[p.y] = 'P' then start := p else
      if s[p.y] = 'K' then target := p;
    end;
  end;
  close(input);
end;

type
  tlist = object(tbase)
    head, l : integer;
    data : array[0 .. maxn * maxn + 1] of tnode;
    dupe : array[0 .. maxn + 1, 0 .. maxn + 1, 1 .. 4] of boolean;

    procedure prepare;
    procedure save(node : tnode);
    procedure search;
    procedure result;
  end;

var
  q : array[0 .. maxn * maxn + 1] of tpoint;

procedure tlist.prepare;
var
  i : integer;
  been : array[0 .. maxn + 1, 0 .. maxn + 1] of boolean;

procedure ssearch(x, y : integer);
var
  h, t : integer;
  i, nx, ny : integer;
begin
  h := 0; t := 1; q[1].x := x; q[1].y := y; been[x, y] := true;
  repeat
    inc(h);
    for i := 1 to 4 do begin
      nx := q[h].x + dx[i]; ny := q[h].y + dy[i];
      if been[nx, ny] or (empty[nx, ny] = 0) or (nx = start.x) and (ny = start.y) then continue;
      inc(t); q[t].x := nx; q[t].y := ny;
      been[nx, ny] := true;
    end;
  until h = t;
end;

begin
  tbase.prepare;
  fillchar(dupe, sizeof(dupe), 0); l := 0; head := 0;
  fillchar(been, sizeof(been), false);
  ssearch(pusher.x, pusher.y);
  for i := 1 to 4 do if been[start.x + dx[i], start.y + dy[i]] then begin
    l := 1;
    data[1].p := start; data[1].side := i;
  end;
  calcbelong;
end;

procedure tlist.save(node : tnode);
var
  i, nx, ny : integer;
begin
  with node do begin
    nx := p.x + dx[side]; ny := p.y + dy[side];
    for i := 1 to 4 do
      if dupe[p.x, p.y, i] and
         sameb(p.x + dx[i], p.y + dy[i], nx, ny) then exit;
    inc(l); data[l] := node;
    dupe[p.x, p.y, side] := true;
  end;
end;

procedure tlist.search;
var
  i : integer;
  box : tpoint;
  node : tnode;
begin
  while head < l do begin
    inc(head);
    box := data[head].p;
    with data[head] do
    for i := 1 to 4 do
    if sameb(box.x + dx[i], box.y + dy[i],
             box.x + dx[side], box.y + dy[side]) then begin
      node.p.x := box.x + dx[5 - i]; node.p.y := box.y + dy[5 - i];
      if empty[node.p.x, node.p.y] = 0 then continue;
      node.side := i; node.dep := dep + 1;
      save(node);
      if (node.p.x = target.x) and (node.p.y = target.y) then exit;
    end;
  end;
end;

procedure tlist.result;
begin
  assign(output, fout); rewrite(output);
  if (data[l].p.x <> target.x) or (data[l].p.y <> target.y) then
    writeln('NIE')
  else writeln(data[l].dep);
  close(output);
end;

var
  lst : tlist;

begin
  lst.prepare;
  lst.search;
  lst.result;
end.
