{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q+,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,655360}
program DNA_Recombine;
const
    fin  =  'dna.in';
    fon  =  'dna.out';
    maxn  = 5000;
    infinite = 60000;
    { A-T  C-G }
    match : array[1..4]of integer = (2,1,4,3);
type
    arr            =       array[0..3,0..maxn]of word;
var
    time           :       longint absolute $40:$6c;
    tim0           :       longint;
    fi, fo         :       text;
    s, t           :       array[1..maxn]of byte;
    a, b, c        :       ^arr;
    best           :       word;
    ls, lt,
    c1, c2, c3,
    i,j,k          :       integer;

function Transform(ch : char) : byte;
  begin
  case upcase(ch) of
    'A': transform:=1;
    'T': transform:=2;
    'C': transform:=3;
    'G': transform:=4;
  end;
  end;

procedure Init;
  var ch : char;
  begin
  assign(fi,fin); reset(fi);
  readln(fi, c1, c2, c3);
  ls:=0;
  while not eoln(fi) do
    begin
    inc(ls); read(fi, ch);
    s[ls]:=transform(ch);
    end;
  readln(fi);
  lt:=0;
  while not eoln(fi) do
    begin
    inc(lt); read(fi, ch);
    t[lt]:=transform(ch);
    end;
  readln(fi);
  close(fi);
  end;

procedure Done;
  begin
  assign(fo,fon); rewrite(fo);
  best:=maxint;
  for i:=0 to ls do
    if b^[0,i] < best then
      best:=b^[0,i];
  writeln(fo,best);
  close(fo);
  end;

procedure Doing(i, j: integer);
  begin
  b^[0,j]:=infinite;

  b^[1,j]:=infinite;
  if (i>0)and(j>0)and(t[i]=s[j]) then
    begin
    if a^[1,j-1] < b^[1,j] then
      b^[1,j] := a^[1,j-1];
    if a^[0,j-1]+c1 < b^[1,j] then
      b^[1,j] := a^[0,j-1]+c1;
    end;
  if b^[1,j] < b^[0,j] then
    b^[0,j] := b^[1,j];

  b^[2,j]:=infinite;
  if (i>0)and(j>0)and(t[i]=match[s[j]]) then
    begin
    if a^[2,j-1] < b^[2,j] then
      b^[2,j] := a^[2,j-1];
    if a^[0,j-1]+c1 < b^[2,j] then
      b^[2,j] := a^[0,j-1]+c1;
    end;
  if b^[2,j] < b^[0,j] then
    b^[0,j] := b^[2,j];

  b^[3,j]:=infinite;
  if (j>0) then
    begin
    if b^[3,j-1] < b^[3,j] then
      b^[3,j] := b^[3,j-1];
    if (b^[0,j-1]+c2 < b^[3,j]) then
      b^[3,j] := b^[0,j-1]+c2;
    end;
  if b^[3,j] < b^[0,j] then
    b^[0,j] := b^[3,j];

  if (i>0) and (a^[0,j]+c3 < b^[0,j]) then
    b^[0,j] := a^[0,j]+c3;
  end;

procedure Dynamic;
  begin
  for i:=0 to lt do
    begin
    if i = 0 then begin
      new(a); new(b);
      b^[0,0]:=0; b^[1,0]:=infinite; b^[2,0]:=infinite;
      for j:=1 to ls do
        doing(i,j);
      end
    else begin
      c:=a; a:=b; b:=c;
      for j:=0 to ls do
        doing(i,j);
      end;
    end;
  end;

begin
  tim0:=time;
  init;
  dynamic;
  done;
  writeln('Time = ', (time-tim0)/18.2:0:2 );
end.