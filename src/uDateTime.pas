{ $Id: uDateTime.pas,v 1.3 2003/11/08 13:22:06 pka Exp $

  Author: Kazuhiro Yoshida
  Modifications: Pirmin Kalberer <pi@sourcepole.com>
}

unit uDateTime;

interface

uses
{$IFDEF LINUX}
  Types,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
RubyWrapper;

var
  LOCAL_TIME_DIFF : double = 0.0;//DAY
  JD_DIFF         : double = 2415019.0;//DAY
  TIME_T_DIFF     : double = 2209194000.0;//SEC

type
  PDateTime = ^TDateTime;

var
  cDateTime: Tvalue;

function ap_cDateTime: Tvalue;
function ap_DateTime(real: TDateTime): Tvalue;
function dl_DateTime(v: Tvalue): TDateTime;
procedure Init_DateTime;

implementation

uses
  DateUtils,
  SysUtils,
  uConv, uStrUtils;

procedure ap_dispose(p: Pointer); cdecl;
begin
  try
    Dispose(p);
  except
    on E: Exception do;
  end;
end;

function ap_cDateTime: Tvalue;
begin
  result := cDateTime;
end;

function DateTime_alloc(klass: Tvalue; real: TDateTime): Tvalue;
var
  p: PDateTime;
begin
  new(p);
  result := rb_data_object_alloc(klass, p, nil, @ap_dispose);
  p^ := real;
end;

function ap_DateTime(real: TDateTime): Tvalue;
begin
  result := DateTime_alloc(cDateTime, real);
end;

function dl_DateTime(v: Tvalue): TDateTime;
var
  class_name: string;
begin
  result := -1;
  case RTYPE(v) of
  T_FIXNUM, T_FLOAT:
    try
      result := dl_Double(v);
    except
      on E: Exception do
        ap_raise(ap_eArgError, E.message);
    end;
  T_STRING:
    try
      result := StrToDateTime(dl_String(v));
    except
      on E: EConvertError do
        ap_raise(ap_eArgError, E.message);
    end;
  T_OBJECT:
    begin
      class_name := rb_class2name(CLASS_OF(v));
      if class_name = 'Date' then
        result := 
          dl_Double(rb_funcall2(v, rb_intern('jd'), 0, nil)) - jd_diff
      else
        ap_raise(ap_eArgError, sWrong_arg_type);
    end;
  T_DATA:
    begin
      class_name := rb_class2name(CLASS_OF(v));
      if class_name = 'Time' then
        result := 
        (
          dl_Integer(rb_funcall2(v, rb_intern('to_i'), 0, nil)) + Time_T_Diff
        ) / SecsPerDay
      else if ap_kind_of(v, cDateTime) then
        result := PDateTime(ap_data_get_struct(v))^
      else
        ap_raise(ap_eArgError, sWrong_arg_type);
    end;
  else
      ap_raise(ap_eArgError, sWrong_arg_type);
  end;
end;

//(pi) from phi.pas
procedure ap_raise(exc: Tvalue; S: string);
begin
  S := deleteCR(S);
  rb_exc_raise(rb_exc_new2(exc, PChar(S)));
end;

procedure ap_obj_call_init(obj: Tvalue; argc: Integer; argv: Pvalue);
begin
  try
    rb_obj_call_init(obj, argc, argv)
  except
    on E: Exception do
      ap_raise(ap_eArgError, E.classname+': '+E.message);
  end;
end;
//-------

function DateTime_new(argc: Integer; argv: Pointer; This: Tvalue): Tvalue; cdecl;
var
  args: array of Tvalue;
  p: PDateTime;
  y, m, d, h, n, s, z: word;
begin
  SetLength(args, argc);
  args := argv;
  new(p);
  result := rb_data_object_alloc(This, p, nil, @ap_dispose);
  case argc of
  0:
    p^ := Now;
  1:
    p^ := dl_DateTime(args[0]);
  3..7:
    try
      y := FIX2INT(args[0]);
      m := FIX2INT(args[1]);
      d := FIX2INT(args[2]);
      h := 0 ; if argc > 3 then h := FIX2INT(args[3]);
      n := 0 ; if argc > 4 then n := FIX2INT(args[4]);
      s := 0 ; if argc > 5 then s := FIX2INT(args[5]);
      z := 0 ; if argc > 6 then z := FIX2INT(args[6]);
      if (y=0) and (m=0) and (d=0)
      then
        p^ := encodeTime(h, n, s, z)
      else
        p^ := encodeDate(y, m, d) + encodeTime(h, n, s, z);
    except
      on E: Exception do
        ap_raise(ap_eArgError, E.message);
    end;
  else
    ap_raise(ap_eArgError, sWrong_num_of_args);
  end;
  ap_obj_call_init(result, argc, argv);
end;

function DateTime_to_s(This: Tvalue): Tvalue; cdecl;
var
  real: TDateTime;
begin
  real := PDateTime(ap_data_get_struct(This))^;
  if real < 1 then
    result := rb_str_new2(PChar(TimeToStr(real)))
  else
    result := rb_str_new2(PChar(DateTimeToStr(real)));
end;

function DateTime_format(This, f: Tvalue): Tvalue; cdecl;
var
  real: TDateTime;
begin
  result := Qnil;
  try
    real := PDateTime(ap_data_get_struct(This))^;
    result := rb_str_new2(PChar(FormatDateTime(dl_String(f), real)));
  except
    on E: Exception do
      ap_raise(ap_eArgError, E.message);
  end;
end;

procedure apDecodeDateTime(v: Tvalue; var y, m, d, h, n, s, z: word);
var
  real: TDateTime;
begin
  try
    real := PDateTime(ap_data_get_struct(v))^;
    DecodeDate(real, y, m, d);
    DecodeTime(real, h, n, s, z);
  except
    on E: Exception do
      ap_raise(ap_eArgError, E.message);
  end;
end;

procedure apEncodeDateTime(v: Tvalue; y, m, d, h, n, s, z: word);
begin
  try
    PDateTime(ap_data_get_struct(v))^ :=
      EncodeDate(y, m, d) + EncodeTime(h, n, s, 0);
  except
    on E: Exception do
      ap_raise(ap_eArgError, E.message);
  end;
end;

function DateTime_set_year(This, v: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  result := v;
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  apEncodeDateTime(This, FIX2INT(v), m, d, h, n, s, z);
end;

function DateTime_get_year(This: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  result := INT2FIX(y);
end;

function DateTime_set_month(This, v: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  result := v;
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  apEncodeDateTime(This, y, FIX2INT(v), d, h, n, s, z);
end;

function DateTime_get_month(This: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  result := INT2FIX(m);
end;

function DateTime_set_day(This, v: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  result := v;
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  apEncodeDateTime(This, y, m, FIX2INT(v), h, n, s, z);
end;

function DateTime_get_day(This: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  result := INT2FIX(d);
end;

function DateTime_set_hour(This, v: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  result := v;
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  apEncodeDateTime(This, y, m, d, FIX2INT(v), n, s, z);
end;

function DateTime_get_hour(This: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  result := INT2FIX(h);
end;

function DateTime_set_minute(This, v: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  result := v;
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  apEncodeDateTime(This, y, m, d, h, FIX2INT(v), s, z);
end;

function DateTime_get_minute(This: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  result := INT2FIX(n);
end;

function DateTime_set_second(This, v: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  result := v;
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  apEncodeDateTime(This, y, m, d, h, n, FIX2INT(v), z);
end;

function DateTime_get_second(This: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  result := INT2FIX(s);
end;

function DateTime_set_msec(This, v: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  result := v;
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  apEncodeDateTime(This, y, m, d, h, n, s, FIX2INT(v));
end;

function DateTime_get_msec(This: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  result := INT2FIX(z);
end;

function DateTime_to_a(This: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
begin
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  result := rb_ary_new;
  rb_ary_push(result, INT2FIX(y));
  rb_ary_push(result, INT2FIX(m));
  rb_ary_push(result, INT2FIX(d));
  rb_ary_push(result, INT2FIX(h));
  rb_ary_push(result, INT2FIX(n));
  rb_ary_push(result, INT2FIX(s));
  rb_ary_push(result, INT2FIX(z));
end;

function DateTime_add(This, v: Tvalue): Tvalue; cdecl;
begin
  result := ap_DateTime(dl_DateTime(This) + dl_Double(v));
end;

function DateTime_sub(This, v: Tvalue): Tvalue; cdecl;
var
  real: TDateTime;
begin
  real := dl_DateTime(This);
  if ap_kind_of(v, cDateTime) then
    result := ap_Float   (real - dl_DateTime(v))
  else
    result := ap_DateTime(real - dl_Double  (v));
end;

function DateTime_cmp(This, v: Tvalue): Tvalue; cdecl;
var
  l, r: TDateTime;
begin
  l := dl_DateTime(This);
  r := dl_DateTime(v);
  if l > r then result := ap_Fixnum(+1) else
  if l < r then result := ap_Fixnum(-1) else
                result := ap_Fixnum( 0);
end;

function DateTime_eqq(This, v: Tvalue): Tvalue; cdecl;
var
  l, r: TDateTime;
begin
  l := dl_DateTime(This);
  r := dl_DateTime(v);
  if l = r then result := Qtrue else result := Qfalse;
end;

function DateTime_inspect(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_String(
    '#<'+dl_class_name_of(This)+': '+
    DateTimeToStr(dl_DateTime(This))+'>');
end;

function DateTime_today(This: Tvalue): Tvalue; cdecl;
begin
  result := DateTime_alloc(This, date);
end;

function DateTime_get_time_t(This: Tvalue): Tvalue; cdecl;
begin
  result := rb_dbl2big(dl_DateTime(This)*SecsPerDay - Time_T_Diff + 0.0001);
end;

function DateTime_get_jd(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Float(dl_DateTime(This)+jd_diff);
end;

function Phi_get_date_separator(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_String(DateSeparator);
end;

function Phi_set_date_separator(This, v: Tvalue): Tvalue; cdecl;
var
  s:string;
begin
  result := Qnil;
  s := dl_String(v);
  if Length(s) = 1 then
  begin
    DateSeparator := s[1];
    result := v;
  end else
    ap_raise(ap_eArgError, sWrong_arg_type);
end;

function Phi_get_time_separator(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_String(TimeSeparator);
end;

function Phi_set_time_separator(This, v: Tvalue): Tvalue; cdecl;
var
  s:string;
begin
  result := Qnil;
  s := dl_String(v);
  if Length(s) = 1 then
  begin
    TimeSeparator := s[1];
    result := v;
  end else
    ap_raise(ap_eArgError, sWrong_arg_type);
end;

function Phi_get_short_date_format(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_String( ShortDateFormat );
end;

function Phi_set_short_date_format(This, v: Tvalue): Tvalue; cdecl;
begin
  result := v;
  ShortDateFormat := dl_String(v);
end;

function Phi_get_long_date_format(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_String( LongDateFormat );
end;

function Phi_set_long_date_format(This, v: Tvalue): Tvalue; cdecl;
begin
  result := v;
  LongDateFormat := dl_String(v);
end;

function Phi_get_long_time_format(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_String( LongTimeFormat );
end;

function Phi_set_long_time_format(This, v: Tvalue): Tvalue; cdecl;
begin
  result := v;
  LongTimeFormat := dl_String(v);
end;

function Phi_get_short_time_format(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_String( ShortTimeFormat );
end;

function Phi_set_short_time_format(This, v: Tvalue): Tvalue; cdecl;
begin
  result := v;
  ShortTimeFormat := dl_String(v);
end;

function DateTime_time(This: Tvalue): Tvalue; cdecl;
var
  y, m, d, h, n, s, z: word;
  real: TDateTime;
begin
  apDecodeDateTime(This, y, m, d, h, n, s, z);
  real := EncodeTime(h, n, s, 0);
  result := DateTime_alloc(cDateTime, real);
end;

// -- end_of_xxxx

function DateTime_end_of_day(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_DateTime( EndOfTheDay(dl_DateTime(This)) );
end;

function DateTime_end_of_month(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_DateTime( EndOfTheMonth(dl_DateTime(This)));
end;

function DateTime_end_of_year(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_DateTime( EndOfTheYear(dl_DateTime(This)));
end;

// -- start_of_xxxx

function DateTime_start_of_day(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_DateTime( StartOfTheDay(dl_DateTime(This)));
end;

function DateTime_start_of_month(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_DateTime( StartOfTheMonth(dl_DateTime(This)));
end;

function DateTime_start_of_year(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_DateTime( StartOfTheYear(dl_DateTime(This)));
end;

// -- xxxx_of_xxxx

function DateTime_cweek(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Integer( WeekOfTheYear(dl_DateTime(This)));
end;

function DateTime_day_of_year(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Integer( DayOfTheYear(dl_DateTime(This)));
end;

function DateTime_cwday(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Integer( DayOfTheWeek(dl_DateTime(This)));
end;

function DateTime_day_of_week(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Fixnum(DayOfWeek(dl_DateTime(This)));
end;

function DateTime_wday(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Fixnum(DayOfWeek(dl_DateTime(This))-1);
end;

function DateTime_sec_of_year(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Integer( SecondOfTheYear(dl_DateTime(This)));
end;

function DateTime_sec_of_month(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Integer( SecondOfTheMonth(dl_DateTime(This)));
end;

function DateTime_sec_of_day(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Integer( SecondOfTheDay(dl_DateTime(This)));
end;

function DateTime_msec_of_day(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Integer( MilliSecondOfTheDay(dl_DateTime(This)));
end;

//-- inc_xx

function DateTime_inc_year(argc: Integer; argv: Pointer; This: Tvalue): Tvalue; cdecl;
var
  args: array of Tvalue;
  i: Integer;
begin
asm
  FInit;
end;
  SetLength(args, argc);
  args := argv;
  if argc = 1 then
    i := NUM2INT(args[0])
  else
    i := 1;
  result := ap_DateTime(IncYear(dl_DateTime(This), i));
end;

function DateTime_inc_month(argc: Integer; argv: Pointer; This: Tvalue): Tvalue; cdecl;
var
  args: array of Tvalue;
  i: Integer;
begin
asm
  FInit;
end;
  SetLength(args, argc);
  args := argv;
  if argc = 1 then
    i := NUM2INT(args[0])
  else
    i := 1;
  result := ap_DateTime(IncMonth(dl_DateTime(This), i));
end;

function DateTime_inc_week(argc: Integer; argv: Pointer; This: Tvalue): Tvalue; cdecl;
var
  args: array of Tvalue;
  i: Integer;
begin
asm
  FInit;
end;
  SetLength(args, argc);
  args := argv;
  if argc = 1 then
    i := NUM2INT(args[0])
  else
    i := 1;
  result := ap_DateTime(IncWeek(dl_DateTime(This), i));
end;


function DateTime_inc_day(argc: Integer; argv: Pointer; This: Tvalue): Tvalue; cdecl;
var
  args: array of Tvalue;
  i: Integer;
begin
asm
  FInit;
end;
  SetLength(args, argc);
  args := argv;
  if argc = 1 then
    i := NUM2INT(args[0])
  else
    i := 1;
  result := ap_DateTime(IncDay(dl_DateTime(This), i));
end;

function DateTime_inc_hour(argc: Integer; argv: Pointer; This: Tvalue): Tvalue; cdecl;
var
  args: array of Tvalue;
  i: Integer;
begin
asm
  FInit;
end;
  SetLength(args, argc);
  args := argv;
  if argc = 1 then
    i := NUM2INT(args[0])
  else
    i := 1;
  result := ap_DateTime(IncHour(dl_DateTime(This), i));
end;

function DateTime_inc_minute(argc: Integer; argv: Pointer; This: Tvalue): Tvalue; cdecl;
var
  args: array of Tvalue;
  i: Integer;
begin
asm
  FInit;
end;
  SetLength(args, argc);
  args := argv;
  if argc = 1 then
    i := NUM2INT(args[0])
  else
    i := 1;
  result := ap_DateTime(IncMinute(dl_DateTime(This), i));
end;

function DateTime_inc_sec(argc: Integer; argv: Pointer; This: Tvalue): Tvalue; cdecl;
var
  args: array of Tvalue;
  i: Integer;
begin
asm
  FInit;
end;
  SetLength(args, argc);
  args := argv;
  if argc = 1 then
    i := NUM2INT(args[0])
  else
    i := 1;
  result := ap_DateTime(IncSecond(dl_DateTime(This), i));
end;

function DateTime_inc_msec(argc: Integer; argv: Pointer; This: Tvalue): Tvalue; cdecl;
var
  args: array of Tvalue;
  i: Integer;
begin
asm
  FInit;
end;
  SetLength(args, argc);
  args := argv;
  if argc = 1 then
    i := NUM2INT(args[0])
  else
    i := 1;
  result := ap_DateTime(IncMilliSecond(dl_DateTime(This), i));
end;

//-- etc

function DateTime_leap_p(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Bool( IsInLeapYear(dl_DateTime(This)));
end;

function DateTime_pm_p(This: Tvalue): Tvalue; cdecl;
begin
  result := ap_Bool( IsPM(dl_DateTime(This)));
end;

// ----

{$IFDEF MSWINDOWS}
function LocalTimeDiff: Double;
var
  sys1, loc, sys2: TSystemTime;
  sysDateTime, locDateTime: TDateTime;
  i: Integer;
begin
  for i := 1 to 10 do
  begin
    GetSystemTime(sys1);
    GetLocalTime(loc);
    GetSystemTime(sys2);
    if sys2.wSecond = sys1.wSecond then break;
  end;
  with sys1 do SysDateTime := encodeDate(wYear, wMonth, wDay)
                             +encodeTime(wHour, wMinute, wSecond, 0);
  with loc  do LocDateTime := encodeDate(wYear, wMonth, wDay)
                             +encodeTime(wHour, wMinute, wSecond, 0);
  result := LocDateTime - SysDateTime;
end;
{$ENDIF}

procedure Init_DateTime;
begin
{$IFDEF MSWINDOWS}
  LOCAL_TIME_DIFF	:= LocalTimeDiff;//DAY
{$ELSE}
  LOCAL_TIME_DIFF	:= 0.0;//DAY
{$ENDIF}
  TIME_T_DIFF	:= 2209161600.0 + LOCAL_TIME_DIFF * SecsPerDay;
  //
  //  not correct JD_DIFF, because Date do not support UTC.
  //
  //JD_DIFF	: double = 2415019.0 + LOCAL_TIME_DIFF;

  { (pi) Apollo
  ap_define_const(mPhi, 'SecsPerDay', INT2FIX(SecsPerDay));
  ap_define_const(mPhi, 'MSecsPerDay', INT2FIX(MSecsPerDay));
  ap_define_const(mPhi, 'LocalTimeDiff', ap_Float(LOCAL_TIME_DIFF));

  cDateTime := rb_define_class_under(mPhi, 'DateTime', ap_cObject);
  DefineSingletonMethod(cDateTime, 'new', DateTime_new);
  DefineSingletonMethod(cDateTime, 'now', DateTime_new);
  DefineAttrSet(cDateTime, 'year', DateTime_set_year);
  DefineAttrGet(cDateTime, 'year', DateTime_get_year);
  DefineAttrSet(cDateTime, 'month', DateTime_set_month);
  DefineAttrGet(cDateTime, 'month', DateTime_get_month);
  DefineAttrSet(cDateTime, 'day', DateTime_set_day);
  DefineAttrGet(cDateTime, 'day', DateTime_get_day);
  DefineAttrSet(cDateTime, 'hour', DateTime_set_hour);
  DefineAttrGet(cDateTime, 'hour', DateTime_get_hour);
  DefineAttrSet(cDateTime, 'minute', DateTime_set_minute);
  DefineAttrGet(cDateTime, 'minute', DateTime_get_minute);
  DefineAttrSet(cDateTime, 'second', DateTime_set_second);
  DefineAttrGet(cDateTime, 'second', DateTime_get_second);

  DefineAttrSet(cDateTime, 'msec', DateTime_set_msec);
  DefineAttrGet(cDateTime, 'msec', DateTime_get_msec);
  DefineAttrGet(cDateTime, 'to_s', DateTime_to_s);
  DefineAttrGet(cDateTime, 'to_a', DateTime_to_a);
  rb_define_method(cDateTime, 'format', @DateTime_format, 1);

  rb_define_method(cDateTime, '+', @DateTime_add, 1);
  rb_define_method(cDateTime, '-', @DateTime_sub, 1);
  rb_define_method(cDateTime, '<=>', @DateTime_cmp, 1);
  rb_include_module(cDateTime, ap_mComparable);
  rb_define_method(cDateTime, '===', @DateTime_eqq, 1);

  rb_define_method(cDateTime, 'inspect', @DateTime_inspect, 0);
  rb_define_singleton_method(cDateTime, 'today', @DateTime_today,0);
  DefineModuleAttrGet(mPhi, 'date_separator', Phi_get_date_separator);
  DefineModuleAttrSet(mPhi, 'date_separator', Phi_set_date_separator);
  DefineModuleAttrGet(mPhi, 'time_separator', Phi_get_time_separator);
  DefineModuleAttrSet(mPhi, 'time_separator', Phi_set_time_separator);
  DefineAttrGet(cDateTime, 'time_t', DateTime_get_time_t);
  DefineAttrGet(cDateTime, 'jd', DateTime_get_jd);

  rb_define_method(cDateTime, 'time', @DateTime_time, 0);

  DefineModuleAttrGet(mPhi, 'short_date_format', Phi_get_short_date_format);
  DefineModuleAttrSet(mPhi, 'short_date_format', Phi_set_short_date_format);
  DefineModuleAttrGet(mPhi, 'short_time_format', Phi_get_short_time_format);
  DefineModuleAttrSet(mPhi, 'short_time_format', Phi_set_short_time_format);
  DefineModuleAttrGet(mPhi, 'long_date_format', Phi_get_long_date_format);
  DefineModuleAttrSet(mPhi, 'long_date_format', Phi_set_long_date_format);
  DefineModuleAttrGet(mPhi, 'long_time_format', Phi_get_long_time_format);
  DefineModuleAttrSet(mPhi, 'long_time_format', Phi_set_long_time_format);

  DefineModuleAttrGet(mPhi, 'date_format', Phi_get_short_date_format);
  DefineModuleAttrSet(mPhi, 'date_format', Phi_set_short_date_format);
  DefineModuleAttrGet(mPhi, 'time_format', Phi_get_long_time_format);
  DefineModuleAttrSet(mPhi, 'time_format', Phi_set_long_time_format);

  // -- ++++
  //rb_define_method(cDateTime, 'date',	@DateTime_date, 0);
  rb_define_method(cDateTime, 'date',	@DateTime_start_of_day, 0);
  rb_define_method(cDateTime, 'start_of_day',	@DateTime_start_of_day, 0);
  rb_define_method(cDateTime, 'start_of_month',	@DateTime_start_of_month, 0);
  rb_define_method(cDateTime, 'start_of_year',	@DateTime_start_of_year, 0);

  rb_define_method(cDateTime, 'end_of_day',	@DateTime_end_of_day, 0);
  rb_define_method(cDateTime, 'end_of_month',	@DateTime_end_of_month, 0);
  rb_define_method(cDateTime, 'end_of_year',	@DateTime_end_of_year, 0);

  rb_define_method(cDateTime, 'cweek',	@DateTime_cweek, 0);

  rb_define_method(cDateTime, 'month_of_year',	@DateTime_get_month, 0);

  rb_define_method(cDateTime, 'cwday',	@DateTime_cwday, 0);
  rb_define_method(cDateTime, 'wday',	@DateTime_wday, 0);
  rb_define_method(cDateTime, 'day_of_week',	@DateTime_day_of_week, 0); // Šù‘¶
  rb_define_method(cDateTime, 'day_of_month',	@DateTime_get_day, 0);
  rb_define_method(cDateTime, 'day_of_year',	@DateTime_day_of_year, 0);
  rb_define_method(cDateTime, 'yday',	@DateTime_day_of_year, 0);

  rb_define_method(cDateTime, 'sec_of_day',	@DateTime_sec_of_day, 0);
  rb_define_method(cDateTime, 'sec_of_month',	@DateTime_sec_of_month, 0);
  rb_define_method(cDateTime, 'sec_of_year',	@DateTime_sec_of_year, 0);

  rb_define_method(cDateTime, 'msec_of_day',	@DateTime_msec_of_day, 0);

  rb_define_method(cDateTime, 'inc_year',	@DateTime_inc_year, -1);
  rb_define_method(cDateTime, 'inc_month',	@DateTime_inc_month, -1); // Šù‘¶
  rb_define_method(cDateTime, 'inc_week',	@DateTime_inc_week, -1);
  rb_define_method(cDateTime, 'inc_day',	@DateTime_inc_day, -1);
  rb_define_method(cDateTime, 'inc_hour',	@DateTime_inc_hour, -1);
  rb_define_method(cDateTime, 'inc_minute',	@DateTime_inc_minute, -1);
  rb_define_method(cDateTime, 'inc_sec',	@DateTime_inc_sec, -1);
  rb_define_method(cDateTime, 'inc_msec',	@DateTime_inc_msec, -1);

  rb_define_method(cDateTime, 'leap?',	@DateTime_leap_p, 0);
  rb_define_method(cDateTime, 'pm?',	@DateTime_pm_p, 0);
  }
end;

end.
