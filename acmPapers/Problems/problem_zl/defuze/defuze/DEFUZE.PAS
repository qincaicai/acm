{$A+,B-,D-,E+,F-,G+,I-,L-,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y-}
{$M 65520,0,655360}

program Defuze;
type TGraph = array[1..102,1..102] of integer;	{ 整数类型的邻接矩阵 }
     TRGraph= array[1..102,1..102] of real;	{ 实数类型的邻接矩阵 }
     TList  = array[0..102] of integer;		
     TRList = array[0..102] of real;

var p:TRGraph;			{ 输入的可靠性表格 }
    m,n,k:integer;
    ps:real;			

var fin,fout:text;		{ 输入输出文件 }

procedure init;			{ 初始化 }
var i,j:integer;
begin
     assign(fin,'input.txt');
     reset(fin);
     assign(fout,'output.txt');
     rewrite(fout);
     readln(fin,m,n,k);

     for i:=1 to m do		{ 读入可靠性矩阵，并取对数，化和为积 }
         for j:=1 to n do
         begin
              read(fin,p[i,m+j]);
              p[i,m+j]:=-ln(p[i,m+j]);
         end;
     for i:=1 to m do p[m+n+1,i]:=0;
     for i:=1 to n do p[i,m+n+2]:=0;
end;

var f,c:^TGraph;
    w:TRList;
    lnk:TList;

procedure work;			{ 主过程 }

    procedure ExpandPath(var load:integer);	{ 求最小费用增广路径 }
    var i,j:integer;
        change:boolean;
    begin
         fillchar(lnk,sizeof(lnk),0);
         lnk[m+n+1]:=m+n+1;
         fillchar(w,sizeof(w),0);

	{ 用ford算法求最短路径 }
         repeat
               change:=false;
               for i:=1 to m+n+2 do
               if lnk[i]<>0 then
                   for j:=1 to m+n+2 do
                   if (c^[i,j]>0) and (f^[i,j]<c^[i,j]) then
                      if (lnk[j]=0) or
                         (w[i]+p[i,j]+1e-8<w[j]) then { 为了消除实数比较的误差，加上1e-8 }
                      begin
                           lnk[j]:=i;
                           w[j]:=w[i]+p[i,j];
                           change:=true;
                      end else
                   else
                   if (c^[j,i]>0) and (f^[j,i]>0) then
                      if (lnk[j]=0) or
                         (w[i]-p[j,i]+1e-8<w[j]) then { 为了消除实数比较的误差，加上1e-8  }
                      begin
                           lnk[j]:=-i;
                           w[j]:=w[i]-p[j,i];
                           change:=true;
                      end;
         until not change;

         if lnk[m+n+2]=0 then
         begin load:=0; exit; end;

	{ 计算增广路径的容量，并作为返回值load }

         i:=m+n+2;                load:=maxint;
         while (i<>m+n+1) do
         begin
              j:=abs(lnk[i]);
              if lnk[i]>0 then
                 if c^[j,i]-f^[j,i]<load then load:=c^[j,i]-f^[j,i] else
              else if f^[i,j]<load then load:=f^[i,j];
              i:=j;
         end;
    end;

var i,j:integer;
    load:integer;
begin
     ps:=0;
     new(c);
     fillchar(c^,sizeof(c^),0);
     new(f);
     fillchar(f^,sizeof(f^),0);

	{ 构造相应的容量网络, c[i，j]为弧（i，j）的容量 }
     for i:=1 to m do
         for j:=1 to n do c^[i,m+j]:=1;
     for i:=1 to m do c^[m+n+1,i]:=k;
     for i:=1 to n do c^[m+i,m+n+2]:=1;

	{ 求构造的容量网络的最小费用最大流 }

     ExpandPath(load);	        { 求增广路径 }
     while load<>0 do
     begin
	  { 沿着增广路径增加网络的流量 }
          i:=m+n+2;
          while i<>m+n+1 do
          begin
               j:=abs(lnk[i]);
               if lnk[i]>0 then f^[j,i]:=f^[j,i]+load
               else f^[i,j]:=f^[i,j]-load;
               i:=j;
          end;
          ps:=ps+w[m+n+2]*load; { 累计费用 }

          ExpandPath(load);	{ 求增广路径 }
     end;
end;

procedure over;		         { 输出，关闭文件 }
begin
     writeln(fout,exp(-ps):0:4);
     close(fin);
     close(fout);
end;

{ 主程序 }
begin
     init;
     work;
     over;
end.
