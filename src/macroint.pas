function FIXNUM_P(var x): Boolean;
function INT2FIX(i: Integer): Tvalue;
function INT2NUM(i: Integer): Tvalue;
function UINT2NUM(i: Integer): Tvalue;
function FIX2INT(var x): Integer;
function NUM2INT(var x): Integer;
function NUM2UINT(var x): Cardinal;
function NUM2DBL(var x): Double;
function SYMBOL_P(var x): Boolean;
function ID2SYM(var x): Tvalue;
function SYM2ID(var x): Tid;
function dl_String(var x): PChar;
function RTEST(var v): Boolean;
function NIL_P(var v): Boolean;
function ap_kind_of(v, klass: Tvalue): Boolean;
function ap_class_of(obj: Tvalue): Tvalue;
function ap_type(obj: Tvalue): Integer;
function ap_special_const_p(obj: Tvalue): Integer;
function CLASS_OF(var v): Tvalue;
function RTYPE(var x): Integer;
procedure Check_Type(var v; t: Integer);
procedure Check_SafeStr(var v);
procedure ap_raise(exc: Tvalue; S: string);
procedure ap_loaderror(S: string);
procedure ap_fatal(S: string);
procedure ap_sys_fail(S: string);
function ap_bool(B: Boolean): Tvalue;
function rb_big2int(var x): Integer;
function rb_big2uint(var x): Cardinal;
function NUM2CHR(x: Tvalue): Char;
function CHR2FIX(var x): Tvalue;
procedure ap_str_cat(var str: Tvalue; S: string);
procedure ap_str_cat_int(var str: Tvalue; i: Integer);
