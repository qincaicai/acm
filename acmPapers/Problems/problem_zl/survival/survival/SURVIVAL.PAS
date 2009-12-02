{$A+,B-,D-,E+,F-,G+,I-,L-,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y-}
{$M 65520,0,655360}

program Survival;

uses Zoology;

type TXStates= array[0..200] of longint;
     TStates = array[0..100] of ^TXStates;	     { 记录一个阶段状态[Y，X]的二维数组 }
var xy:array[0..1] of TStates;			     { 保存的两个相邻阶段 }

    range:array[0..1] of record			     { 保存两个阶段中可行状态的边界值 }
                               minx,maxx:integer;
                               miny,maxy:integer;
                         end;
    a,b,c,d:real;
    x0,y0,alpha,beta:integer;
    n:integer;
    l:longint;

var fin,fout:text;		{ 输入输出文件 }

procedure init;			{ 读入数据，初始化第0 阶段的状态 }
var i,j:integer;
begin
     assign(fin,'input.009');
     assign(fout,'output.009');
     reset(fin);
     rewrite(fout);
     readln(fin,a,b,c,d,x0,y0,alpha,beta,n,l);
     for i:=0 to 100 do
     begin
          new(xy[0][i]);
          new(xy[1][i]);
          for j:=0 to 200 do xy[0][i]^[j]:=-1;
     end;
     xy[0][y0]^[x0]:=0;
     range[0].minx:=x0;          range[0].maxx:=x0;
     range[0].miny:=y0;          range[0].maxy:=y0;
end;

function max(a,b:integer):integer;		{ 函数，返回两数之中较大的 }
begin
     if a<b then max:=b else max:=a;
end;

var nu:longint;				{ 用于记录最大营养总值 }

procedure work;				{ 主过程 }
var month,i,j,id,id2:integer;

    maxkx,maxky,kx,ky:integer;

begin
     for month:=0 to n-1 do		{ month为当前递推的阶段数 }
     begin
		{ 计算当前相邻两阶段的储存位置 }
          id:=month mod 2;              id2:=(month+1)mod 2;

		{ 初始化下一阶段的所有状态 }
          for i:=0 to 100 do for j:=0 to 200 do xy[id2][i]^[j]:=-1;
          with range[id2] do
          begin
               minx:=200;       maxx:=-1;
               miny:=200;       maxy:=-1;
          end;

          for j:=range[id].miny to range[id].maxy do
              for i:=range[id].minx to range[id].maxx do
                  if xy[id][j]^[i]<>-1 then	{ 枚举当前阶段的所有可行状态 }
                  begin
                       ZInit(a,b,c,d,i,j);
                       ZProcess(0,0,maxkx,maxky);
                       for ky:=max(0,(L-alpha*maxkx)div beta) to maxky do
                           for kx:=max(0,(L-beta*ky)div alpha) to maxkx do
                               if (alpha*kx+beta*ky>=L) and  { 枚举所有可行的捕捉计划kx，ky }
				  (xy[id2][maxky-ky]^[maxkx-kx]<xy[id][j]^[i]+alpha*kx+beta*ky)
                               then
                               begin
					{ 保存较优的递推结果 }
                                    xy[id2][maxky-ky]^[maxkx-kx]:=xy[id][j]^[i]+alpha*kx+beta*ky;

                                    with range[id2] do	{ 记录边界 }
                                    begin
                                         if maxky-ky<miny then miny:=maxky-ky;
                                         if maxky-ky>maxy then maxy:=maxky-ky;
                                         if maxkx-kx<minx then minx:=maxkx-kx;
                                         if maxkx-kx>maxx then maxx:=maxkx-kx;
                                    end;
                               end;
                  end;
          if range[id2].maxx=-1 then	{ 如果下一阶段中没有得到可行的状态 }
          begin nu:=-1; exit; end;	{ 无解，退出 }
     end;

	{ 在第n个阶段的状态中寻找最优解 }
     id:=n mod 2;               nu:=0;
     for i:=range[id].miny to range[id].maxy do
         for j:=range[id].minx to range[id].maxx do
             if xy[id][i]^[j]>nu then nu:=xy[id][i]^[j];
end;

procedure over;		{ 输出，关闭文件 }
begin
     writeln(fout,nu);
     close(fin);
     close(fout);
end;

{ 主程序 }
begin
     init;
     work;
     over;
end.
