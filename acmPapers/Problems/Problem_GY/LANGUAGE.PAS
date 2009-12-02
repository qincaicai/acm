program Language_Translator;
const
  inputfile = 'language.in';
  outputfile = 'language.out';
  CONST_ = 1;
  VAR_ = 2;
  ARRAY_ = 3;
  OTHER_ = 4;
type
  token = string[10];
  rectype = record
              name : token;
              t : shortint;
              v : longint;
              len : integer;
            end;
var
  list : array[1..11000]of ^rectype;
  last : integer;
  lookahead : token;
  buf : char;

procedure error;
begin
  rewrite(output);
  writeln('Compile Error');
  close(output);
  halt;
end;

function nexttoken:token;

procedure skip_white_space;
begin
  if ord(buf) > ord(' ') then exit;
  buf := #0;
  if seekeof then ;
end;

procedure putback(ch:char);
begin
  buf := ch;
end;

procedure readchar(var ch:char);
begin
  if buf <> #0 then begin
    ch := buf;
    buf := #0;
  end else
    read(ch);
end;

var s : token;
    ch : char;
begin
  s := '';
  skip_white_space;
  readchar(ch);
  if ch in ['0'..'9'] then begin
    while ch in ['0'..'9'] do begin
      s := s + ch;
      readchar(ch);
    end;
    putback(ch);
    nexttoken := s;
  end
  else if ch in ['a'..'z','A'..'Z','_'] then begin
    s := s + ch;
    readchar(ch);
    while ch in ['0'..'9','a'..'z','A'..'Z','_'] do begin
      s := s + ch;
      readchar(ch);
    end;
    putback(ch);
    nexttoken := s;
  end else if ch = ':' then begin
    readchar(ch);
    if ch = '=' then nexttoken := ':='
                else begin
                       nexttoken := ':';
                       putback(ch);
                     end;
  end
  else nexttoken := ch;
end;

procedure match(s:token);
begin
  if lookahead = s
    then lookahead := nexttoken
    else error;
end;

function posint:longint;
var v : longint;
    s : token;
    err:integer;
begin
  s:=lookahead;
  lookahead := nexttoken;
  val(s,v,err);
  if err <> 0 then error;
  if v < 0 then error;
  posint := v;
end;

function lookup(s:token):integer;
var p:integer;
begin
  p := 1;
  while p <= last do begin
    if list[p]^.name = s then begin
      lookup := p;
      exit;
    end;
    inc(p,list[p]^.len);
  end;
  lookup := 0;
end;

procedure insert(s:token;t:shortint;v:longint;len:integer);
var p: integer;
begin
  p:=lookup(s);
  if p <> 0  then error;
  for p:=1 to len do begin
    inc(last);
    new(list[last]);
    list[last]^.name := s;
    list[last]^.t := t;
    list[last]^.v := v;
    list[last]^.len := len - p + 1;
  end;
end;

procedure dclrconst;
var s : token;
    v : longint;
begin
  if lookahead <> 'CONST' then exit;
  match('CONST');
  repeat
    s:=lookahead;
    lookahead := nexttoken;
    match('=');
    v:=posint;
    insert(s,CONST_,v,1);
    if lookahead <> ';' then break;
    match(';');
  until false;
end;

procedure dclrarray;
var len :integer;
    s:token;
begin
  match('ARRAY');
  s := lookahead;
  lookahead := nexttoken;
  match('[');
  len := posint;
  if len = 0 then error;
  match(']');
  insert(s,ARRAY_,0,len);
end;

procedure dclrvar;
begin
  if lookahead <> 'VAR' then exit;
  match('VAR');
  repeat
    match('INTEGER');
    match(':');
    if lookahead = 'ARRAY'
      then dclrarray
      else begin
             insert(lookahead,VAR_,0,1);
             lookahead := nexttoken;
           end;
    if lookahead <> ';' then break;
    match(';');
  until false;
end;

function getvar:integer; forward;

function factor:longint;
var p:longint;
begin
  if lookahead[1] in ['0'..'9']
    then factor := posint
    else begin
           p := lookup(lookahead);
           if p <= 0 then error;
           if list[p]^.t = CONST_
             then begin
                    factor := list[p]^.v;
                    lookahead := nexttoken;
                  end
             else begin
                    p := getvar;
                    factor := list[p]^.v;
                  end;
         end;
end;

function item:longint;
var v,v1:longint;
begin
  v := factor;
  while lookahead = '*' do begin
    match('*');
    v1 := factor;
    v := v * v1;
  end;
  item := v;
end;

function expr:longint;
var v,v1:longint;
    op : char;
begin
  v := item;
  while (lookahead = '+') or (lookahead = '-') do begin
    op := lookahead[1];
    lookahead := nexttoken;
    v1 := item;
    if op = '+' then v := v + v1
                else v := v - v1;
  end;
  expr := v;
end;

function getvar:integer;
var s : token;
    p,v : longint;
begin
  s := lookahead;
  lookahead := nexttoken;
  p := lookup(s);
  if p <= 0 then error;
  if list[p]^.t = ARRAY_ then begin
    match('[');
    v := expr;
    match(']');
    if (p + v > last) or (list[p+v]^.name <> list[p]^.name)
      then error;
    getvar := p + v;
  end
  else if list[p]^.t = VAR_ then getvar := p
  else error;
end;

function relation_op:char;
var op:char;
begin
  if lookahead = '='
    then op := '='
    else if lookahead = '<'
           then op := '<'
           else if lookahead = '>'
                  then op := '>'
                  else error;
  lookahead := nexttoken;
  relation_op := op;
end;

procedure comseq(print:boolean); forward;

procedure com(print:boolean);
var v1,v2,v:longint;
    op:char;
    p : integer;
    yes :boolean;
begin
  if lookahead = 'BEGIN' then begin
    match('BEGIN');
    comseq(print);
    match('END')
  end
  else if lookahead = 'PRINT' then begin
    match('PRINT');
    v := expr;
    if print then writeln(v);
  end
  else if lookahead = 'IF' then begin
    match('IF');
    v1 := expr;
    op := relation_op;
    v2 := expr;
    case op of
      '=' : yes := v1 = v2;
      '<' : yes := v1 < v2;
      '>' : yes := v1 > v2;
    end;
    match('THEN');
    com(yes);
    if lookahead = 'ELSE' then begin
      match('ELSE');
      com(not yes);
    end;
  end else begin
    p := getvar;
    match(':=');
    v := expr;
    list[p]^.v := v;
  end;
end;

procedure commands(print:boolean);
begin
  com(print);
  while lookahead = ';' do begin
    match(';');
    com(print);
  end;
end;

procedure comseq(print:boolean);
begin
  if lookahead <> 'END' then commands(print);
end;

procedure init;
begin
  last := 0;
  buf := #0;
  insert('PROGRAM',OTHER_,0,1);
  insert('CONST',OTHER_,0,1);
  insert('VAR',OTHER_,0,1);
  insert('INTEGER',OTHER_,0,1);
  insert('ARRAY',OTHER_,0,1);
  insert('BEGIN',OTHER_,0,1);
  insert('END',OTHER_,0,1);
  insert('IF',OTHER_,0,1);
  insert('THEN',OTHER_,0,1);
  insert('ELSE',OTHER_,0,1);
  insert('PRINT',OTHER_,0,1);
end;

begin
  assign(input,inputfile);
  reset(input);
  assign(output,outputfile);
  rewrite(output);
  init;
  lookahead := nexttoken;
  match('PROGRAM');
  insert(lookahead,OTHER_,0,1);
  lookahead := nexttoken;
  match(';');
  dclrconst;
  dclrvar;
  match('BEGIN');
  comseq(true);
  match('END');
  match('.');
  close(input);
  close(output);
end.