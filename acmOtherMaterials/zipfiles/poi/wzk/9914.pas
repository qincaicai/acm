program pie; {POI99_14}
var
  fa,sin,sout:array[1..1000] of longint;
  v:array[1..10000] of boolean;
  left,a,b,found,max,n,i,j,k,s,t:longint;
  f:text;

function getfa(no:longint):longint;
begin
  if fa[no]<0 then getfa:=no
  else
    begin
      fa[no]:=getfa(fa[no]);
      getfa:=fa[no];
    end;
end;

begin
  assign(f,'pie.in');
  reset(f);
  readln(f,n);
  fillchar(sin,sizeof(sin),0);
  fillchar(sout,sizeof(sout),0);
  fillchar(fa,sizeof(fa),0);
  fillchar(v,sizeof(v),0);
  max:=0;
  for i:=1 to n do
    begin
      readln(f,j,k);
      inc(sin[j]); inc(sout[k]);
      if j>max then max:=j;
      if k>max then max:=k;
      if fa[j]=0 then
        begin
          a:=j; fa[j]:=-1
        end
      else a:=getfa(j);
      if fa[k]=0 then
        begin
          b:=k; fa[k]:=-1
        end
      else b:=getfa(k);
      if a<>b then
        if fa[a]>fa[b] then
          begin
            fa[b]:=fa[b]+fa[a]; fa[a]:=b;
          end
        else
          begin
            fa[a]:=fa[a]+fa[b]; fa[b]:=a;
          end;
    end;
  s:=0; found:=0;
  for i:=1 to max do
    if sin[i]>sout[i] then
      begin
        if found=0 then found:=i;
        s:=s+sin[i]-sout[i];
        sout[i]:=sin[i];
        v[getfa(i)]:=true;
      end
    else if sout[i]>sin[i] then
      begin
        sin[i]:=sout[i];
        v[getfa(i)]:=true;
      end;
  left:=0;
  for i:=1 to max do
    if fa[i]<0 then left:=left+1;
  if found<>0 then s:=s-1;
  t:=0;
  for i:=1 to max do
    if (fa[i]<0) and not v[i] then
      begin
        t:=t+1;
      end;
  if (left=1) then t:=0
  else t:=(t+1) div 2;
  s:=s+t+n+1;
  writeln(s);
end.
