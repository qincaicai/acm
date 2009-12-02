{$N+}
var
  n:integer;
  max:extended;
  f:array[0..5,0..5,0..5,1..3] of extended;
  win1:array[1..15,1..10] of extended;
  win2:array[1..5,1..5] of extended;
  used:array[1..15] of boolean;
  t:array[1..5] of integer;
procedure init;
  var
    i,j:integer;
  begin
    readln(n);
    for i:=1 to n do
      begin
        for j:=1 to 10 do
          read(win1[i,j]);
        readln;
      end;
    for i:=1 to 5 do
      begin
        for j:=1 to 5 do
          read(win2[i,j]);
        readln;
      end;
    max:=0;
    fillchar(used,sizeof(used),0);
  end;
procedure solve(l:integer);
  var
    i,j,k:integer;
    total:extended;
  begin
    if l=5 then
      begin
        fillchar(f,sizeof(f),0);
        f[5,5,5,1]:=1/3;
        f[5,5,5,2]:=1/3;
        f[5,5,5,3]:=1/3;
        for i:=5 downto 0 do
          for j:=5 downto 0 do
            for k:=5 downto 0 do
              if (i+j+k<>i) and (i+j+k<>j) and (i+j+k<>k) then
                begin
                  if abs(f[i,j,k,1])>1e-8 then
                    if i<>0 then
                      begin
                        f[i,j-1,k,2]:=f[i,j-1,k,2]+f[i,j,k,1]*(1-win2[6-j,6-k]);
                        f[i,j,k-1,3]:=f[i,j,k-1,3]+f[i,j,k,1]*win2[6-j,6-k];
                      end
                    else
                      begin
                        f[i,j-1,k,1]:=f[i,j-1,k,1]+f[i,j,k,1]*(1-win2[6-j,6-k]);
                        f[i,j,k-1,1]:=f[i,j,k-1,1]+f[i,j,k,1]*win2[6-j,6-k];
                      end;
                  if abs(f[i,j,k,2])>1e-8 then
                    if j<>0 then
                      begin
                        f[i-1,j,k,1]:=f[i-1,j,k,1]+f[i,j,k,2]*(1-win1[t[6-i],11-k]);
                        f[i,j,k-1,3]:=f[i,j,k-1,3]+f[i,j,k,2]*win1[t[6-i],11-k];
                      end
                    else
                      begin
                        f[i-1,j,k,2]:=f[i-1,j,k,2]+f[i,j,k,2]*(1-win1[t[6-i],11-k]);
                        f[i,j,k-1,2]:=f[i,j,k-1,2]+f[i,j,k,2]*win1[t[6-i],11-k];
                      end;
                  if abs(f[i,j,k,3])>1e-8 then
                    if k<>0 then
                      begin
                        f[i-1,j,k,1]:=f[i-1,j,k,1]+f[i,j,k,3]*(1-win1[t[6-i],6-j]);
                        f[i,j-1,k,2]:=f[i,j-1,k,2]+f[i,j,k,3]*win1[t[6-i],6-j];
                      end
                    else
                      begin
                        f[i-1,j,k,3]:=f[i-1,j,k,3]+f[i,j,k,3]*(1-win1[t[6-i],6-j]);
                        f[i,j-1,k,3]:=f[i,j-1,k,3]+f[i,j,k,3]*win1[t[6-i],6-j];
                      end;
                end;
        total:=0;
        for i:=1 to 5 do
          total:=total+f[i,0,0,2]+f[i,0,0,3];
        if total>max then max:=total;
        exit;
      end;
    for i:=1 to n do
      if not used[i] then
        begin
          used[i]:=true;
          t[l+1]:=i;
          solve(l+1);
          t[l+1]:=0;
          used[i]:=false;
        end;
  end;
begin
  assign(input,'sanguo.in');
  reset(input);
  init;
  close(input);
  solve(0);
  assign(output,'sanguo.out');
  rewrite(output);
  writeln(max:0:6);
  close(output);
end.
