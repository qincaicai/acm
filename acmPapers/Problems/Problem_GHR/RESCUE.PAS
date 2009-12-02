{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V-,X+}
{$M 16384,0,655360}
program Rescue;
  const
    Infns='Input.txt';
    Outfns='Output.txt';
  type
    Tpath=array[0..10002] of byte;
  var
    N,K,A,M:word;
    pv,value,pt,time,arrive:array[1..50] of word;
    {value[i]表示编号为i的动物的价值}
    {time[i]表示编号为i的小岛的的沉没时刻} 
    {pv[i]表示价值第i小的动物的种类编号(即在value数组中的下标)}
    {pt[i]表示沉没时刻第i小的小岛的编号}
    {arrive[i]标记小岛i有未到达过}
    animal:array[1..50,1..50] of word;
    {animal[i,j]表示小岛i上有多少编号为j的动物}
    path:array[1..30] of ^Tpath;
    {path[i]^记录第i艘皮划艇的行动路线}
    best:longint;
    {救出的动物的总价值}

  procedure ReadIn;{读入过程}
    var
      i,j:integer;
    begin
      assign(Input,Infns);
      reset(Input);
      readln(N,K,A);
      for i:=1 to A do
        read(value[i]);
      readln(M);
      for i:=1 to M do
        read(time[i]);
      for i:=1 to M do
        for j:=1 to A do
          read(animal[i,j]);
      close(Input);
    end;

  procedure Sort;{对动物的价值排序，并对小岛按沉没时刻进行排序}
    var
      i,j,p:integer;
    begin
      for i:=1 to A do
        pv[i]:=i;
      for i:=1 to A-1 do
        begin
          p:=i;
          for j:=i+1 to A do
            if value[pv[j]]<value[pv[p]] then p:=j;
          if i<>p then
            begin
              j:=pv[i]; pv[i]:=pv[p]; pv[p]:=j;
            end;
        end;
      for i:=1 to M do
        pt[i]:=i;
      for i:=1 to M-1 do
        begin
          p:=i;
          for j:=i+1 to M do
            if time[pt[j]]<time[pt[p]] then p:=j;
          if i<>p then
            begin
              j:=pt[i]; pt[i]:=pt[p]; pt[p]:=j;
            end;
        end;
    end;

  procedure GetNew;{指针申请空间}
    var
      i:integer;
    begin
      for i:=1 to N do
        begin
          new(path[i]);
          fillchar(path[i]^,sizeof(path[i]^),0);
        end;
    end;

  procedure Work;{确定每一艘皮划艇的行动路线}
    var
      i,j,p,NowT,have,Max,start,free,temp:word;
      none:boolean;
    begin
      for i:=1 to N do
        begin
          NowT:=1; j:=0; Max:=A; start:=NowT; free:=K;
          fillchar(arrive,sizeof(arrive),0);{将所有岛标记为未到达的岛}
          repeat
            repeat
            {在当前时刻还没淹没的小岛中或者已经到达过的小岛中找出有现在价值最大的动物的岛}
              none:=true;
              for p:=1 to M do
                if ((time[pt[p]]>NowT) or (arrive[pt[p]]>=start))
                   and (animal[pt[p],pv[Max]]>0) then
                     begin none:=false; break; end;
              if none then dec(Max);
            until (not none) or (Max=0);
            if Max=0 then break;
            p:=pt[p];
            if arrive[p]<start then
            {如果这个岛还为到达过的岛，则将时刻加1}
              begin
                arrive[p]:=NowT; path[i]^[NowT]:=p; inc(NowT);
              end;
            temp:=animal[p,pv[max]];
            if temp>=free
            {把这个岛上的价值最大的动物尽量装到皮划艇上，并标记这个岛为已到达的岛，
             皮划艇上装入多少动物，岛上就相应减少多少动物}
                then begin
                       {如果皮划艇已经装满动物，就驶回安全区，时刻加1}
                       dec(animal[p,pv[max]],free);
                       inc(best,free*value[pv[max]]);
                       free:=k;
                       inc(NowT); start:=NowT;
                     end
                else begin
                       animal[p,pv[max]]:=0;
                       inc(best,temp*value[pv[max]]);
                       dec(free,temp);
                     end;
          until false;
        end;
    end;

  procedure Out;{输出过程}
    var
      i,j:integer;
    begin
      assign(Output,Outfns);
      rewrite(Output);
      writeln(best);
      for i:=1 to N do
        begin
          j:=0;
          repeat
            write(path[i]^[j],' ');
            inc(j);
          until (path[i]^[j]=0) and (path[i]^[j-1]=0);
          writeln;
        end;
      close(Output);
    end;

  begin
    ReadIn;{读入过程}
    Sort;{对动物的价值排序，并对小岛按沉没时刻进行排序}
    GetNew;{指针申请空间}
    Work;{确定每一艘皮划艇的行动路线}
    Out;{输出过程}
  end.