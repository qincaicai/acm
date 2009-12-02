  {$I-,Q-,R-,S-}
program Necklace;
const
  MaxLen=100010;
type
  Tstate=array[0..MaxLen] of longint;
var
  s,t:array[1..10] of longint;
  p1,p2,p3,oper:array[1..50] of longint;
  mod10,div10:array[0..99] of longint;
  dif,start,n,res,m,sa,sb:longint;
  a,b:Tstate;
  f:text;

procedure GetOper(var Oper:longint);
var
  ch:char;
  d:string;
begin
  read(f,ch); d:='';
  repeat
    d:=d+ch;
    if eoln(f) then break;
    read(f,ch);
  until ch=' ';
  if d='SETSTART' then Oper:=1
  else if d='SHIFT' then Oper:=2
  else if d='MUL' then Oper:=3
  else if d='ONDIGIT' then Oper:=4
  else Oper:=5;
end;

procedure GetNext(var dat,tmp:Tstate; var dif:longint);
var
  i,k:longint;

  procedure SetStart(a,b:longint);
  begin
    start:=0;
    k:=a;
    while b>0 do
      begin
        start:=start*10+dat[k];
        k:=k+1;
        if k=n then k:=0;
        b:=b-1;
      end;
    start:=start mod n;
  end;

  procedure Shift(l,x:longint);
  var
    i,j:longint;
  begin
    i:=start;
    for j:=1 to l do
      begin
        s[j]:=dat[i];
        i:=i+1;
        if i=n then i:=0;
      end;
    if x<=0 then k:=1-x
    else k:=l-x+1;
    i:=start;
    for j:=1 to l do
      begin
        if dat[i]<>s[k] then
          begin
            if dat[i]=tmp[i] then dif:=dif+1
            else if s[k]=tmp[i] then dif:=dif-1;
            dat[i]:=s[k];
          end;
        i:=i+1;
        if i=n then i:=0;
        if k=l then k:=1
        else k:=k+1;
      end;
  end;

  procedure Mul(l,x:longint);
  var
    i,j:longint;
  begin
    i:=start+l-1;
    if i>=n then i:=i-n;
    k:=0;
    for j:=1 to l do
      begin
        k:=k+dat[i]*x;
        if dat[i]<>mod10[k] then
          begin
            if dat[i]=tmp[i] then dif:=dif+1
            else if mod10[k]=tmp[i] then dif:=dif-1;
            dat[i]:=mod10[k];
          end;
        k:=div10[k];
        if i=0 then i:=n-1
        else i:=i-1;
      end;
  end;

begin
  i:=1; start:=0;
  while oper[i]<>5 do
    begin
      case oper[i] of
      1: SetStart(p1[i],p2[i]);
      2: Shift(p1[i],p2[i]);
      3: Mul(p1[i],p2[i]);
      4: if dat[p1[i]]=p2[i] then i:=p3[i]-1;
      end;
      i:=i+1;
    end;
end;

procedure Init;
var
  i:longint;
  ch:char;
begin
  assign(f,'necklace.in');
  reset(f);
  fillchar(a,sizeof(a),0);
  readln(f,n,m);
  for i:=0 to n-1 do
    begin
      read(f,ch);
      a[i]:=ord(ch)-ord('0');
    end;
  readln(f);
  for i:=1 to m do
    begin
      GetOper(oper[i]);
      case oper[i] of
      1,2,3: readln(f,p1[i],p2[i]);
      4:     readln(f,p1[i],p2[i],p3[i]);
      5:     readln(f);
      end;
    end;
  close(f);
  for i:=0 to 99 do
    begin
      mod10[i]:=i mod 10; div10[i]:=i div 10;
    end;
  sa:=1;
  b:=a; sb:=2;
  dif:=0;
  GetNext(b,a,dif);
end;

var
  starttime:longint;
  time:longint absolute $40:$6C;
begin
  starttime:=time;
  Init;
  while dif<>0 do
    begin
      sa:=sa+1; GetNext(a,b,dif);
      sb:=sb+1; GetNext(b,a,dif);
      sb:=sb+1; GetNext(b,a,dif);
    end;
  res:=0; b:=a; dif:=0;
  repeat
    res:=res+1;
    GetNext(b,a,dif);
  until dif=0;
  writeln(res);
  writeln((time-starttime)/18.2:0:2);
end.
