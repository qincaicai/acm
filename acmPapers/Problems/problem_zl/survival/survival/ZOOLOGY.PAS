Unit Zoology;

interface
{ 过程定义与原题中给出的相同 }
procedure ZInit(ia,ib,ic,id:real;x0,y0:integer);
procedure ZProcess(kx,ky:integer; var rx,ry:integer);
procedure ZIngathering(var gx,gy:integer);

implementation
var a,b,c,d:real;
    x,y:longint;
    sgx,sgy:integer;

procedure ZInit(ia,ib,ic,id:real;x0,y0:integer);  { 读入参数，初始化 }
begin
     a:=ia;
     b:=ib;
     c:=ic;
     d:=id;
     x:=x0;
     y:=y0;
     sgx:=0;
     sgy:=0;
end;

procedure ZProcess(kx,ky:integer; var rx,ry:integer); { 递推过程 }
var xx,yy:longint;
begin
     xx:=x+round((a-b*y)*x)-kx;		{ 递推式参见解题说明 }
     yy:=y+round((-c+d*x)*y)-ky;
     if xx<0 then x:=0 else		{ 边界检查 }
        if xx>200 then x:=200
           else x:=xx;
     if yy<0 then y:=0 else		{ 边界检查 }
        if yy>100 then y:=100
           else y:=yy;
     inc(sgx,kx);			{ 累计捕捉量 }
     inc(sgy,ky);
     rx:=x;				{ 返回值 }
     ry:=y;
end;

procedure ZIngathering(var gx,gy:integer);
begin
     gx:=sgx;
     gy:=sgy;
end;

begin
end.
