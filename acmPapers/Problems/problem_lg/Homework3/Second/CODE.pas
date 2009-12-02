Const
  Fin='Code.inp';			{输入文件名}
  Fou='Code.out';			{输出文件名}

Type
  Us=array[1..1000] of integer;		{数组类型说明}

Var
  F:text;				{文件变量}
  C,d,t1,t2:longint;			{时刻变量}
  N:integer;				{密码长度}
  Dan,Zi1,Zi2:us;			{记录输入密码的变量}
  Use,U1,U2,Mid,P,Q:us;			{记录求解过程中应用的变量}

  Procedure Init;			{初始化过程，输入数据}
   Var
     i:integer;
     j:longint;
    Begin
       Assign(f,fin);
       reset(f);
         readln(f,n,c);
          read(f,t1);
          For i:=1 to n do
             read(f,zi1[i]);
          readln(f);
          read(f,t2);
          for i:=1 to n do
            read(f,zi2[i]);
          if t1<t2 then
           Begin
              use:=zi1;zi1:=zi2;
              zi2:=use;
              j:=t1;t1:=t2;t2:=j;
           end;
       close(f);
    end;

  Procedure Main;			{求解过程}
  var
      i,j:integer;

         Function Euclid(t1,t2:Longint):Longint;	{求两个数最大公约数的Euclid算法}
         var
             x:longint;
           Begin
             while t1 mod t2>0 do
               Begin
                 x:=t2;
                 t2:=t1 mod t2;
                 t1:=x;
               end;
             euclid:=t2;
           end;

         Procedure Jia(Var P:us;Z:us);			{“加法”对应的密码变换}
         Var
            i:integer;
           Begin
              q:=p;
              for i:=1 to n do
                p[i]:=q[z[i]];
           End;

         Procedure Jian(Var P:us;Z:us);			{“减法”对应的密码变换}
           Var
             i:integer;
             Begin
               q:=p;
               For i:=1 to n do
                p[z[i]]:=q[i];
             End;

        Procedure Cheng(Var Zi:us;K:longint);		{“乘法”对应的密码变换}
        Var
          i:integer;

          Begin
            for i:=1 to n do
              p[i]:=i;

             While K>0 do				{利用“二进制”方法求解}
               Begin
                 If  k mod 2=1 Then
                     jia(p,zi);
                 k:=k div 2;
                 jia(zi,zi);
               End;
             zi:=p;
          End;

        Procedure Euclid_Big(T1,T2:Longint);		{仿Euclid算法的密码转换方法}
         Var
             X,K:Longint;
          Begin
            While t1 mod t2<>0 do
              Begin
                x:=t2;
                k:=t1 div t2;
                t2:=t1 mod t2;
                t1:=x;

                use:=zi2;
                cheng(use,k);
                jian(zi1,use);

                mid:=zi2;
                zi2:=zi1;
                zi1:=mid;
              End;
             dan:=zi2;
          end;

    Begin
       D:=euclid(t1,t2);
       Assign(f,fou);
       Rewrite(f);
       If C mod D<>0 Then			{无解情况}
          writeln(F,'No Answer')
         Else
           Begin
              c:=c div d;			
              euclid_big(t1,t2);		{求对应最大公约数D的密码}	
              cheng(dan,c);			{利用乘法求解}	
              For i:=1 to n do
                Write(f,dan[i],' ');		{输出}
           End;
       Close(f);
    end;

Begin			{主程序}
   Init;		{读入数据}			
   Main;		{计算}
End.