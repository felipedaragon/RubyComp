{ $Id: uConv.pas,v 1.3 2003/11/08 13:22:06 pka Exp $

  Author: Kazuhiro Yoshida
  Modifications: Pirmin Kalberer <pi@sourcepole.com>
                 Felipe Daragon (FD)
                 
  Changes:
  * 15.11.2015, FD - Added support for Delphi XE2 or higher.
}

unit uConv;

{$I heverdef.inc}

interface

uses
{$IFDEF LINUX}
  Types,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils, Classes,
{$IFDEF CLX}
  QStdCtrls, QComCtrls,
{$ENDIF}
{$IFDEF DELPHI6_UP}
  Variants,
{$ENDIF}
  RbType;

function ap_bool(B: Boolean): Tvalue;
function dl_Boolean(v: Tvalue): Boolean;
function ap_Fixnum(v: Integer): Tvalue;
function ap_Integer(v: Integer): Tvalue;
function dl_Integer(v: Tvalue): Integer;
function ap_Float(v: Double): Tvalue;
function dl_Double(v: Tvalue): Double;
function ap_String(S: string): Tvalue;
function dl_String(v: Tvalue): string;
function ap_Variant(A: Variant): Tvalue;
function dl_Variant(v: Tvalue): Variant;
function ap_set_to_ary(var v): Tvalue; deprecated;
function dl_ary_to_set(ary: Tvalue): Integer; deprecated;
function ap_Set(var v): Tvalue;
function dl_Set(ary: Tvalue): Integer;
function dl_class2name(This: Tvalue): string;
function dl_class_name_of(This: Tvalue): string;
function ap_Path(S: string): Tvalue;
function dl_Path(v: Tvalue): string;

implementation

uses uDateTime, macroimp, rubywrapper, wrapimp;

function ap_bool(B: Boolean): Tvalue;
begin
  if B = False then result := Qfalse else result := Qtrue;
end;

function dl_Boolean(v: Tvalue): Boolean;
begin
  result := RTEST(v);
end;

function ap_Fixnum(v: Integer): Tvalue;
begin
  result := INT2FIX(v);
end;

function ap_Integer(v: Integer): Tvalue;
begin
  result := rb_int2inum(v);
end;

function dl_Integer(v: Tvalue): Integer;
begin
  result := NUM2INT(v);
end;

function ap_Float(v: Double): Tvalue;
begin
  result := rb_float_new(v);
end;

function dl_Double(v: Tvalue): Double;
begin
  result := rb_num2dbl(v);
end;

function ap_String(S: string): Tvalue;
begin
  result := rb_str_new(PAnsiChar(AnsiString(S)), length(S));
end;

function dl_String(v: Tvalue): string;
begin
  Check_Type(v, T_STRING);
  SetString(result, ap_str_ptr(v), ap_str_len(v));
end;

function ap_Variant(A: Variant): Tvalue;
begin
  result := Qnil;
  case VarType(A) of
  varSmallint, varInteger, varByte:  result := ap_Fixnum(A);
  varSingle, varDouble, varCurrency: result := ap_Float(A);
//see: [ap-dev:0675]
//  PAnsiChar にキャストしているのは #0 を取り去るためだ。
//  しかしこれだと Pascal 文字列は #0 で切れてしまう。
  varOleStr, varStrArg, varString:   result := ap_String(string(PAnsiChar(AnsiString(A))));
  varBoolean:                        result := ap_bool(A);
  varDate:                           result := ap_DateTime(A);
//see: [ap-dev:0630]
//varSQLTimeStamp:                   result := ap_DateTime(A);
  271:                               result := ap_DateTime(A);
  varEmpty, varNull:                 result := Qnil;
  //
  // not yet
  //
  varDispatch: result := rb_str_new2('varDispatch');
  varError:    result := rb_str_new2('varError');
  varVariant:  result := rb_str_new2('varVariant');
  varUnknown:  result := rb_str_new2('varUnknown');
  varAny:      result := rb_str_new2('varAny');
  varTypeMask: result := rb_str_new2('varTypeMask');
  varArray:    result := rb_str_new2('varArray');
  end;
end;

function dl_Variant(v: Tvalue): Variant;
var
  i: Integer;
  len: Integer;
  ptr: Pvalue;
begin
  case RTYPE(v) of
  T_NIL   : result := Unassigned; // (pi) nil = Unassigned
  T_ARRAY :
    begin
      len := ap_ary_len(v);
      ptr := ap_ary_ptr(v);
      result := VarArrayCreate([0, len-1], varVariant);
      for i := 0 to len-1 do
      begin
        v := ptr^;
        case RTYPE(v) of
        T_NIL   : result[i] := Unassigned;  // (pi) nil = Unassigned
        T_STRING: result[i] := string(dl_String(v));
        T_FIXNUM: result[i] := FIX2INT(v);
        T_BIGNUM: result[i] := NUM2INT(v);
        T_FLOAT : result[i] := NUM2DBL(v);
        T_TRUE  : result[i] := True;
        T_FALSE : result[i] := False;
        T_DATA  :
          if ap_kind_of(v, ap_cDateTime) then
            result := Variant(dl_DateTime(v))
          else
            ap_raise(ap_eArgError, sWrong_arg_type)
          ;
        else
          ap_raise(ap_eArgError, sWrong_arg_type)
        end;
        Inc(ptr);
      end;
    end;
  T_STRING: result := Variant(dl_String(v));
  T_FIXNUM: result := Variant(FIX2INT(v));
  T_BIGNUM: result := Variant(NUM2INT(v)); //??
  T_FLOAT : result := Variant(NUM2DBL(v));
  T_TRUE  : result := Variant(True);
  T_FALSE : result := Variant(False);
  T_DATA  :
    if ap_kind_of(v, ap_cDateTime) then
      result := Variant(dl_DateTime(v))
    else
      ap_raise(ap_eArgError, sWrong_arg_type)
    ;
  else
    ap_raise(ap_eArgError, sWrong_arg_type)
  end;
end;

function ap_set_to_ary(var v): Tvalue;
begin
  result := ap_Set(v);
end;

function dl_ary_to_set(ary: Tvalue): Integer;
begin
  result := dl_Set(ary);
end;

function ap_Set(var v): Tvalue;
var
  i: Shortint;
  n: Integer;
  ary: Tvalue;
begin
  Move(v, i, Sizeof(i));
  ary := rb_ary_new;
  n := 0;
  while i > 0 do
  begin
    if i and 1 = 1 then rb_ary_push(ary, INT2FIX(n));
    i := i shr 1;
    Inc(n);
  end;
  result := ary;
end;

function dl_Set(ary: Tvalue): Integer;
var
  len: Integer;
  ptr: Pvalue;
  v: Integer;
  i: Integer;
begin
  Check_Type(ary, T_ARRAY);
  len := ap_ary_len(ary);
  ptr := ap_ary_ptr(ary);
  v := 0;
  for i := 0 to len-1 do
  begin
    v := v or (1 shl NUM2INT(ptr^));
    Inc(ptr);
  end;
  result := v;
end;

function dl_class2name(This: Tvalue): string;
begin
  result := string(rb_class2name(This));
end;

function dl_class_name_of(This: Tvalue): string;
begin
  result := string(rb_class2name(CLASS_OF(This)));
end;

// ap-dev:0911
{$IFDEF LINUX}
function ap_Path(S: string): Tvalue;
begin
  result := ap_String(S);
end;
function dl_Path(v: Tvalue): string;
begin
  result := StringReplace(dl_String(v), '\', '/', [rfReplaceAll]);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
function ap_Path(S: string): Tvalue;
begin
  result := ap_String(StringReplace(S, '\', '/', [rfReplaceAll]));
end;
function dl_Path(v: Tvalue): string;
begin
  result := StringReplace(dl_String(v), '/', '\', [rfReplaceAll]);
end;
{$ENDIF}

end.
