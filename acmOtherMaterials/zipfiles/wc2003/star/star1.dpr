{
  Winter Camp 2003                                                      STAR
  Dynamic Programming Alogrithm
                              to Find the Best Solution for Test Point 1,2,3
                       Written by Zhou Yuan

  WARNING:
 *This program CAN'T be used to produce the answer to ANY OTHER test point.
  It may get "Runtime Error 201: Range Check Error".

              See more descriptions in my report document.
}

{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
Const
    MainFile   = 'star';
    InFile     = '.in';
    OutFile    = '.out';
    LimitAnimal
               = 12;
    LimitLesson
               = 3;
    LimitZero  = 19;
    LimitPath  = 1000;

Type
    Topt       = array[0..1 shl LimitZero - 1] of
                   record
                        time                 : real;
                        father , teacher ,
                        student              : int64;
                        valid                : boolean;
                   end;
    TAnimal    = array[1..LimitAnimal] of
                   record
                       teach , study         : int64;
                   end;
    Tmap       = array[1..LimitAnimal] of int64;
    Tknow      = array[1..LimitAnimal , 1..LimitAnimal] of int64;
    Tteaching  = array[0..1 shl LimitAnimal - 1 , 1..LimitAnimal] of int64;
    TMustOne   = array[1..LimitAnimal * LimitLesson] of int64;

Var
    opt        : Topt;
    animal     : Tanimal;
    map        : Tmap;
    know       : Tknow;
    teaching   : Tteaching;
    MustOne    : TMustOne;
    NumFile    : string;
    N , M ,
    beststar   : longint;
    Base ,
    beststatus : int64;
    besttime   : real;

procedure usage;
begin
    writeln('Usage:');
    writeln('[Program Name](.exe) [Testdata Number]');
    writeln('Here, [Testdata Number] can be 1, 2, 3.');
    halt;
end;

procedure info;
begin
    writeln('Winter Camp 2003                                                      STAR');
    writeln('Dynamic Programming Alogrithm                                             ');
    writeln('                            to Find the Best Solution for Test Point 1,2,3');
    writeln('                     Written by Zhou Yuan                                 ');
    writeln;

    if paramcount = 0 then
      usage
    else
      if paramcount = 1 then
        begin
            numfile := paramstr(1);
            if (numfile <> '1') and (numfile <> '2') and (numfile <> '3') then
              begin
                  writeln('Invalid parameter!');
                  usage;
              end
            else
              write('Running...');
        end
      else
        begin
            writeln('Too many parameters!');
            usage;
        end;
end;

procedure init;
var
    i , j      : longint;
    total ,
    p1 , p2    : int64;
begin
    fillchar(opt , sizeof(opt) , 0);
    fillchar(animal , sizeof(animal) , 0);
    fillchar(map , sizeof(map) , 0);
    fillchar(know , sizeof(know) , 0);
    assign(INPUT , MainFile + NumFile + InFile); ReSet(INPUT);
      readln(N , M);
      base := 1 shl M;
      for i := 1 to N do
        for j := 1 to M do
          begin
              read(p1);
              map[i] := map[i] * 2 + p1;
          end;
      for i := 1 to N do
        with animal[i] do
          read(teach , study);
      read(total);
      for i := 1 to total do
        begin
            read(p1 , p2);
            know[p1 , p2] := 1;
            know[p2 , p1] := 1;
        end;
    Close(INPUT);
end;

procedure pre_process;
var
    i , j , k ,
    tmp        : longint;
begin
    for i := 0 to 1 shl N - 1 do
      for j := 1 to N do
        begin
            teaching[i , j] := 1;
            tmp := i;
            for k := N downto 1 do
              if odd(tmp) and ((know[k , j] = 0) or (k = j)) then
                begin
                    teaching[i , j] := 0;
                    break;
                end
              else
                tmp := tmp shr 1;
        end;
end;

function code(num : int64) : longint;
var
    i ,
    p , res    : longint;
begin
    p := 1; res := 0;
    for i := N * M downto 1 do
      if mustone[i] = 0 then
        begin
            if num and (int64(1) shl (N * M - i)) <> 0 then
              inc(res , p);
            p := p shl 1;
        end;
    code := res;
end;

procedure improve(status : int64);
var
    skills     : array[1..LimitAnimal] of longint;
    tmp ,
    newstatus ,
    tmpstatus  : int64;
    status_coded ,
    newstatus_coded ,
    teachability ,
    i , teachers ,
    student    : longint;
    newtime    : real;
begin
    status_coded := code(status);
    if opt[status_coded].valid then
      begin
          tmpstatus := status;
          for i := N downto 1 do
            begin
                tmp := tmpstatus div Base;
                skills[i] := tmpstatus - tmp * Base;
                tmpstatus := tmp;
            end;
          for teachers := 1 to 1 shl N - 2 do
            begin
                tmp := Base - 1;
                teachability := 0;
                for i := 1 to N do
                  if teachers and (1 shl (N - i)) <> 0 then
                    begin
                        tmp := tmp and skills[i];
                        if tmp = 0 then
                          break;
                        inc(teachability , animal[i].teach);
                    end;
                if tmp <> 0 then
                  for student := 1 to N do
                    if teaching[teachers , student] = 1 then
                      begin
                          newstatus := 0;
                          for i := 1 to N do
                            if i = student then
                              newstatus := newstatus shl M + skills[i] or tmp
                            else
                              newstatus := newstatus shl M + skills[i];

                          newtime := opt[status_coded].time + animal[student].study / teachability;
                          newstatus_coded := code(newstatus);
                          if not opt[newstatus_coded].valid or (opt[newstatus_coded].time > newtime) then
                            begin
                                opt[newstatus_coded].time := newtime;
                                opt[newstatus_coded].valid := true;
                                opt[newstatus_coded].father := status;
                                opt[newstatus_coded].teacher := teachers;
                                opt[newstatus_coded].student := student;
                            end;
                      end;
            end;
      end;
end;

procedure produce_improve(last , step , number : int64);
begin
    if step > N * M then
      improve(number)
    else
      if mustone[step] = 1 then
        if last <> 0 then
          produce_improve(last - 1 , step + 1 , number * 2 + 1)
        else
      else
        begin
            if (last <> 0) then
              produce_improve(last - 1 , step + 1 , number * 2 + 1);
            if (last + step - 1 <= N * M) then
              produce_improve(last , step + 1 , number * 2);
        end;
end;

function valid_status(status : int64; var star : integer) : boolean;
begin
    star := N;
    while status <> 0 do
      begin
          if status mod Base + 1 = base then
            begin
                valid_status := true;
                exit;
            end;
          status := status div base;
          dec(star);
      end;
    valid_status := false;
end;

procedure work;
var
    startstatus ,
    tmp ,
    base_tmp ,
    status     : int64;
    number ,
    status_coded ,
    i , j      : longint;
begin
    pre_process;
    startstatus := 0;
    for i := 1 to N do
      startstatus := startstatus shl M + map[i];
    tmp := startstatus; number := 0;
    fillchar(mustone , sizeof(mustone) , 0);
    i := N * M;
    while tmp <> 0 do
      begin
          if odd(tmp) then
            begin
                inc(number);
                mustone[i] := 1;
            end;
          tmp := tmp shr 1;
          dec(i);
      end;
    opt[code(startstatus)].valid := true;

    for i := number to N * M do
      produce_improve(i , 1 , 0);

    besttime := -1;
    for i := 0 to 1 shl (N * M - number) - 1 do
      begin
          tmp := i;
          base_tmp := 1;
          status := 0;
          for j := N * M downto 1 do
            begin
                if mustone[j] = 1 then
                  inc(status , base_tmp)
                else
                  begin
                      if odd(tmp) then
                        inc(status , base_tmp);
                      tmp := tmp shr 1;
                  end;
                base_tmp := base_tmp shl 1;
            end;
          if not valid_status(status , j) then continue;
          status_coded := i;
          if opt[status_coded].valid then
            if (besttime < 0) or (besttime > opt[status_coded].time) then
              begin
                  besttime := opt[status_coded].time;
                  beststatus := status;
                  beststar := j;
              end;
      end;
    Writeln('Done.');
    writeln('Please view star' , numfile , '.out or enter ''check ' , numfile , ''' to see the solution.');
end;

procedure out;
type
    Tpath      = record
                     total    : longint;
                     data     : array[1..LimitPath] of
                                  record
                                      teacher , student     : longint;
                                  end;
                 end;
var
    path       : Tpath;
    nowstatus ,
    nowstatus_coded
               : int64;
    i , j ,
    sum        : longint;
begin
    fillchar(path , sizeof(path) , 0);
    nowstatus := beststatus;
    nowstatus_coded := code(nowstatus);
    while opt[nowstatus_coded].father <> 0 do
      begin
          inc(path.total);
          path.data[path.total].teacher := opt[nowstatus_coded].teacher;
          path.data[path.total].student := opt[nowstatus_coded].student;
          nowstatus_coded := code(opt[nowstatus_coded].father);
      end;

    assign(OUTPUT , MainFile + NumFile + OutFile); ReWrite(OUTPUT);
      writeln(path.total);
      for i := path.total downto 1 do
        begin
            sum := 0;
            for j := 0 to N - 1 do
              if (1 shl j) and path.data[i].teacher <> 0 then
                inc(sum);
            write(sum);
            for j := N - 1 downto 0 do
              if (1 shl j) and path.data[i].teacher <> 0 then
                write(' ' , N - j);
            writeln(' ' , path.data[i].student);
        end;
      writeln(Beststar);
      writeln(Besttime : 0 : 6);
    Close(OUTPUT);
end;

Begin
    info;
    init;
    work;
    out;
End.
