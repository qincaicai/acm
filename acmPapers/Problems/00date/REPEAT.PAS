{$M 2000,0,0 }   { 16K stack, no heap }
uses dos;
var f : text;
    s : string;
    ch : char;
    a : longint; code : integer;
    least : longint;
begin
  least := 0;
  repeat
    SwapVectors;
    exec('e:\ch\home3\doomsday\dmaker.exe', '');
    SwapVectors;
    SwapVectors;
    exec('e:\ch\home3\doomsday\date.exe', '');
    SwapVectors;

    if DosExitCode <> 0 then halt;

    assign(f, 'date.out');
    reset(f);
    readln(f, s);
    if s[1] <> 'N' then
      begin
        val(s, a, code);
        if a > least then
          begin
            writeln(s);
            readln(ch);
            least := a;
            if ch = 'y' then exit;
          end;
      end;
    close(f);
  until false;
end.
