(*
  Highway
*)
{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}

const fnIn ='Highway.in';
      fnOut='Highway.out';
      LimHills=50;{limited}
      BigNum=1e200;

type TRealNum=double; {control real numbers' precision}
     TPoint=Record x,y:TRealNum;end;
     TLine=Record a,b,c:TRealNum;end; {line type}

var ucFlat:integer; {unit cost of building flat-roads}
    ucTn:array[1..LimHills] of integer; {unit cost of building tunnels}

    Hill:array[0..LimHills,1..5] of TPoint; {points of hills}
    Cost,Ln:array[0..LimHills+1,1..4]of TRealNum; {cost table/road length}
    HillLine:array[1..LimHills,1..4]of Tline; {each side-line}

    ptA,ptB:TPoint; {start/end point}
    n:byte;
    SM:TRealNum; {total Square Measure}

procedure init;
var i,j,k:integer;
begin
  assign(input,fnIn);reset(input);
  readln(ptA.x,ptA.y);readln(ptB.x,ptB.y);
  readln(ucFlat);readln(n);
  for i:=1 to n do
    begin
      read(ucTn[i]);
      for j:=1 to 4 do read(hill[i,j].x,hill[i,j].y);
      hill[i,5]:=hill[i,1];
      readln;
      for j:=1 to 4 do with HillLine[i,j] do
        begin
          a:=hill[i,j+1].y-hill[i,j].y;
          b:=hill[i,j].x-hill[i,j+1].x;
          c:=hill[i,j].y*(hill[i,j+1].x-hill[i,j].x)
              -hill[i,j].x*(hill[i,j+1].y-hill[i,j].y);
        end;
    end;
  close(input);
  for i:=1 to 5 do hill[0,i]:=ptA;
  for i:=1 to 5 do hill[n+1,i]:=ptB;
  fillchar(cost[0],sizeof(cost[0]),0);
  fillchar(ln,sizeof(ln),0);
end;

function GetDistance(p1,p2:Tpoint):TRealNum;
begin
  GetDistance:=sqrt(sqr(p1.x-p2.x)+sqr(p1.y-p2.y));
end;

procedure CalcSM;
{Calculate total square measure}
var i,j,k:integer;
begin
  SM:=0;
  for i:=1 to n do
    for j:=2 to 5 do
      SM:=SM+0.5*(hill[i,j-1].x-hill[i,j].x)*(hill[i,j-1].y+hill[i,j].y);
  SM:=abs(SM);
end;

function CrossPoint(l1,l2:Tline;var p:Tpoint):boolean;
{get the crossing point of 2 lines}
begin
  if (l1.a*l2.b=l2.a*l1.b)or(l1.b*l2.a=l2.b*l1.a) then
    begin CrossPoint:=false;exit;end;
  p.x:=(l1.b*l2.c-l2.b*l1.c)/(l1.a*l2.b-l2.a*l1.b);
  p.y:=(l1.a*l2.c-l2.a*l1.c)/(l1.b*l2.a-l2.b*l1.a);
  CrossPoint:=true;
end;

function TroughLength(x1,y1,x2,y2:TRealNum;h:byte):TRealNum;
{get the length of the part within the hill h}
var i,j,k,TotCrs:integer;
    l:TLine;{line (x1,y1)-(x2,y2)}
    p:Tpoint;
    len,r:TRealNum;
    temp:array[1..5]of TRealNum;{temporary maths variable}
    CrsP:array[1..4]of Tpoint;{Crossing points}
    inner:array[1..4]of boolean;
     {whether the corssing point is `inside'(not the end point)}
begin
  l.a:=y2-y1;l.b:=x1-x2;l.c:=y1*(x2-x1)-x1*(y2-y1);
  TroughLength:=0;
  len:=0;TotCrs:=0;
  for i:=1 to 5 do
    temp[i]:=l.a*hill[h,i].x+l.b*hill[h,i].y+l.c;
  if  ((temp[1]>=0)and(temp[2]>=0)and(temp[3]>=0)and(temp[4]>=0)) or
      ((temp[1]<=0)and(temp[2]<=0)and(temp[3]<=0)and(temp[4]<=0)) then exit;
  for i:=1 to 4 do
    if (temp[i]*temp[i+1]<=0) and
       ((hillline[h,i].a*x1+hillline[h,i].b*y1+hillline[h,i].c)*
            (hillline[h,i].a*x2+hillline[h,i].b*y2+hillline[h,i].c)<=0) then
       begin
         if temp[i+1]=0 then
           if temp[i]*temp[(i+1)mod 4 +1]<0 then continue;
         if not CrossPoint(l,hillline[h,i],p) then continue;
         inc(TotCrs);CrsP[TotCrs]:=p;
         if (temp[i]=0)or(temp[i+1]=0)
            then inner[TotCrs]:=false else inner[TotCrs]:=true;
       end;
  j:=1;
  if TotCrs<=1 then exit;
  if TotCrs=3     {a special shape}
    then begin
      for i:=1 to 3 do if inner[i] then break;
      len:=BigNum;
      for j:=1 to 3 do if i<>j then
        begin r:=getdistance(CrsP[i],CrsP[j]);if r<len then len:=r;end;
     end
    else          {common shapes}
      for i:=1 to TotCrs do
        begin
          len:=len+j*sqrt(sqr(CrsP[i].x-x1)+sqr(CrsP[i].y-y1));
          j:=-j;
        end;
  TroughLength:=abs(len);
end;

function GetCost(p1,p2:TPoint):TRealNum;
{get the cost of building a road between 2 points p1 & p2}
var i:integer;
    flat, {length of the flat part}
    TnCost, {cost of building tunnels}
    tl :TRealNum;
begin
  flat:=sqrt(sqr(p1.x-p2.x)+sqr(p1.y-p2.y));TnCost:=0;
  for i:=1 to n do
    begin
      tl:=TroughLength(p1.x,p1.y,p2.x,p2.y,i);
      TnCost:=TnCost+ucTn[i]*tl;
      flat:=flat-tl;
    end;
  GetCost:=flat*ucFlat+TnCost;
end;

procedure Search;
{search a best way}
{perform a Dijkstra algorithm}
const qNew=0;
      qAdded=1;
      qExpanded=2;
var q:array[0..250]of record  h,p:byte;end; {expanding queue}
    qd:array[0..LimHills+1,1..4]of byte; {whether it's been queued}
    ft,re,
    i,j,k:integer;
    h:TrealNum;
begin
  for i:=1 to n+1 do for j:=1 to 4 do cost[i,j]:=bignum;
  fillchar(qd,sizeof(qd),0);
  ft:=0;re:=1;q[1].h:=0;q[1].p:=1;
  repeat
    inc(ft);
    {find then min element:}
    for i:=ft+1 to re do
      if cost[q[i].h,q[i].p]<cost[q[ft].h,q[ft].p] then
        begin q[0]:=q[ft];q[ft]:=q[i];q[i]:=q[0];end;
    qd[q[ft].h,q[ft].p]:=qExpanded;
    if q[ft].h=n+1 then exit; {get the road!}
    {expand it}
    for i:=1 to n+1 do
      for j:=1 to 4 do if qd[i,j]<>qExpanded then
        begin
          h:=GetCost(hill[q[ft].h,q[ft].p],hill[i,j]);
          if cost[q[ft].h,q[ft].p]+h<cost[i,j] then
            begin
              if qd[i,j]=qNew then
                begin
                  qd[i,j]:=qAdded;
                  inc(re);q[re].h:=i;q[re].p:=j;
                end;
              cost[i,j]:=cost[q[ft].h,q[ft].p]+h;
              ln[i,j]:=ln[q[ft].h,q[ft].p]+
                       getdistance(hill[q[ft].h,q[ft].p],hill[i,j]);
            end;
        end;
  until ft>=re;
end;

procedure done;
begin
  assign(output,fnOut);rewrite(output);
  writeln(SM:0:2);
  writeln(ln[n+1,1]:0:2);
  writeln(cost[n+1,1]:0:2);
  close(output);
end;

Begin
  init;
  CalcSM;
  Search;
  done;
End.