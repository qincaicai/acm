(* Problem   Assistance Required
** Algorithm Precalculation
** Runtime   O(n*l[n])
** Author    Walter Guttmann
** Date      16.07.2000
*)

program assist;

const maxl: Longint = 33810;

var f: Text;
    l: array [0..4095] of Longint;
    b: array [0..33810] of Boolean;
    i, m, n, start: Longint;

begin
  (* precalculate all lucky numbers (the 3000th one is 33809) by simulation
  ** this would also suit the "Freiburg Method" for larger values of n
  *)
  for i := 0 to maxl do
    b[i] := True;
  start := 1;
  for n := 1 to 3000 do begin
    start := start+1;
    while not b[start] do
      start := start+1;
    l[n] := start;
    m := start;
    while m < maxl do begin
      b[m] := False;
      for i := 1 to start do begin
        m := m+1;
        while (m < maxl) and not b[m] do
          m := m+1
      end
    end
  end;
  Assign(f, 'assist.in');
  Reset(f);
  Read(f, n);
  while n <> 0 do begin
    WriteLn(l[n]);
    Read(f, n)
  end;
  Close(f)
end.

