program rez; {POI97_13}
var
  max,n,i,j,k:longint;
  hash,d:array[0..30000] of longint;
  next,s,t:array[1..10000] of longint;
  f:text;
begin
  assign(f,'rez.in');
  reset(f);
  readln(f,n);
  fillchar(hash,sizeof(hash),0);
  fillchar(d,sizeof(d),0);
  fillchar(next,sizeof(next),0);
  max:=0;
  for i:=1 to n do
    begin
      readln(f,s[i],t[i]);
      if t[i]>max then max:=t[i];
      if hash[s[i]]=0 then
        begin
          hash[s[i]]:=i; d[s[i]]:=i;
        end
      else
        begin
          j:=d[s[i]]; next[j]:=i;
          d[s[i]]:=i;
        end;
      s[i]:=t[i]-s[i];
    end;
  close(f);
  fillchar(d,sizeof(d),0);
  d[0]:=0;
  for i:=0 to max-1 do
    begin
      if d[i]>d[i+1] then
        d[i+1]:=d[i];
      j:=hash[i];
      while j<>0 do
        begin
          if d[t[j]]<d[i]+s[j] then
            d[t[j]]:=d[i]+s[j];
          j:=next[j];
        end;
    end;
  assign(f,'rez.out');
  rewrite(f);
  writeln(f,d[max]);
  close(f);
end.
