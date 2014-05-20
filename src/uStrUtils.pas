unit uStrUtils;

{
author: YOSHIDA Kazuhiro
mailto: moriq@moriq.com
}

interface

function chop(const S: string): string;
{
  末尾 ( おそらく '=' ) を捨てる。
}

function chopHead(S: string): string;
{
  先頭 ( おそらく 'T' ) を捨てる。
}

function joinEq(const S: string): string;
{
  '=' を加える。
}

function trimUnder(const S: string): string;
{
  '_' を捨てる。
}

function chopUnder(const S: string): string;
{
  '_' を捨てる。
  末尾 ( おそらく '=' ) を捨てる。
}

function Capitalize1(const S: string): string;
{
  Delphi Capitalize
  小文字の後以外の大文字は，小文字にする。
  '_' の後に小文字が来たら，大文字にする。'_' は取る。
      先頭に小文字が来たら，大文字にする。
}

function UpperCase1(const S: string): string;
{
  Ruby constant のための UpperCase
  小文字の後に大文字が来たら，その大文字の直前に '_' を入れる。
}

function LowerCase1(const S: string): string;
{
  Ruby method のための LowerCase
  小文字の後に大文字が来たら，その大文字の直前に '_' を入れる。
}

function ParamCount1(CommandLine: PChar): Integer;
function ParamStr1(CommandLine: PChar; Index: Integer): string;

function deleteCR(S: string): string;
{
  CR(#13) を捨てる。
}

implementation

uses SysUtils;

function chop(const S: string): string;
begin
  Result := Copy(S, 1, Length(S)-1);
end;

function chopHead(S: string): string;
begin
  Result := Copy(S, 1+1, Length(S));
end;

function joinEq(const S: string): string;
begin
  Result := S + '=';
end;

function trimUnder(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
  SepCnt: Integer;
begin
  L := Length(S);
  if L = 0 then begin Result := S; Exit end;
  SepCnt := 0;
  Source := Pointer(S);

  while L <> 0 do
  begin
    Ch := Source^;
    if Ch = '_' then Inc(SepCnt);
    Inc(Source);
    Dec(L);
  end;

  L := Length(S)-SepCnt;
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);

  while L <> 0 do
  begin
    while Source^ = '_' do Inc(Source);
    Ch := Source^;
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function chopUnder(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
  SepCnt: Integer;
begin
  L := Length(S);
  if L = 0 then begin Result := S; Exit end;
  SepCnt := 0;
  Source := Pointer(S);

  while L <> 0 do
  begin
    Ch := Source^;
    if Ch = '_' then Inc(SepCnt);
    Inc(Source);
    Dec(L);
  end;

  L := Length(S)-SepCnt-1;
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);

  while L <> 0 do
  begin
    while Source^ = '_' do Inc(Source);
    Ch := Source^;
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function Capitalize1(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
  PreLow, Low, Upp, PreSep, Sep: Boolean;
  SepCnt: Integer;
begin
  L := Length(S);
  if L = 0 then begin Result := S; Exit end;
  SepCnt := 0;
  Source := Pointer(S);

  while L <> 0 do
  begin
    Ch := Source^;
    Sep := Ch = '_';
    if Sep then Inc(SepCnt);
    Inc(Source);
    Dec(L);
  end;

  L := Length(S);
  SetLength(Result, L-SepCnt);
  Source := Pointer(S);
  Dest := Pointer(Result);

  Ch := Source^;
  Low := (Ch >= 'a') and (Ch <= 'z');
  Sep := Ch = '_';
  if Low then Dec(Ch, 32);
  PreLow := Low;
  PreSep := Sep;
  if not Sep then
  begin
    Dest^ := Ch;
    Inc(Dest);
  end;
  Inc(Source);
  Dec(L);

  while L <> 0 do
  begin
    Ch := Source^;
    Low := (Ch >= 'a') and (Ch <= 'z');
    Upp := (Ch >= 'A') and (Ch <= 'Z');
    Sep := Ch = '_';
    if Low and PreSep then Dec(Ch, 32);
    if Upp and not PreLow and not PreSep then Inc(Ch, 32);
    PreLow := Low;
    PreSep := Sep;
    if not Sep then
    begin
      Dest^ := Ch;
      Inc(Dest);
    end;
    Inc(Source);
    Dec(L);
  end;
end;

function UpperCase1(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
  PreLow, Low, Upp: Boolean;
  SepCnt: Integer;
begin
  L := Length(S);
  if L = 0 then begin Result := S; Exit end;
  SepCnt := 0;
  Source := Pointer(S);

  Ch := Source^;
  PreLow := (Ch >= 'a') and (Ch <= 'z');
  Inc(Source);
  Dec(L);

  while L <> 0 do
  begin
    Ch := Source^;
    Low := (Ch >= 'a') and (Ch <= 'z');
    Upp := (Ch >= 'A') and (Ch <= 'Z');
    if Upp and PreLow then Inc(SepCnt);
    PreLow := Low;
    Inc(Source);
    Dec(L);
  end;

  L := Length(S);
  SetLength(Result, L+SepCnt);
  Source := Pointer(S);
  Dest := Pointer(Result);

  Ch := Source^;
  PreLow := (Ch >= 'a') and (Ch <= 'z');
  if PreLow then Dec(Ch, 32);
  Dest^ := Ch;
  Inc(Source);
  Inc(Dest);
  Dec(L);

  while L <> 0 do
  begin
    Ch := Source^;
    Low := (Ch >= 'a') and (Ch <= 'z');
    Upp := (Ch >= 'A') and (Ch <= 'Z');
    if Low then Dec(Ch, 32);
    if Upp and PreLow then begin Dest^ := '_'; Inc(Dest) end;
    PreLow := Low;
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function LowerCase1(const S: string): string;
type
  TState = (Z, UU, UL, L);
var
  i:integer;
  sw:TState;
  c:char;
begin
  result := AnsiLowerCase(S);
  sw := Z;
  for i := length(S) downto 1 do begin
    c := S[i];
    if c in ['a'..'z'] then begin
      if (sw = UU) or (sw = UL) then begin
        insert('_', result, i+1);
      end;
      sw := L;
    end else if c in ['A'..'Z'] then begin
      if sw = UL then begin
        insert('_', result, i+1);
        sw := UU;
      end else if sw = L then begin
        sw := UL;
      end else begin
        sw := UU;
      end;
    end else begin
      sw := Z;
    end;
  end;
end;

function GetParamStr1(P: PChar; var Param: string): PChar;
var
  Len: Integer;
  Buffer: array[0..4095] of Char;
begin
  while True do
  begin
    while (P[0] <> #0) and (P[0] <= ' ') do Inc(P);
    if (P[0] = '"') and (P[1] = '"') then Inc(P, 2) else Break;
  end;
  Len := 0;
  while (P[0] > ' ') and (Len < SizeOf(Buffer)) do
    if P[0] = '"' then
    begin
      Inc(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Buffer[Len] := P[0];
        Inc(Len);
        Inc(P);
      end;
      if P[0] <> #0 then Inc(P);
    end else
    begin
      Buffer[Len] := P[0];
      Inc(Len);
      Inc(P);
    end;
  SetString(Param, Buffer, Len);
  Result := P;
end;

function ParamCount1(CommandLine: PChar): Integer;
var
  P: PChar;
  S: string;
begin
  P := GetParamStr1(CommandLine, S);
  Result := 0;
  while True do
  begin
    P := GetParamStr1(P, S);
    if S = '' then Break;
    Inc(Result);
  end;
end;

function ParamStr1(CommandLine: PChar; Index: Integer): string;
var
  P: PChar;
begin
  P := CommandLine;
  while True do
  begin
    P := GetParamStr1(P, Result);
    if (Index = 0) or (Result = '') then Break;
    Dec(Index);
  end;
end;

function deleteCR(S: string): string;
begin
  Result := StringReplace(S, #13, '', [rfReplaceAll]);
end;

end.
