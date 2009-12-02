  {$I-,Q-,R-,S-}
program xmas;
uses xmas_p;
const
  MaxN=100000;
var
  tmp,avail:array[0..MaxN] of boolean;
  pos,list,d:array[1..MaxN] of longint;
  max,high,now,n,i,j,k:longint;
  first:boolean;
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
  now:=0; first:=true;
  repeat
    k:=0;
    while not avail[k] do
      k:=k+1;
    if not first then rotate(k-now);
    now:=k;
    high:=drop;
    j:=now+1;
    for i:=1 to n do
      begin
        list[d[j]]:=i;
        if j=n then j:=1
        else j:=j+1;
      end;
    if first then
      begin
        first:=false; filt;
      end;
    for i:=0 to n-1 do
      if avail[i] then
        begin
          max:=0;
          for j:=n downto high+1 do
            begin
              k:=i+list[j];
              if k>n then k:=k-n;
              if j-d[k]>max then
                begin
                  max:=j-d[k];
                  if max>high then break;
                end;
            end;
          if max<>high then avail[i]:=false;
        end;
  until false;
end.
