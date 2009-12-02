const
  wei:array[0..3] of integer=(6,2,4,8);
type
  arr=array[1..105] of integer;
var
  a,b,c,d:arr;
  w1,w2,n1,n2,i,j,w,wt:integer;
  s:string;
procedure plus(var a:arr;b:arr;var wa,wb:integer);
  var
    i:integer;
  begin
    if wa<wb then wa:=wb;
    for i:=1 to wa do
      a[i]:=a[i]+b[i];
    for i:=1 to wa do
      if a[i]>=10 then
        begin
          inc(a[i+1]);
          dec(a[i],10);
        end;
    if a[wa+1]<>0 then inc(wa);
  end;
procedure jian(var a:arr;b:arr;var wa,wb:integer);
  var
    i:integer;
  begin
    for i:=1 to wb do
      begin
        if a[i]<b[i] then
          begin
            dec(a[i+1]);
            inc(a[i],10);
          end;
        dec(a[i],b[i]);
      end;
    i:=wb+1;
    while a[i]<0 do
      begin
        inc(a[i],10);
        dec(a[i-1]);
      end;
    while a[wa]=0 do dec(wa);
  end;
procedure chu(var a:arr;j:integer;var wa:integer);
  var
    i,c:integer;
  begin
    c:=0;
    for i:=wa downto 1 do
      begin
        a[i]:=a[i]+c*10;
        c:=a[i] mod j;
        a[i]:=a[i] div j;
      end;
     while a[wa]=0 do dec(wa);
  end;
begin
  assign(input,'flower.in');
  reset(input);
  assign(output,'flower.out');
  rewrite(output);
  for i:=1 to 5 do
    begin
      readln(s);
      if s='1' then
        begin
          writeln(1);
          continue;
        end;
      w1:=length(s);
      for j:=1 to w1 do
        a[j]:=ord(s[w1-j+1])-48;
      b:=a;w2:=w1;
      fillchar(c,sizeof(c),0);
      n1:=1;
      while (w2>1) or (b[1]>1) do
        begin
          chu(b,2,w2);
          plus(c,b,n1,w2);
        end;
      fillchar(d,sizeof(d),0);
      n2:=1;
      b:=a;w2:=w1;
      while (w2>1) or (b[1]>1) do
        begin
          chu(b,5,w2);
          plus(d,b,n2,w2);
        end;
      jian(c,d,n1,n2);
      w:=c[1]+c[2]*10;
      w:=wei[w mod 4];
      c:=a;n1:=w1;
      while (n1>1) or (c[1]>0) do
        begin
          d:=c;n2:=n1;
          while (n2>1) or (d[1]>0) do
            begin
              wt:=1;
              if (n2>1) and odd(d[2]) then wt:=9;
              if d[1]>8 then wt:=wt*9
                 else if d[1]>6 then
                      else if d[1]>2 then wt:=wt*3;
              if wt>=10 then wt:=wt mod 10;
              w:=w*wt mod 10;
              chu(d,5,n2);
            end;
          chu(c,2,n1);
        end;
      writeln(w);
    end;
  close(input);
  close(output);
end.


