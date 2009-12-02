(* Problem   Genetic Code
** Algorithm Backtracking
** Runtime   O(3^n)
** Author    Walter Guttmann
** Date      12.03.2003
*)

program genetic;

var f: Text;
    s: array [0..8191] of Char;
    i, n: Longint;

function strncmp(i1, i2, l: Longint): Longint;
begin
  while l > 0 do begin
    if s[i1] < s[i2] then begin
      strncmp := -1;
      exit
    end else if s[i1] > s[i2] then begin
      strncmp := 1;
      exit
    end;
    i1 := i1 + 1;
    i2 := i2 + 1;
    l := l - 1
  end;
  strncmp := 0
end;

function isThue(e: Longint): Boolean;
var len: Longint;
begin
  isThue := False;
  for len := 1 to e div 2 do
    if strncmp(e-len-len, e-len, len) = 0 then
      exit;
  isThue := True;
end;

function backtrack(e: Longint): Boolean;
var ch: Char;
begin
  backtrack := True;
  if e = 5000 then
    exit;
  for ch := 'N' to 'P' do begin
    s[e] := ch;
    if isThue(e) then
      if backtrack(e+1) then
        exit
  end;
  backtrack := False
end;

begin
  backtrack(0);
  Assign(f, 'genetic.in');
  Reset(f);
  Read(f, n);
  while n <> 0 do begin
    for i := 0 to n-1 do
      Write(s[i]);
    WriteLn();
    Read(f, n)
  end;
  Close(f)
end.

