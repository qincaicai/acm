
{$M 60000,0,655360}

{$R+}

program Prove;

const
  name1       =      'prove.in5';
  name2       =      'prove.ou5';
  maxN        =      200;

var
  ouf         :     text;

type
  Tstr        =     string[200];

  TExpression =     object
                      st : Tstr;
                      bracket : array[1..maxN] of integer;
                      procedure Fill_Brackets(t1, t2 : integer);
                      procedure Generate(out, mid : integer);
                    end;

procedure Texpression.Fill_Brackets;
var i, L : integer;
    b    : array[1..maxN] of integer;
begin
  L := 0;
  for i := t1 to t2 do
    case st[i] of
      'a' : bracket[i] := 0;
      '(' : begin
              inc(L);
              b[L] := i;
            end;
      ')' : begin
              bracket[ b[L] ] := i;
              bracket[ i ] := b[L];
              dec(L);
            end;
    end;
end;

procedure TExpression.Generate;
var i : integer;
begin
  if mid < bracket[out+1]
    then begin
           delete(st, bracket[out+1], 1);
           delete(st, out+1, 1);
           insert('(', st, mid+1);
           insert(')', st, bracket[out]);
         end
    else begin
           i := bracket[out]-1;
           delete(st, i, 1);
           delete(st, bracket[i], 1);
           insert('(', st, out+1);
           insert(')', st, mid);
         end;
  writeln(ouf, '=', st);
  Fill_Brackets(out, bracket[out]);
end;

{Main}

var
  S1, S2 : TExpression;
  n      : integer;

procedure Init;
var inf : text;
begin
  assign(inf, name1);
  reset(inf);
  readln(inf, S1.st);
  n := byte(S1.st[0]);
  S1.Fill_Brackets(1, n);
  readln(inf, S2.st);
  S2.Fill_Brackets(1, n);
  close(inf);
end;

procedure AllSame(t1 : integer); forward;

procedure PositionSame(t1, mid : integer);
var m : integer;
begin
  m := s1.bracket[t1+1];
  if m = mid then exit;
  if m < mid
    then PositionSame(m+1, mid-1)
    else PositionSame(t1+1, mid+1);
  s1.Generate(t1, mid);
end;

procedure AllSame;
var m1, m2 : integer;
begin
  if Copy(s1.st, t1, s1.bracket[t1] - t1 + 1) =
     Copy(s2.st, t1, s2.bracket[t1] - t1 + 1) then exit;

  m1 := s1.bracket[t1+1];
  m2 := s2.bracket[t1+1];
  if m1 <> m2 then
    begin
      if m1 < m2
        then PositionSame(m1+1, m2-1)
        else PositionSame(t1+1, m2+1);
      s1.Generate(t1, m2);
    end;

  AllSame(t1 + 1);
  AllSame(m2 + 1);
end;

begin
  Init;
  assign(ouf, name2); rewrite(ouf);
  writeln(ouf, ' ', s1.st);
  AllSame(1);
  close(ouf);
end.
