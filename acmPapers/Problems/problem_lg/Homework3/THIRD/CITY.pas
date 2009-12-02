Const
   Fin='City.Inp';				{输入文件名}
   Fou='City.Out';				{输出文件名}
   Big=1000000;					{极大值}

Type
   Maps=array[1..50,1..50] of Real;		{地图类型定义}

Var
  Map:^maps;					{城市地图}
  Val:array[0..10] of ^maps;			{修改了K条边后的距离列表}
  F:text;					{文件说明}
  Way:array[0..10,1..50,1..50,1..2] of byte;	{打印结果用的记录变化的数组}
  N,M:integer;

  Procedure  Init;				{初始化过程，输入数据}
  Var
      i,j:integer;
    Begin
       assign(f,fin);
       Reset(f);
         ReadlN(f,n,m);
         new(map);
         For i:=1 to n do
          Begin
            for j:=1 to n do
               read(f,map^[i,j]);
            readln(f);
          end;
       CLose(f);
    end;

  Procedure main;				{应用“动态规划”算法求解的过程}
  Var
    i,j,k,p,q:integer;
    R:real;
    Begin
      R:=1;
      Fillchar(way,sizeof(way),0);
      New(Val[0]);
      val[0]^:=map^;

      For k:=1 to n do				{动态规划数组初始化}
       for i:=1 to n do
        if val[0]^[i,k]>0 then
        for j:=1 to n do
          if (Val[0]^[k,j]>0) and (i<>j) then
           if (val[0]^[i,j]=0) or (Val[0]^[i,j]>Val[0]^[i,k]+Val[0]^[k,j]) then
            begin
              Val[0]^[i,j]:=Val[0]^[i,k]+Val[0]^[k,j];
              Way[0][i,j,1]:=0;
              Way[0][i,j,2]:=k;
            end;

      For p:=1 to m do
        Begin
          new(val[p]);				{求改进P条边后的最优距离列表}
          For i:=1 to n do			{对一条边修改P次后的距离}
            for j:=1 to n do
              map^[i,j]:=map^[i,j]/2;

          Val[p]^:=map^;			{初始化}

          For k:=1 to n do			{利用Folyd算法求解}
           for i:=1 to n do
           if Val[0]^[i,k]>0 then
            for j:=1 to n do
            if (Val[0]^[k,j]>0) and (i<>j)then
              Begin
                  For q:=1 to p-1 do		{动态规划过程，选取最优的修改方案}
                    if (Val[p]^[i,j]=0) or  (Val[p]^[i,j]>Val[q]^[i,k]+Val[p-q]^[k,j]) then
                     Begin
                       Val[p]^[i,j]:=Val[q]^[i,k]+Val[p-q]^[k,j];
                       way[p,i,j,1]:=q;
                       way[p,i,j,2]:=k;
                     end;

                   if Val[p]^[k,j]>0 then
                     if (val[p]^[i,j]=0) or (Val[p]^[i,j]>Val[0]^[i,k]+Val[p]^[k,j]) then
                       Begin
                          Val[p]^[i,j]:=Val[0]^[i,k]+Val[p]^[k,j];
                          way[p,i,j,1]:=0;
                          way[p,i,j,2]:=k;
                       end;
                   if Val[p]^[i,k]>0 then
                     if (val[p]^[i,j]=0) or (Val[p]^[i,j]>Val[p]^[i,k]+Val[0]^[k,j]) then
                       Begin
                          Val[p]^[i,j]:=Val[p]^[i,k]+Val[0]^[k,j];
                          way[p,i,j,1]:=p;
                          way[p,i,j,2]:=k;
                       End;
              End;
        End;
    End;

 Procedure Print;			{输出结果}
      Procedure Pr(l,r,k:integer);	{利用递归方式输出结果}
        Var
          i:integer;
          Begin
            if way[k,l,r,2]=0 then
              Begin
                for i:=1 to k do
                  writelN(f,l,' ',r);
              end
             Else
               begin
                  pr(l,way[k,l,r,2],way[k,l,r,1]);
                  pr(way[k,l,r,2],r,k-way[k,l,r,1]);
               end;
          end;
   Begin
      assign(f,fou);
      rewrite(f);
        writeln(f,Val[m]^[1,n]:0:2);
        Pr(1,n,m);
      Close(f);
   End;

Begin	{主过程}
   Init;	{输入数据}
   Main;	{求解}
   Print;	{输出数据}
End.