(* Problem   Fixed Partition Contest Management
** Algorithm Brute Force
** Runtime   O(m^n*n^2)
** Author    Walter Guttmann
** Date      22.02.2003
*)

program contest;

var f: Text;
    avgtime: Real;
    valid: Boolean;
    h, i, j, j1, j2, k, kase, m, minsumtime, mn, n, q, qq, sumtime: Longint;
    bright, s, t: array [0..15] of Longint;
    assign1, minassign, minptime, ptime: array [0..63] of Longint;
    soltime: array [0..63] of array [0..15] of Longint;

begin
  Assign(f, 'contest.in');
  Reset(f);
  Read(f, m, n);
  kase := 1;
  while (m <> 0) or (n <> 0) do begin
    for h := 1 to m do
      Read(f, bright[h]);
    (* IF soltime[j][h] == 0 THEN problem j cannot be solved by member h *)
    (* ELSE problem j requires time soltime[j][h] if solved by member h  *)
    for j := 1 to n do begin
      Read(f, k);
      for i := 1 to k do
        Read(f, s[i], t[i]);
      for h := 1 to m do begin
        soltime[j][h] := 0;
        for i := 1 to k-1 do
          if (s[i] <= bright[h]) and (bright[h] < s[i+1]) then
            soltime[j][h] := t[i];
        if s[k] <= bright[h] then
          soltime[j][h] := t[k]
      end
    end;
    minsumtime := 0;
    (* try all m^n assignments of problems to team members *)
    mn := 1;
    for j := 1 to n do
      mn := mn * m;
    for q := 0 to mn-1 do begin
      (* in this assignment problem j is assigned to member assign1[j] *)
      qq := q;
      for j := 1 to n do begin
        assign1[j] := 1 + (qq mod m);
        qq := qq div m
      end;
      (* all problems must be solvable by the assigned members *)
      valid := True;
      for j := 1 to n do
        if soltime[j][assign1[j]] = 0 then
          valid := False;
      if valid then begin
        (* for each member, problems with shorter solution times are solved first *)
        sumtime := 0;
        for j1 := 1 to n do begin
          h := assign1[j1];
          ptime[j1] := 0;
          for j2 := 1 to n do
            if assign1[j2] = h then
              if (soltime[j2][h] < soltime[j1][h]) or
                 ((soltime[j2][h] = soltime[j1][h]) and (j2 <= j1)) then
                ptime[j1] := ptime[j1] + soltime[j2][h];
          sumtime := sumtime + ptime[j1]
        end;
        if (minsumtime = 0) or (sumtime < minsumtime) then begin
          minsumtime := sumtime;
          for j := 1 to n do begin
            minassign[j] := assign1[j];
            minptime[j] := ptime[j]
          end
        end
      end
    end;
    avgtime := minsumtime / n;
    avgtime := trunc(avgtime * 100 + 0.5) / 100;
    WriteLn('Case ', kase);
    WriteLn('Average solution time = ', avgtime:0:2);
    for j := 1 to n do
      WriteLn('Problem ', j, ' is solved by member ', minassign[j],
              ' from ', minptime[j]-soltime[j][minassign[j]],
              ' to ', minptime[j]);
    WriteLn;
    kase := kase + 1;
    Read(f, m, n)
  end;
  Close(f)
end.

