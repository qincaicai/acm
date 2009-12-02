{
  Winter Camp 2003                                                      STAR
  Greedy Alogrithm (Based on Floyd Shortest Path)
                         to Find a Better Solution for Test Point 5,6,8,9,10
                       Written by Zhou Yuan

  WARNING:
 *This program CAN'T be used to produce the answer to the FOURTH test point.
  It may get "Runtime Error 201: Range Check Error".
 *Please don't make it work on Test Point 1,2,3,7, since other porgrams can
  find the best answer.

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
               = 100;
    LimitLesson
               = 100;
    LimitPath  = 1000;
    LimitTeacher
               = 50;
    LimitTimes = 1000;
    Maximum    = 1e3;
    Minimum    = 1e-5;

Type
    Tdata      = array[1..LimitAnimal] of longint;
    Torder     = array[1..LimitLesson] of longint;
    Tknow      = array[1..LimitAnimal , 1..LimitAnimal] of longint;
    Tanimal    = array[1..LimitAnimal] of
                   record
                       study , teach         : longint;
                   end;
    RECpath    = record
                     totalteacher , student ,
                     skills                : longint;
                     teacher               : array[1..LimitTeacher] of longint;
                     needtime              : real;
                 end;
    Tpath      = record
                     total    : longint;
                     data     : array[1..LimitPath] of RECpath;
                 end;
    Tmap       = array[1..LimitAnimal , 1..LimitAnimal] of real;
    Tvisited   = array[1..LimitAnimal] of longint;
    Tqueue     = record
                     addtime  : real;
                     total    : longint;
                     data     : array[1..LimitAnimal] of
                                  record
                                      source , target       : longint;
                                  end;
                 end;

Var
    data ,
    backdata   : Tdata;
    know       : Tknow;
    order      : Torder;
    NumFile    : string;
    animal     : Tanimal;
    map ,
    backup     : Tmap;
    visited    : Tvisited;
    path ,
    bestpath   : Tpath;
    N , M ,
    beststar   : longint;
    time ,
    besttime   : real;

procedure usage;
begin
    writeln('Usage:');
    writeln('[Program Name](.exe) [Testdata Number]');
    writeln('Here, [Testdata Number] can be 5, 6, 8, 9, 10.');
    halt;
end;

procedure info;
begin
    writeln('Winter Camp 2003                                                      STAR');
    writeln('Greedy Alogrithm (Based on Floyd Shortest Path)                           ');
    writeln('                       to Find a Better Solution for Test Point 5,6,8,9,10');
    writeln('                     Written by Zhou Yuan                                 ');
    writeln;

    if paramcount = 0 then
      usage
    else
      if paramcount = 1 then
        begin
            numfile := paramstr(1);
            if (numfile <> '5') and (numfile <> '6') and (numfile <> '8') and (numfile <> '9') and (numfile <> '10') then
              begin
                  writeln('Invalid parameter!');
                  usage;
              end
            else
              begin
                  writeln('Running...');
                  write('Initializing...');
              end;
        end
      else
        begin
            writeln('Too many parameters!');
            usage;
        end;
end;

procedure init;
var
    i , j , k ,
    p1 , p2 , c: longint;
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
      read(k);
      for i := 1 to k do
        begin
            read(p1 , p2);
            know[p1 , p2] := 1;
            know[p2 , p1] := 1;
        end;
    Close(INPUT);
end;

procedure BuildMap;
var
    i , j      : longint;
begin
    for i := 1 to N do
      for j := 1 to N do
        if i = j then
          map[i , j] := 0
        else
          if (know[i , j] = 1) then
            map[i , j] := animal[j].study / animal[i].teach
          else
            map[i , j] := maximum;
end;

procedure Floyd;
var
    i , j , k  : longint;
begin
    for k := 1 to N do
      for i := 1 to N do
        for j := 1 to N do
          if map[i , k] + map[k , j] < map[i , j] then
            map[i , j] := map[i , k] + map[k , j];
end;

function same(a , b : real) : boolean;
begin
    if abs(a - b) <= minimum then
      same := true
    else
      same := false;
end;

procedure add_queue(var queue : Tqueue; startp , targetp : longint);
var
    addtime    : real;
begin
    addtime := map[startp , targetp];
    if (queue.total = 0) or (queue.addtime > addtime) then
      begin
          queue.total := 1;
          queue.addtime := addtime;
          queue.data[queue.total].source := startp;
          queue.data[queue.total].target := targetp;
      end
    else
      if same(queue.addtime , addtime) then
        begin
            inc(queue.total);
            queue.data[queue.total].source := startp;
            queue.data[queue.total].target := targetp;
        end;
end;

procedure add(var path : Tpath; rec : RECpath; start : longint);
var
    i          : longint;
begin
    for i := path.total downto start do
      path.data[i + 1] := path.data[i];
    path.data[start] := rec;
end;

procedure addpath(source , target , star , addskill : longint);
var
    p , i ,
    tot        : longint;
    tmpREC     : RECpath;
begin
    p := source;
    tot := 0;
    while p <> target do
      begin
          visited[p] := 1;
          inc(tot);
          for i := 1 to N do
            if (i <> p) and same(backup[p , i] + map[i , target] , map[p , target]) then
              begin
                  inc(path.total);
                  tmpREC.totalteacher := 1;
                  tmpREC.teacher[1] := p;
                  tmpREC.student := i;
                  tmpREC.skills := addskill;
                  tmpREC.needtime := backup[p , i];
                  add(path , tmpREC , tot);
                  p := i;
                  break;
              end;
      end;
    time := time + map[source , target];
    for i := 1 to path.total do
      if target = star then
        break
      else
        if path.data[i].teacher[1] = target then
          begin
              path.data[i].skills := path.data[i].skills or addskill;
              target := path.data[i].student;
          end;
end;

procedure Get_SimpleSolution(star : longint);
var
    skillnum ,
    startpoint ,
    targetpoint ,
    p          : longint;
    queue      : Tqueue;
begin
    for skillnum := 1 to M do
      begin
          queue.total := 0;
          for targetpoint := 1 to N do
            if (targetpoint = star) or (visited[targetpoint] = 1) then
              for startpoint := 1 to N do
                if (1 shl (M - order[skillnum])) and data[startpoint] <> 0 then
                  add_queue(queue , startpoint , targetpoint);
          p := random(queue.total) + 1;

          addpath(queue.data[p].source , queue.data[p].target , star , 1 shl (M - order[skillnum]));
      end;
end;

procedure Improve(star : longint);
var
    i , p1 , p2 ,
    j , k ,
    find , del ,
    addskills  : longint;
    tmptime    : real;
begin
    for i := 1 to path.total do
      begin
          for p1 := 1 to N do
            for j := i to path.total do
              begin
                  p2 := path.data[j].student;
                  if (p1 <> p2) and (know[p1 , p2] = 1) then
                    begin
                        find := 0;
                        for k := 1 to path.data[j].totalteacher do
                          if path.data[j].teacher[k] = p1 then
                            begin
                                find := 1;
                                break;
                            end;
                        if (find = 0) and (data[p1] or path.data[j].skills = data[p1]) then
                          begin
                              inc(path.data[j].totalteacher);
                              path.data[j].teacher[path.data[j].totalteacher] := p1;
                              tmptime := animal[path.data[j].student].study / path.data[j].needtime;
                              tmptime := animal[path.data[j].student].study / (tmptime + animal[p1].teach);
                              time := time - path.data[j].needtime + tmptime;
                              path.data[j].needtime := tmptime;
                          end;
                    end;
              end;

          data[path.data[i].student] := data[path.data[i].student] or path.data[i].skills;
      end;

    i := 1;
    while i <= path.total do
      begin
          p1 := path.data[i].skills;
          for j := 1 to path.total do
            if (i <> j) and (path.data[i].student = path.data[j].student) then
              begin
                  p2 := path.data[j].skills;
                  del := 0;
                  if p1 = p2 then
                    if path.data[i].needtime >= path.data[j].needtime then
                      del := 1
                    else
                  else
                    if p1 or p2 = p2 then
                      del := 1;

                  if del = 1 then
                    begin
                        time := time - path.data[i].needtime;
                        for k := i to path.total - 1 do
                          path.data[k] := path.data[k + 1];
                        dec(path.total);
                        dec(i);
                        break;
                    end;
              end;
          inc(i);
      end;

    i := 1;
    while i <= path.total do
      begin
          data := backdata;
          for j := 1 to path.total do
            if i <> j then
              begin
                  addskills := 1 shl M - 1;
                  for k := 1 to path.data[j].totalteacher do
                    addskills := addskills and data[path.data[j].teacher[k]];
                  data[path.data[j].student] := data[path.data[j].student] or addskills;
              end;
          if data[star] = 1 shl M - 1 then
            begin
                time := time - path.data[i].needtime;
                for k := i to path.total - 1 do
                  path.data[k] := path.data[k + 1];
                dec(path.total);
                dec(i);
            end;
          inc(i);
      end;
end;

procedure process;
var
    star       : longint;
begin
    for star := 1 to N do
      begin
          fillchar(path , sizeof(path) , 0);
          fillchar(visited , sizeof(visited) , 0);
          time := 0;
          backdata := data;
          Get_SimpleSolution(star);
          Improve(star);
          data := backdata;
          if (beststar = 0) or (time < besttime) then
            begin
                besttime := time;
                beststar := star;
                bestpath := path;
            end;
      end;
end;

procedure makeorder;
var
    i , p , j  : longint;
    used       : Tvisited;
begin
    fillchar(used , sizeof(used) , 0);
    fillchar(order , sizeof(order) , 0);
    for i := 1 to M do
      begin
          p := random(M - i + 1) + 1;
          j := 1;
          while p > 0 do
            begin
                if used[j] = 0 then
                  dec(p);
                inc(j);
            end;
          dec(j);
          order[i] := j;
          used[j] := 1;
      end;
end;

procedure work;
var
    i , tmp , j: longint;
begin
    BuildMap;
    Backup := Map;
    Floyd;
    beststar := 0;

    for i := 1 to M do order[i] := i;
    process;
    for i := 1 to M do order[i] := M - i + 1;
    process;
    writeln('Done!');

    write('Processing...  0.0% Completed.');
    for i := 1 to LimitTimes do
      begin
          makeorder;
          process;
          for j := 1 to M div 2 do
            begin
                tmp := order[j];
                order[j] := order[M - j + 1];
                order[M - j + 1] := tmp;
            end;
          process;
          write(#8#8#8#8#8#8#8#8#8#8#8#8#8#8#8#8#8 , i * 100 / LimitTimes : 5 : 1 , '% Completed.');
      end;
    writeln(#8#8#8#8#8#8#8#8#8#8#8#8#8#8#8#8#8'Done!                         ');
    writeln('Please view star' , numfile , '.out or enter ''check ' , numfile , ''' to see the solution.');
end;

procedure out;
var
    i , j      : longint;
begin
    assign(OUTPUT , MainFile + NumFile + OutFile); ReWrite(OUTPUT);
      writeln(bestpath.total);
      for i := 1 to bestpath.total do
        begin
            write(bestpath.data[i].totalteacher);
            for j := 1 to bestpath.data[i].totalteacher do
              write(' ' , bestpath.data[i].teacher[j]);
            writeln(' ' , bestpath.data[i].student);
        end;
      writeln(beststar);
      writeln(besttime : 0 : 6);
    Close(OUTPUT);
end;

Begin
    Info;
    init;
    work;
    out;
End.
