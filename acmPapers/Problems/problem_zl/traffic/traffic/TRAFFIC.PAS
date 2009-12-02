program Traffic;
type TGraph = array[1..50,1..50] of integer;	{ 用邻接矩阵表示的图类型 }
     TList  = array[0..50] of integer;		{ 用于求解最小费用增广路径的数组类型 }

var a,b:TGraph;					{ 输入的矩阵A，B }
    n,k:integer;
    cost:integer;				{ 扩容的总费用 }

var fin,fout:text;				{ 输入，输出文件 }

procedure init;					{ 初始化过程，独入矩阵A，B }
var i,j:integer;
begin
     assign(fin,'input.txt');
     reset(fin);
     assign(fout,'output.txt');
     rewrite(fout);
     readln(fin,n,k);
     for i:=1 to n do
         for j:=1 to n do read(fin,a[i,j]);
     for i:=1 to n do
         for j:=1 to n do read(fin,b[i,j]);
end;

var f,arc:TGraph;		{ f为每一条弧上的流量，arc为当前图上每一条弧的费用 }
    lnk,w:TList;

procedure work;			{ 主过程 }
var saturation:boolean;		{ 扩容开始标志 }

          procedure ExpandPath(var load:integer);	{ 求解最小费用增广路径，返回路径的容量 }
          var i,j:integer;
              change:boolean;
          begin
               { 根据当前弧上的流量计算每一条弧的费用 }
               for i:=1 to n do
               for j:=1 to n do
                   if (a[i,j]>0) then			{ 前向弧 }
                      if (f[i,j]<a[i,j]) then arc[i,j]:=0	
                      else arc[i,j]:=b[i,j]
                   else
                   if (a[j,i]>0) then			{ 后向弧 }
                      if (f[j,i]>0) and (f[j,i]<a[j,i]) then
                         arc[i,j]:=0
                      else
                      if (f[j,i]>a[j,i]) then
                         arc[i,j]:=-b[j,i]
                      else arc[i,j]:=MaxInt
                   else arc[i,j]:=MaxInt;

               for i:=1 to n do w[i]:=MaxInt;
               w[1]:=0;
               fillchar(lnk,sizeof(lnk),0);

		{ 利用Ford算法求从顶点1到n的最短路径 }
               repeat
                     change:=false;
                     for i:=1 to n do
                         if w[i]<>MaxInt then
                             for j:=1 to n do
                             if (arc[i,j]<>MaxInt) and (w[i]+arc[i,j]<w[j]) then
                             begin
                                  w[j]:=w[i]+arc[i,j];
                                  if a[i,j]>0 then lnk[j]:=i
                                     else lnk[j]:=-i;
                                  change:=true;
                             end;
               until not change;

               if lnk[n]=0 then
               begin load:=0; exit; end;

		{ 求出增广路径的最大容量，使得增流的速度更快 }
               i:=n;     load:=Maxint;
               while (i<>1) do
               begin
                    j:=abs(lnk[i]);
                    if (lnk[i]>0) then
                       if (f[j,i]<a[j,i]) and (a[j,i]-f[j,i]<load) then load:=a[j,i]-f[j,i]
                          else if (f[j,i]>=a[j,i]) then saturation:=true  { 开始对道路扩容 }
				  else
                    else
                        if (f[i,j]>a[i,j]) and (f[i,j]-a[i,j]<load) then load:=f[i,j]-a[i,j]
                           else if (f[i,j]<=a[i,j]) and (f[i,j]<load) then load:=f[i,j] else;
                    i:=j;
               end;
               if load=Maxint then load:=k;
          end;

var i,j,load:integer;

begin
     cost:=0;                           saturation:=false;
     fillchar(f,sizeof(f),0);
     ExpandPath(load);			{ 求最小费用增广路径 }
     while (load<>0) and (k>0) do
     begin
          if saturation then		{ 已经开始扩容 }
          begin
               if load>k then load:=k;	{ 累计网络容量的增加量 }
               k:=k-load;
          end;
          i:=n;
          while (i<>1) do		{ 沿增广路径，按返回的容量值load来增加网络的流量 }
          begin
               j:=abs(lnk[i]);
               if lnk[i]>0 then
               begin
                    inc(f[j,i],load);
                    if f[j,i]>a[j,i] then
                       inc(cost,load*b[j,i]);
               end
               else begin
                         if f[i,j]>a[i,j] then
                            dec(cost,load*b[i,j]);
                         dec(f[i,j],load);
                    end;
               i:=j;
          end;
          ExpandPath(load);		{ 求最小费用增广路径 }
     end;
end;

procedure over;			{ 输出，关闭文件 }
var i,j:integer;
begin
     writeln(fout,cost);
     for i:=1 to n do
         for j:=1 to n do
         if f[i,j]>a[i,j] then writeln(fout,i,' ',j,' ',f[i,j]-a[i,j]);
     close(fin);
     close(fout);
end;

{ 主程序 }
begin
     init;
     work;
     over;
end.
