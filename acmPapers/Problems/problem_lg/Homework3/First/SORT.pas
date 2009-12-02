Const
  Max=10000;				{数组界限}
  Fin='Sort.Inp';			{输入文件名}
  Fou='Sort.Out';			{输出文件名}

Type
   Zis=array[1..max] of Real;		{数组类型说明}

Var
   Tot:longint;				{“逆序对”总数}
   N:integer;				{数组大小}
   Zi,Use:^zis;				{记录数列的数组}
   F:Text;				{文件变量说明}

  Procedure Init;			{初始化过程，输入数据}
  Var
    i:integer;
    Begin
      New(zi);
      New(use);
      Assign(f,fin);
      Reset(f);
        Readln(f,n);
        For i:=1 to n do
          read(f,zi^[i]);
      Close(f);
    end;

   Procedure Sort(l,R:integer);		{利用归并排序求“逆序对”}
     Var
       T:integer;
						
          Procedure Merge(l,t,r:integer);	
		   {将两个排好序的数组“归并”在一起，同时求出左部分相对于右部分“逆序对”的数目}
          Var
            i,j,k:integer;
            Begin
              i:=l;
              j:=T+1;
              k:=l-1;
              While (i<=t) and (j<=r) do
                Begin
                  if zi^[i]<zi^[j] then
                    Begin
                      inc(tot,j-t-1);	{跳跃累加“逆序对”数目}
                      inc(k);
                      use^[k]:=zi^[i];
                      inc(i);
                    end
                  Else
                    Begin
                      inc(k);
                      use^[k]:=zi^[j];
                      inc(j);
                    end;
                end;

              while i<=t do		{剩余部分的尾处理}
                Begin
                  inc(k);
                  use^[k]:=zi^[i];
                  inc(i);
                  inc(tot,r-t);
                end;
              while j<=r do
               Begin
                 inc(k);
                 use^[k]:=zi^[j];
                 inc(j);
               end;

              Move(use^[l],zi^[l],(r-l+1)*6);{返回两个数组的归并后的排序数组}
            end;
        Begin
          if l<r then
           Begin
             t:=(l+r) div 2;		{“分”}
             Sort(l,t);			{“分”部分“治”}
             Sort(t+1,r);
             Merge(l,t,r);		{“合”}
           end;
        end;

 Procedure Print;			{输出结果}
   Begin
     Assign(F,fou);
     rewrite(f);
       Writeln(f,tot);
     Close(f);
   end;

Begin			{主过程}
  Init;					{输入数据}
  Tot:=0;
  Sort(1,n);				{求解}
  Print;				{输出结果}
end.
