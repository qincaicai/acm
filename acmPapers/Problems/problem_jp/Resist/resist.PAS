{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q+,R-,S+,T-,V+,X+,Y+}
{$M 65520,0,655360}
program ex1;
const
    fin = 'resist.in';
    fon = 'resist.out';
    maxn = 16000;
type
    listptr     =       ^listnode;
    listnode    =       record
                          vex : integer;
                          next : listptr;
                        end;
    tarr        =       array[1..maxn]of integer;
    tcolor      =       array[1..maxn]of boolean;
    tadj        =       array[1..maxn]of listptr;
var
    time        :       longint absolute $40:$6c;
    tim0        :       longint;
    fi, fo              :       text;
    adj                 :       tadj;
    deg, leaf           :       ^tarr;
    color               :       ^tcolor;
    n, m,
    a, b,
    i,j,k               :       integer;
    p,q                 :       listptr;
    r                   :       ^listptr;

procedure Init;
  begin
  assign(fi,fin); reset(fi);
  readln(fi,n); m:=0;
  for k:=1 to n do adj[k]:=nil;
  readln(fi,i,j);
  while (i>0)and(j>0) do
    begin
    inc(deg^[i]); inc(deg^[j]); inc(m);

    p:=adj[i]; new(adj[i]);
    adj[i]^.vex:=j;
    adj[i]^.next:=p;

    p:=adj[j]; new(adj[j]);
    adj[j]^.vex:=i;
    adj[j]^.next:=p;

    readln(fi,i,j);
    end;
  close(fi);
  end;
procedure Done;
  begin
  assign(fo,fon); rewrite(fo);
  k:=0;
  for i:=1 to n do
    if color^[i]
      then inc(k);
  writeln(fo,k);
  for i:=1 to n do
    if color^[i] then
      writeln(fo,i);
  close(fo);
  end;
begin
  tim0:=time;
  new(deg); new(leaf); new(color);
  fillchar(deg^, sizeof(deg^), 0);
  init;

  fillchar(color^, sizeof(color^), false);
  a:=0; b:=0;
  for k:=1 to n do
    if deg^[k]=1 then
      begin inc(b); leaf^[b]:=k end;

  while a < b do
    begin
    inc(a); i:=leaf^[a];
    if deg^[i]<>1 then continue;
    j:=adj[i]^.vex;
{    if adj[i]^.next <> nil then writeln('eeee');}
    color^[j]:=true; deg^[j]:=0;
    p:=adj[j];
    while p <> nil do
      begin
      k:=p^.vex;
      if k <> j then
        begin
        r:=@adj[k];
        while r^^.vex <> j do
          r:=@r^^.next;
{        if r^^.vex <> j then
          writeln('eee');}
        q:=r^^.next;
{        dispose(r^);}
        r^:=q;
        dec(deg^[k]);
        if deg^[k]=1 then
          begin
          inc(b); leaf^[b]:=k;
          end;
        end;
      p:=p^.next;
      end;
    end;

  done;
  writeln('Time = ', (time-tim0)/18.2:0:2);
end.