(* Problem   Histogram
** Algorithm Recursive
** Runtime   O(n)
** Author    Walter Guttmann
** Date      12.01.2003
*)

program histogram;

type Long = Real;
var f: Text;
    h: array [0..1048575] of Long;
    max_area: Long;
    i, n: Longint;

function max(x, y: Long): Long;
begin
  if x < y then max := y else max := x
end;

function calc_max_area(r, left: Longint; low: Long): Longint;
var next: Longint;
begin
  next := r+1;
  if (next < n) and (h[r] < h[next]) then
    next := calc_max_area(next, next, h[r]+1);
  max_area := max(max_area, (next-left)*h[r]);
  if (next = n) or (h[next] < low) then
    calc_max_area := next
  else
    calc_max_area := calc_max_area(next, left, low)
end;

begin
  Assign(f, 'histogram.in');
  Reset(f);
  Read(f, n);
  while n <> 0 do begin
    for i := 0 to n-1 do
      Read(f, h[i]);
    max_area := 0;
    calc_max_area(0, 0, 0);
    WriteLn(max_area:0:0);
    Read(f, n)
  end;
  Close(f)
end.

