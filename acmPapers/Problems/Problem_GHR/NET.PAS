{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V-,X+}
{$M 16384,0,655360}
program Net;
  const
    Infns='Input.txt';
    Outfns='Output.txt';
  var
    n,m:integer;
    line:array[1..30] of integer;
    {line保存给定的输出序列} 
    compare,list:array[1..30,1..30] of boolean;
    {compare[i,j]表示比较网络是否具有使输出序列中的第i个数字
     小于第j个数字的性质}
    {list[i,j]表示输入序列是否应具有第i个数字小于第j个数字的性质}
    used:array[1..30] of boolean;
    {used[i]记录的是在回溯过程中第i小的数字是否使用过了}
    total:longint;

  procedure ReadIn;{读入数据并建立比较网络中的逆拓扑关系}
    var
      i,j,p1,p2:integer;
    begin
      assign(Input,Infns);
      reset(Input);
      readln(n,m);
      for i:=1 to m do
        begin
          readln(p1,p2);
          compare[p1,p2]:=true;{当前比较器提供的逆拓扑关系}
          for j:=1 to p1-1 do
         {结合以前得到的且与这两个编号之一有关的逆拓扑关系求出经过这个比
          较器后输出序列必然满足的逆拓扑关系}
            if compare[j,p1] and (not compare[j,p2]) then
              begin
                compare[j,p2]:=true;
                compare[j,p1]:=false;
              end;
          for j:=p2+1 to n do
            if compare[p2,j] and (not compare[p1,j]) then
              begin
                compare[p1,j]:=true;
                compare[p2,j]:=false;
              end;
        end;
      for i:=1 to n do
        read(line[i]);
      close(Input);
    end;

  procedure Reckon(which:integer);{求拓扑排序方案数}
    var
      i,j:integer;
      flag:boolean;
    begin
      if which>n then
        begin
          inc(total); exit;
        end;
      for i:=1 to n do
        if not used[i] then
          begin
            flag:=true;
            for j:=1 to n do
              if (not used[j]) and list[j,i] then
                begin flag:=false; break; end;
            if flag then
              begin
                used[i]:=true;
                Reckon(which+1);
                used[i]:=false;
              end;
        end;
    end;

  procedure Work;{判断时都有可行的输入方案并求出可行输入方案的总数}
    var
      i,j:integer;
    begin
      total:=0;
      for i:=1 to n-1 do
        for j:=i+1 to n do
          if compare[i,j] and (line[i]>line[j]) then exit;
      for i:=1 to n do
        for j:=1 to n do
          if ((i<j) and (line[i]=line[j])) or
             ((line[i]<line[j]) and (not compare[i,j]))
               then list[i,j]:=true;
      Reckon(1);{求拓扑排序方案数}
    end;

  procedure Out;{输出过程}
    begin
      assign(Output,Outfns);
      rewrite(Output);
      writeln(total);
      close(Output);
    end;

  begin
    ReadIn;{读入数据并建立比较网络中的逆拓扑关系}
    Work;{判断时都有可行的输入方案并求出可行输入方案的总数}
    Out;{输出过程}
  end.