  {$I-,Q-,R-,S-}
program xmas;
uses xmas_p;
const
  MaxN=100000;
var
  tmp,avail:array[0..MaxN-1] of boolean;
  pos,d:array[1..MaxN] of longint;
  high,n,i,j,k:longint;
  f:text;

procedure filt;
var
  i,j:longint;
begin
  fillchar(tmp,sizeof(tmp),false);
  for i:=1 to n do
    if d[i]>high then
      begin
        j:=pos[d[i]-high]-i;
        if j<0 then j:=j+n;
        j:=j+k;
        if j>=n then j:=j-n;
        tmp[j]:=true;
      end;
  for i:=0 to n-1 do
    avail[i]:=avail[i] and tmp[i];
end;

begin
  StartGame;
  assign(f,'xmas.dat');
  reset(f);
  readln(f,n);
  for i:=1 to n do
    read(f,d[i]);
  close(f);
  for i:=1 to n do
    pos[d[i]]:=i;
  fillchar(avail,sizeof(avail),true);
  randomize;
  repeat
    k:=0;
    for i:=0 to n-1 do
      if avail[i] then inc(k);
    j:=random(k)+1;
    for i:=0 to n-1 do
      if avail[i] then
        begin
          j:=j-1;
          if j=0 then
            begin
              k:=i; break;
            end;
        end;
    if k<>0 then rotate(k);
    high:=drop;
    if k<>0 then rotate(n-k);
    avail[k]:=false;
    filt;
    k:=0;
    for i:=0 to n-1 do
      if avail[i] then k:=k+1;
  until false;
end.
