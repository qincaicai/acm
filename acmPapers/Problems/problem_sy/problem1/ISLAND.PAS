Program Island(input,output);	{第一题：说谎岛}
const   inputfile            =  'island.in';
        outputfile           =  'island.out';
        MAXM                 =  200;
var     m,n                  :  integer;
        f                    :  array [1..MAXM,1..MAXM] of shortint;
        ans                  :  array [0..1] of set of byte;
        h                    :  array [1..MAXM] of boolean;
procedure noanswer;		{输出无解}
begin
  assign(output,outputfile);
  rewrite(output);
  writeln('NO ANSWER');
  close(output);
  halt;
end;
procedure initialize;		{读入数据、始初化}
var       a,b,c,d,i,j   :       integer;
begin
  assign(input,inputfile);
  reset(input);
  read(n,m);
  fillchar(f,sizeof(f),0);
  for i:=1 to n do
    begin
      read(a,b,c,d);
      if b<>d then		{如果两问题回答不一致，其真正答案应当是一致的}
        begin
          if (f[a,c]=-1)or(f[c,a]=-1) then  {如果与前面条件矛盾，则无解}
            begin
              close(input);
              noanswer;
            end;
          f[a,c]:=1;
          f[c,a]:=1;
        end
        else
          begin
            if (f[a,c]=1)or(f[c,a]=1) then  {如果与前面条件矛盾，则无解}
              begin
                close(input);
                noanswer;
              end;
            f[a,c]:=-1;
            f[c,a]:=-1;
          end;
    end;
  close(input);
end;
procedure search(k,p:integer);		{深度优先搜索搜寻连通子图}
var       i    :      integer;
begin
  ans[p]:=ans[p]+[k];			{将当前问题加入子集p}
  h[k]:=false;
  for i:=1 to m do
    if h[i] then
      case f[k,i] of
        -1  : search(i,1-p);		{如果问题i与当前问题答案不同}
        1   : search(i,p);		{如果问题i与当前问题答案相同}
      end;
end;
procedure solve;	{主程序}
var       a,b,i,j,no    :       integer;
          s             :       string;
begin
  no:=0;
  fillchar(h,sizeof(h),true);
  for i:=1 to m do	{划分连通子图}
    if h[i] then
      begin
        no:=no+1;
        ans[0]:=[];ans[1]:=[];	{该连通子图中的两个子集初始化置空}
        search(i,0);		{搜寻连通子图}
        if ans[0]*ans[1]<>[] then noanswer;  {如果两子集有重复元素，则矛盾，无解}
        for a:=i to m do
          if a in (ans[0]+ans[1]) then
            for b:=i to m do
              if b in (ans[0]+ans[1]) then
                if f[a,b]<>0 then
                  if ((a in ans[0])xor(b in ans[0]))xor(f[a,b]=-1) then noanswer;
                     {如果两问题分属不同的子集，且两问题答案相同；
                      或两问题属于同一子集，且两问题答案不同，则矛盾，无解}
      end;
  assign(output,outputfile);
  rewrite(output);
  s:='1';		{高精度乘法}
  for i:=1 to no do
    begin
      if s[1]>='5' then s:='0'+s;
      a:=0;
      for j:=length(s) downto 1 do
        begin
          if s[j]>='5' then b:=1
            else b:=0;
          s[j]:=chr((ord(s[j])-48)*2 mod 10+a+48);
          a:=b;
        end;
    end;
  writeln(s);		{输出解的可能种数}
  close(output);
end;
begin
  initialize;	{读入数据，初始化}
  solve;	{主程序}
end.