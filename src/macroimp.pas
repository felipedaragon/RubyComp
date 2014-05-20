function FIXNUM_P(var x): Boolean;
begin
  result := (Integer(x) and FIXNUM_FLAG) <> 0;
end;

function INT2FIX(i: Integer): Tvalue;
begin
  result := (Tvalue(i) shl 1) or FIXNUM_FLAG;
end;

function INT2NUM(i: Integer): Tvalue;
begin
  result := rb_int2inum(i);
end;

function UINT2NUM(i: Integer): Tvalue;
begin
  result := rb_uint2inum(i);
end;

{ thank you, kimura! [ap-list:0317] }
function FIX2INT(var x): Integer;
begin
  result := Integer(x);
asm
  sar result,1
end;
end;

function NUM2INT(var x): Integer;
begin
  if FIXNUM_P(x) then
    result := FIX2INT(x)
  else
    result := rb_num2long(Tvalue(x));
end;

function NUM2UINT(var x): Cardinal;
begin
  result := rb_num2ulong(Tvalue(x));
end;

function NUM2DBL(var x): Double;
begin
  result := rb_num2dbl(Tvalue(x));
end;

function IMMEDIATE_P(var x): Boolean;
begin
  result := (Tvalue(x) and IMMEDIATE_MASK) <> 0;
end;

function SYMBOL_P(var x): Boolean;
begin
  result := (Integer(x) and $ff) = SYMBOL_FLAG;
end;

function ID2SYM(var x): Tvalue;
begin
  result := (Integer(x) shl 8) or SYMBOL_FLAG;
end;

function SYM2ID(var x): Tid;
begin
  result := Integer(x);
asm
  sar result,8
end;
end;

function dl_String(var x): PChar;
var
  len: Integer;
begin
  result := rb_str2cstr(Tvalue(x), len);
end;

function RTEST(var v): Boolean;
begin
  result := (Tvalue(v) and not Qnil) <> 0;
end;

function NIL_P(var v): Boolean;
begin
  result := (Tvalue(v) = Qnil);
end;

function SPECIAL_CONST_P(var x): Boolean;
begin
  result := IMMEDIATE_P(x) or not RTEST(x);
end;

function ap_kind_of(v, klass: Tvalue): Boolean;
var
  b: Tvalue;
begin
  b := rb_obj_is_kind_of(v, klass);
  result := RTEST(b);
end;

function ap_class_of(obj: Tvalue): Tvalue;
begin
  if FIXNUM_P(obj) then
    Result := ap_cFixnum
  else if obj = Qnil then
    Result := ap_cNilClass
  else if obj = Qfalse then
    Result := ap_cFalseClass
  else if obj = Qtrue then
    Result := ap_cTrueClass
  else if SYMBOL_P(obj) then
    Result := ap_cSymbol
  else
    Result := PRBASIC(obj)^.klass;
end;

function ap_type(obj: Tvalue): Integer;
begin
  if FIXNUM_P(obj) then
    Result := T_FIXNUM
  else if obj = Qnil then
    Result := T_NIL
  else if obj = Qfalse then
    Result := T_FALSE
  else if obj = Qtrue then
    Result := T_TRUE
  else if obj = Qundef then
    Result := T_UNDEF
  else if SYMBOL_P(obj) then
    Result := T_SYMBOL
  else
    Result := PRBasic(obj)^.flags and T_MASK; //BUILTIN_TYPE(obj);
end;

function ap_special_const_p(obj: Tvalue): Integer;
begin
  if SPECIAL_CONST_P(obj) then
    result := Qtrue
  else
    result := Qfalse;
end;

function CLASS_OF(var v): Tvalue;
begin
  result := ap_class_of(Tvalue(v));
end;

function RTYPE(var x): Integer;
begin
  result := ap_type(Tvalue(x));
end;

procedure Check_Type(var v; t: Integer);
begin
  rb_check_type(Tvalue(v), t);
end;

procedure Check_SafeStr(var v);
begin
  rb_check_safe_str(Tvalue(v));
end;

procedure ap_raise(exc: Tvalue; S: string);
begin
  S := deleteCR(S);
  rb_exc_raise(rb_exc_new2(exc, PChar(S)));
end;

procedure ap_loaderror(S: string);
begin
  S := deleteCR(S);
  rb_exc_raise(rb_exc_new2(ap_eLoadError, PChar(S)));
end;

procedure ap_fatal(S: string);
begin
  S := deleteCR(S);
  rb_exc_fatal(rb_exc_new2(ap_eFatal, PChar(S)));
end;

procedure ap_sys_fail(S: string);
begin
  S := deleteCR(S);
  rb_sys_fail(PChar(S));
end;

function ap_bool(B: Boolean): Tvalue;
begin
  if B = False then result := Qfalse else result := Qtrue;
end;

function rb_big2int(var x): Integer;
begin
  result := rb_big2long(Tvalue(x));
end;

function rb_big2uint(var x): Cardinal;
begin
  result := rb_big2ulong(Tvalue(x));
end;

function NUM2CHR(x: Tvalue): Char;
begin
 if (RTYPE(x) = T_STRING) and (ap_str_len(x) > 0) then
   result := ap_str_ptr(x)^
 else
   result := Char(NUM2INT(x) and $ff)
 ;
end;

function CHR2FIX(var x): Tvalue;
begin
  result := INT2FIX(Integer(x) and $ff);
end;

procedure ap_str_cat(var str: Tvalue; S: string);
begin
  rb_str_cat(str, PChar(S), Length(S));
end;

procedure ap_str_cat_int(var str: Tvalue; i: Integer);
begin
  ap_str_cat(str, IntToStr(i));
end;
