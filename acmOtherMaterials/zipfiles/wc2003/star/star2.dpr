{
  Winter Camp 2003                                                      STAR
  Simple Enumerative Alogrithm
                         to Find the Best Solution ONLY for Test Point SEVEN
                       Written by Zhou Yuan

  WARNING:
 *This program CAN'T be used to produce the answer to ANY OTHER Test Point.
  It may get Wrong Answer, or Crash.

              See more descriptions in my report document.
}

{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
Const
    MainFile   = 'star';
    NumFile    = '7';                          //CAN'T modify!!!
    InFile     = '.in';
    OutFile    = '.out';
    LimitAnimal
               = 100;
    LimitLesson
               = 100;
    LimitPath  = 100;
    LimitTeacher
               = 30;
    Maximum    = 1e8;

Type
    Tdata      = array[1..LimitAnimal] of longint;
    Tneedtime  = array[1..LimitAnimal] of
                   record
                       time   : real;
                       skills : longint;
                   end;
    Tanimal    = array[1..LimitAnimal] of
                   record
                       teach , study         : longint;
                   end;
    Tmap       = array[1..LimitAnimal] of real;
    Tpath      = record
                     clockwise , anticlockwise              : longint;
                 end;

Var
    clockwise ,
    anticlock  : Tneedtime;
    data       : Tdata;
    animal     : Tanimal;
    prev ,
    next       : Tmap;
    bestpath   : Tpath;
    N , M ,
    beststar ,
    together   : longint;
    besttime   : real;

procedure info;
begin
    writeln('Winter Camp 2003                                                      STAR');
    writeln('Simple Enumerative Alogrithm                                              ');
    writeln('                       to Find the Best Solution ONLY for Test Point SEVEN');
    writeln('                     Written by Zhou Yuan                                 ');
    writeln;
    write('Running...');
end;

procedure init;
var
    i , j , c  : longint;
begin
    assign(INPUT , MainFile + NumFile + InFile); ReSet(INPUT);
      readln(N , M);
      for i := 1 to N do
        begin
            data[i] := 0;
            for j := 1 to M do
              begin
                  read(c);
                  data[i] := data[i] shl 1 + c;
              end;
        end;
      for i := 1 to N do
        with animal[i] do
          read(teach , study);
    Close(INPUT);
end;

procedure BuildMap;
var
    i , j      : longint;
begin
    for i := 1 to N do
      begin
          j := i mod N + 1;
          next[i] := animal[j].study / animal[i].teach;
      end;
    for i := 1 to N do
      begin
          j := (i - 2 + N) mod N + 1;
          prev[i] := animal[j].study / animal[i].teach;
      end;
end;

procedure Get_Needtime(star : longint);
var
    p          : longint;
begin
    p := star;
    clockwise[p].time := 0; clockwise[p].skills := data[p];
    p := (p + N - 2) mod N + 1;
    while p <> star do
      begin
          clockwise[p].time := next[p] + clockwise[p mod N + 1].time;
          clockwise[p].skills := data[p] or clockwise[p mod N + 1].skills;
          p := (p + N - 2) mod N + 1;
      end;

    p := star;
    anticlock[p].time := 0; anticlock[p].skills := data[p];
    p := p mod N + 1;
    while p <> star do
      begin
          anticlock[p].time := prev[p] + anticlock[(p + N - 2) mod N + 1].time;
          anticlock[p].skills := data[p] or anticlock[(p + N - 2) mod N + 1].skills;
          p := p mod N + 1;
      end;
end;

procedure work;
var
    star ,
    p1 , p2    : longint;
    t1 , t2 ,
    t3 , t4    : real;
begin
    BuildMap;
    besttime := Maximum;
    for star := 1 to N do
      begin
          Get_Needtime(star);
          for p1 := 1 to N do
            for p2 := 1 to N do
              begin
                  if clockwise[p1].skills or anticlock[p2].skills = 1 shl M - 1 then
                    if clockwise[p1].time + anticlock[p2].time < besttime then
                      begin
                          besttime := clockwise[p1].time + anticlock[p2].time;
                          bestpath.clockwise := p1;
                          bestpath.anticlockwise := p2;
                          beststar := star;
                          together := 0;
                      end;

                  if (p1 <> star) and (p2 <> star) then
                    if clockwise[p1].skills and anticlock[p2].skills = 1 shl M - 1 then
                      begin
                          t1 := clockwise[p1].time;
                          t2 := clockwise[(star + N - 2) mod N + 1].time;
                          t3 := anticlock[p2].time;
                          t4 := anticlock[star mod N + 1].time;
                          if (t1 - t2) + (t3 - t4) + 1 / (1 / t2 + 1 / t4) < besttime then
                            begin
                                besttime := (t1 - t2) + (t3 - t4) + 1 / (1 / t2 + 1 / t4);
                                bestpath.clockwise := p1;
                                bestpath.anticlockwise := p2;
                                beststar := star;
                                together := 1;
                            end;
                      end;
              end;
      end;
    writeln('Done!');
    writeln('Please view star' , numfile , '.out or enter ''check ' , numfile , ''' to see the solution.');
end;

procedure out;
type
    Toutpath   = array[1..LimitPath] of
                   record
                       teacher , student     : longint;
                   end;
var
    p1 , p2 ,
    tmp1 ,
    tmp2 ,
    i , tot    : longint;
    outpath    : Toutpath;
begin
    assign(OUTPUT , MainFile + NumFile + OutFile); ReWrite(OUTPUT);
      tot := 0;
      p1 := bestpath.clockwise;
      while p1 <> beststar do
        begin
            inc(tot);
            outpath[tot].teacher := p1;
            outpath[tot].student := p1 mod N + 1;
            p1 := p1 mod N + 1;
        end;
      tmp1 := tot;
      p2 := bestpath.anticlockwise;
      while p2 <> beststar do
        begin
            inc(tot);
            outpath[tot].teacher := p2;
            outpath[tot].student := (p2 + N - 2) mod N + 1;
            p2 := (p2 + N - 2) mod N + 1;
        end;
      tmp2 := tot;

      writeln(tot - together);
      for i := 1 to tmp1 - 1 do
        writeln(1 , ' ' , outpath[i].teacher , ' ' , outpath[i].student);
      for i := tmp1 + 1 to tmp2 - 1 do
        writeln(1 , ' ' , outpath[i].teacher , ' ' , outpath[i].student);
      if together = 1 then
        writeln(2 , ' ' , outpath[tmp1].teacher , ' ' , outpath[tmp2].teacher , ' ' , outpath[tmp1].student)
      else
        begin
            writeln(1 , ' ' , outpath[tmp1].teacher , ' ' , outpath[tmp1].student);
            writeln(1 , ' ' , outpath[tmp2].teacher , ' ' , outpath[tmp2].student);
        end;
      writeln(beststar);
      writeln(besttime : 0 : 6);
    Close(OUTPUT);
end;

Begin
    info;
    init;
    work;
    out;
End.
