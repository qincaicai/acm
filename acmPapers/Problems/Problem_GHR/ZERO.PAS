{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V-,X+}
{$M 16384,0,655360}
program Zero;
  const
    Infns='Input.txt';
    Outfns='Output.txt';
  type
    Tarr=array[-3000..3000] of boolean;
  var
    can:array[1..2,1..30] of ^Tarr;
    {can[i,j]^[k]表示是否存在从底端跳到(i,j)点的计算结果为k的路径}
    table:array[1..60,1..30] of integer;
    {记录表格中的数字}
    n,low,pre,now,min,max:integer;
    {pre,now分别为上一行的计算结果和当前行的计算结果在can数组中的对应位置}

  procedure ReadIn;{读入过程}
    var
      i,j:integer;
    begin
      assign(Input,Infns);
      reset(Input);
      readln(n);
      low:=n*2-1;
      for i:=1 to n do
        for j:=n-i+1 to n do
          read(table[i,j]);
      for i:=n+1 to low do
        for j:=1 to low-i+1 do
          read(table[i,j]);
      close(Input);
    end;

  procedure BelowHalf;{计算表格下半部分的所有可能的计算结果}
    var
      i,j,k,num1,num2:integer;
    begin
      for i:=low downto n+1 do
        begin
          for j:=1 to low-i+2 do
            fillchar(can[now,j]^,sizeof(can[now,j]^),0);
          for j:=1 to low-i+1 do
            begin
              num1:=table[i-1,j]; num2:=table[i-1,j+1];
              for k:=min to max do
                if can[pre,j]^[k] then
                  begin
                    can[now,j]^[k+num1]:=true; can[now,j]^[k-num1]:=true;
                    can[now,j+1]^[k+num2]:=true; can[now,j+1]^[k-num2]:=true;
                  end;
            end;
          dec(min,50); inc(max,50);
          now:=pre; pre:=3-pre;
        end;
    end;

  procedure AboveHalf;{计算表格上半部分的所有可能的计算结果}
    var
      i,j,k,num:integer;
    begin
      for i:=n-1 downto 1 do
        begin
          dec(min,50); inc(max,50);
          for j:=n-i+1 to n do
            fillchar(can[now,j]^,sizeof(can[now,j]^),0);
          for j:=n-i+1 to n do
            begin
              num:=table[i,j];
              for k:=min to max do
                if can[pre,j-1]^[k-num] or can[pre,j-1]^[k+num] or
                   can[pre,j]^[k-num] or can[pre,j]^[k+num]
                     then can[now,j]^[k]:=true;
            end;
          now:=pre; pre:=3-pre;
        end;
    end;

  procedure Work;{计算从底端方格跳到顶端方格所有可能的计算结果}
    var
      i:integer;
    begin
      for i:=1 to n do
        begin
          new(can[1,i]);
          fillchar(can[1,i]^,sizeof(can[1,i]^),0);
        end;
      for i:=1 to n do new(can[2,i]);
      can[1,1]^[table[low,1]]:=true;
      min:=table[low,1]; max:=table[low,1];
      pre:=1; now:=2;
      BelowHalf;{计算表格下半部分的所有可能的计算结果}
      AboveHalf;{计算表格上半部分的所有可能的计算结果}
    end;

  procedure Out;{输出过程}
    var
      i:integer;
    begin
      for i:=0 to 3000 do
        if can[pre,n]^[i] or can[pre,n]^[-i]
          then break;{找出绝对值最小的计算结果}
      assign(Output,Outfns);
      rewrite(Output);
      writeln(i);
      close(Output);
    end;

  begin
    ReadIn;{读入过程}
    Work;{计算从底端方格跳到顶端方格所有可能的计算结果}
    Out;{输出过程}
  end.