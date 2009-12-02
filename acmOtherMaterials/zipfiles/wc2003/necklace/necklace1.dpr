{
  Winter Camp 2003                        Necklace
  Improved Simulate Algorithm Written By Zhou Yuan
         Compiled By Borland Delphi 7.0

     See more description in my report document
}

{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
Uses
    SysUtils;
    
Const
    InFile     = 'necklace.in';
    OutFile    = 'necklace.out';
    Limit      = 100000;
    LimitLines = 30;
    LimitLen   = 10;
    Base       : array[1..LimitLen] of longint
               = (1 , 10 , 100 , 1000 , 10000 , 100000 , 1000000 , 10000000 ,
                  100000000 , 1000000000);

Type
    lint       = array[1..LimitLen] of longint;
    Tdata      = array[1..Limit] of longint;
    Tchanged   = record
                     total    : longint;
                     data     : array[1..Limit] of longint;
                     visited  : array[1..Limit] of boolean;
                 end;
    Tnecklace  = record
                     step     : longint;
                     data     : Tdata;
                     changed  : Tchanged;
                 end;
    TLine      = record
                     sign , num1 , num2 , num3              : longint;
                 end;
    Tprog      = array[1..LimitLines] of TLine;

Var
    data       : Tdata;
    neck1 ,
    neck2      : Tnecklace;
    prog       : Tprog;
    N , M ,
    answer     : longint;
    nowtime1 ,
    nowtime2   : TDateTime;

procedure read_line(var line : TLine);
var
    s          : string[2];
    c          : char;
begin
    with line do
      begin
          read(s[1] , s[2]);
          case s[1] of
            'S'               : if s[2] = 'E' then
                                  sign := 1
                                else
                                  sign := 2;
            'M'               : sign := 3;
            'O'               : sign := 4;
            'E'               : sign := 5;
          end;
          repeat
            read(c);
          until (c = ' ') or eoln;
          if sign <= 4 then
            begin
                read(num1 , num2);
                if sign = 4 then
                  read(num3);
            end;
          readln;
      end;
end;

procedure init;
var
    i          : longint;
    c          : char;
begin
    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , M);
      for i := 1 to N do
        begin
            read(c);
            data[i] := ord(c) - ord('0');
        end;
      readln;
      for i := 1 to M do
        read_line(prog[i]);
    Close(INPUT);
end;

function get_intnum(var neck : Tnecklace; a , b : longint) : longint;
var
    i , res1 ,
    res2 ,
    step1 ,
    step2      : longint;
begin
    res1 := 0; step1 := (b + 1) div 2; step2 := b - step1;
    for i := 1 to step1 do
      begin
          res1 := res1 * 10 + neck.data[a];
          if a = N then a := 1 else inc(a);
      end;
    res1 := res1 * Base[step2 + 1] mod N;

    res2 := 0;
    for i := 1 to step2 do
      begin
          res2 := res2 * 10 + neck.data[a];
          if a = N then a := 1 else inc(a);
      end;

    get_intnum := (res1 + res2) mod N;
end;

function get_lintnum(var neck : Tnecklace; a , b : longint) : lint;
var
    i          : longint;
    res        : lint;
begin
    for i := 1 to b do
      begin
          res[i] := neck.data[a];
          if a = N then
            a := 1
          else
            inc(a);
      end;
    get_lintnum := res;
end;

procedure add(var neck : Tnecklace; start , L : longint; const num : lint);
var
    i          : longint;
begin
    for i := 1 to L do
      begin
          neck.data[start] := num[i];
          if not neck.changed.visited[start] then
            with neck.changed do
              begin
                  inc(total);
                  data[total] := start;
                  visited[start] := true;
              end;
          if start = N then
            start := 1
          else
            inc(start);
      end;
end;

procedure Circle_Change(var neck : Tnecklace; start , L , x : longint);
var
    i , p      : longint;
    tmp        : lint;
begin
    tmp := get_lintnum(neck , start , L);
    p := -x + 1;
    if p <= 0 then inc(p , L);
    for i := 1 to L do
      begin
          neck.data[start] := tmp[p];
          if not neck.changed.visited[start] then
            with neck.changed do
              begin
                  inc(total);
                  data[total] := start;
                  visited[start] := true;
              end;
          if p = L then p := 1 else inc(p);
          if start = N then start := 1 else inc(start);
      end;
end;

procedure Mul_Change(var neck : Tnecklace; start , L , x : longint);
var
    tmp        : lint;
    i , jw     : longint;
begin
    tmp := get_lintnum(neck , start , L);
    jw := 0;
    for i := L downto 1 do
      begin
          tmp[i] := tmp[i] * x + jw;
          jw := tmp[i] div 10;
          tmp[i] := tmp[i] - jw * 10;
      end;
    for i := 1 to L do
      begin
          neck.data[start] := tmp[i];
          if not neck.changed.visited[start] then
            with neck.changed do
              begin
                  inc(total);
                  data[total] := start;
                  visited[start] := true;
              end;
          if start = N then start := 1 else inc(start);
      end;
end;

procedure run_prog(var neck : Tnecklace);
var
    p , start  : longint;
begin
    inc(neck.step);
    p := 1;
    start := 0;
    while prog[p].sign <> 5 do
      begin
          case prog[p].sign of
            1  : start := get_intnum(neck , prog[p].num1 + 1 , prog[p].num2);
            2  : Circle_Change(neck , start + 1 , prog[p].num1 , prog[p].num2);
            3  : Mul_Change(neck , start + 1 , prog[p].num1 , prog[p].num2);
            4  : if neck.data[prog[p].num1 + 1] = prog[p].num2 then
                   p := prog[p].num3 - 1;
          end;
          inc(p);
      end;
end;

function same(const neck1 , neck2 : Tnecklace) : boolean;
var
    i          : longint;
begin
    same := false;
    with neck2.changed do
      for i := 1 to total do
        if neck1.data[data[i]] <> neck2.data[data[i]] then
          exit;
    same := true;
end;

procedure work;
var
    last       : longint;
begin
    fillchar(neck1 , sizeof(neck1) , 0);
    neck1.data := data;
    run_prog(neck1);
    neck2 := neck1;
    while true do
      begin
          run_prog(neck2);
          if same(neck1 , neck2) then
            break;
          run_prog(neck2);
          if same(neck1 , neck2) then
            break;
          run_prog(neck1);
      end;
    last := neck1.step;
    while true do
      begin
          run_prog(neck1);
          if same(neck1 , neck2) then
            begin
                answer := neck1.step - last;
                break;
            end;                                        
      end;
end;

procedure out;
begin
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
    Close(OUTPUT);
end;

Begin
    nowtime1 := GetTime;
    init;
    work;
    out;
    nowtime2 := GetTime;
    assign(OUTPUT , ''); ReWrite(OUTPUT);
      writeln('Total Time : ' , (nowtime2 - nowtime1) / 1.3227513227513227513227513227513e-5 : 0 : 2);
    Close(OUTPUT);
End.
