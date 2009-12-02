unit xmas_p;

interface
procedure StartGame;
procedure Rotate(k:longint);
function Drop:longint;

implementation
var
  real, started : boolean;
  call, n, rot : longint;
  discA:array[1..100000] of longint;

procedure EndGame(k:longint);
var
  f:Text;
begin
  if real then
  begin
    assign(f, 'xmas.out');
    rewrite(f);
    writeln(f, k);
    close(f);
  end
  else begin
    if k > 0 then writeln('Yes!')
    else writeln('No');
  end;
    halt;
end;

procedure Error;
var f:text;
begin
  if real then
  begin
    assign(f, 'xmas.out');
    rewrite(f);
    writeln(f, -1);
    close(f);
  end
  else writeln('Error');
  halt(0);
end;

procedure StartGame;
var
  f:text;
  i:longint;
begin
  if started then Error;
  assign(f, 'xmas.in');
  reset(f);
  read(f, n, rot);
  real := false;
  if rot = -1 then
  begin
    read(f, rot);
    real := true;
  end;
  for i:=1 to n do
    read(f, discA[i]);
  close(f);
  assign(f, 'xmas.dat');
  rewrite(f);
  writeln(f, n);
  for i:=1 to n do
    write(f, discA[i],' ');
  writeln(f);
  close(f);
  call := 0;
  started := true;
end;

procedure Rotate(k:longint);
begin
  if not started then Error;
  rot := (rot + k) mod n;
end;

function Drop:longint;
var
  max, i, v:longint;
begin
  if not started then Error;
  max := -n;
  inc(call);
  for i:=1 to n do
  begin
    v := discA[i] - discA[(i - rot + n - 1) mod n + 1];
    if v > max then max := v;
  end;
  if max = 0 then EndGame(call);
  if call = 5 then EndGame(0);
  Drop := max;
end;

begin
  started := false;
end.
