
{$R+,Q+}

program Doomsday_Calculating;

const
  name1     =    'date.ina';
  name2     =    'date.oua';
  maxN      =    200;
  maxP      =    100;
  LimitAns  =    1000000000;

type
  Tarr      =    array[1..maxN] of integer;

var
  ans          :    longint;
  data         :    array[1..maxP] of Tarr;
  NowP, NextC  :    Tarr;
  n, p         :    integer;
  Par          :    array[0..maxN] of record
                                        F, C : longint;
                                      end;

function LCM(a, b : longint) : longint;
var x, y, z : longint;
begin
  x := a; y := b;
  while x mod y <> 0 do
    begin
      z := x mod y;
      x := y; y := z;
    end;
  if a div y >= ans div b + 1
    then LCM := ans
    else LCM := a div y * b;
end;

procedure NextPosition(const a, b : Tarr; var c : Tarr);
var i : integer;
begin
  fillchar(c, sizeof(c), 0);
  for i := 1 to n do c[i] := b[ a[i] ];
end;

procedure Init;
var inf  : text;
    i, j : integer;
begin
  assign(inf, name1); reset(inf);
  readln(inf, n, p);
  for j := 1 to n do
    for i := 1 to p do
      read(inf, data[i, j]);
  close(inf);
end;

procedure TakeFC;
var i, j : integer;
    thisA, thisL, L : longint;
    Find : boolean;
begin
  for i := 1 to n do
    for j := i+1 to n do
      if Par[i].C < Par[j].C then
        begin
          Par[0] := Par[i];
          Par[i] := Par[j];
          Par[j] := Par[0];
        end;
  thisA := Par[1].F;
  thisL := Par[1].C;
  for i := 2 to n do
    begin
      L := LCM(thisL, Par[i].C);
      Find := false;
      repeat
        if (thisA >= Par[i].F) and
           ( (thisA - Par[i].F) mod Par[i].C = 0 )
          then begin
                 Find := True;
                 Break;
               end;
        if thisA > L - thisL then Break;
        inc(thisA, thisL);
      until false;
      if Find then thisL := L
        else Exit;
    end;
  if thisA < ans then ans := thisA;
end;

procedure InitArr(var a : Tarr);
var i : integer;
begin
  fillchar(a, sizeof(a), 0);
  for i := 1 to n do a[i] := i;
end;

function FillFC(const Posi : Tarr; FA : longint) : boolean;
var i, j, k : integer;
    ok      : array[1..maxN] of boolean;
begin
  FillFC := False;
  {first time}
  for i := 1 to n do
    begin
      fillchar(ok, sizeof(ok), true);
      j := Posi[i];
      k := 0;
      while (j <> i) and ok[j] do
        begin
          ok[j] := false;
          inc(k);
          j := NextC[j];
        end;
      if j <> i then Exit;
      if k < ans div p
        then Par[i].F := k * p + FA
        else Par[i].F := ans;
    end;
  {cycle appears}
  for i := 1 to n do
    begin
      fillchar(ok, sizeof(ok), true);
      j := i;
      k := 0;
      repeat
        inc(k);
        j := NextC[j];
        if not ok[j] then exit;
        ok[j] := false;
      until j = i;
      if k < ans div p
        then Par[i].C := k * p
        else Par[i].C := ans;
    end;
  FillFC := True;
end;

procedure Main;
var i, j, k : integer;
    temp, temp2 : Tarr;
begin
  InitArr(NowP);
  for i := 1 to p do
    begin
      NextPosition(NowP, data[i], temp);
      NowP := temp;
      InitArr(temp);
      k := i;
      for j := 1 to p do
        begin
          k := k mod p + 1;
          NextPosition(temp, data[k], temp2);
          temp := temp2;
        end;
      NextC := temp;
      if FillFC(NowP, i)
        then TakeFC;
    end;
end;

procedure Out;
var ouf : text;
begin
  assign(ouf, name2); rewrite(ouf);
  if ans < LimitAns then writeln(ouf, ans)
    else writeln(ouf, 'No one knows.');
  close(ouf);
end;

begin
  ans := LimitAns;
  Init;
  Main;
  Out;
end.
