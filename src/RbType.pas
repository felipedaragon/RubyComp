unit RbType;

{$I heverdef.inc}

interface

uses SysUtils, st;

resourcestring
  sWrong_num_of_args = 'wrong # of arguments';
  sWrong_arg_type = 'wrong argument type';
  sToo_few_args = 'too few arguments';
  sToo_many_args = 'too many arguments';
  sOut_of_range = 'out of range';

type
  Tvalue = Cardinal;
  Tid = Cardinal;
  TFunc0 = function: Tvalue;
  TFunc1 = function(argc: integer; argv: Pointer; This: Tvalue): Tvalue; cdecl;
  TAttr0 = function(This: Tvalue): Tvalue; cdecl;
  TAttr1 = function(This, v: Tvalue): Tvalue; cdecl;
  TGetValFunc = function(data: Tvalue): Tvalue; cdecl;
  TRetIntFunc = function: Integer;
  PInteger = ^Integer;
  Pvalue = ^Tvalue;
  Pid = ^Tid;
  TGetStrProc = procedure(S: string);
  TRetStrFunc = function: string;
  TRetChrFunc = function: AnsiChar;
  TAllocFunc = function(var AControl; owner: Tvalue): Tvalue;
  Tvalue_array = array of Tvalue;

  rb_atomic_t = Longint;

  POpenFile = ^TOpenFile;
  TOpenFile = record
    f, f2: Pointer;
    mode, pid, lineno: Integer;
    path: PAnsiChar;
    finalize: procedure; cdecl;
  end;
  
  PREPatternBuffer = ^TREPatternBuffer;
  TREPatternBuffer = record
  end;
  
  PRERegisters = ^TRERegisters;
  TRERegisters = record
    allocated: Integer;
    num_regs: Integer;
    beg_index: PInteger;
    end_index: PInteger;
  end;
  
  PRBasic = ^TRBasic;
  TRBasic = record
    flags: Longword;
    klass: Tvalue;
  end;
  
  TRObject = record
    basic: TRBasic;
    iv_tbl: PSTTable;
  end;
  
  TRClass = record
    basic: TRBasic;
    iv_tbl, m_tbl: PSTTable;
    super: Tvalue;
  end;
  
  TRFloat = record
    basic: TRBasic;
    value: Double;
  end;
  
  PRString = ^TRString;
  TRString = record
    basic: TRBasic;
    len: Longint;
    ptr: PAnsiChar;
    orig: Tvalue;
  end;
  
  PRArray = ^TRArray;
  TRArray = record
    basic: TRBasic;
    len, capa: Longint;
    ptr: Pvalue;
  end;
  
  TRRegexp = record
    basic: TRBasic;
    ptr: PREPatternBuffer;
    len: Longint;
    str: PAnsiChar;
  end;
  
  PRMatch = ^TRMatch;
  TRMatch = record
    basic: TRBasic;
    str: Tvalue;
    regs: PRERegisters;
  end;
  
  PRHash = ^TRHash;
  TRHash = record
    basic: TRBasic;
    tbl: PSTTable;
    iter_lev: Integer;
    ifnone: Tvalue;
  end;
  
  PRFile = ^TRFile;
  TRFile = record
    basic: TRBasic;
    fptr: POpenFile;
  end;
  
  PRData = ^TRData;
  TRData = record
    basic: TRBasic;
    dmark, dfree: procedure;
    data: Pointer;
  end;
  
  TRStruct = record
    basic: TRBasic;
    len: Longint;
    ptr: Pvalue;
  end;
  
  TRBignum = record
    basic: TRBasic;
    sign: AnsiChar;
    len: Longint;
    digits: Pointer;
  end;
  
  Ptrace_var = ^Ttrace_var;
  Ttrace_var = record
    removed: Integer;
    func: Pointer;
    data: Tvalue;
    next: Ptrace_var;
  end;
  
  Pglobal_variable = ^Tglobal_variable;
  Tglobal_variable = record
    counter: Integer;
    data: Pointer;
    getter: Pvalue;
    setter: Pointer;
    marker: Pointer;
    block_trace: Integer;
    trace: Ptrace_var;
  end;
  
  Pglobal_entry = ^Tglobal_entry;
  Tglobal_entry = record
    variable: Pglobal_variable; // var is reserved
    id: Tid;
  end;
  
  TRNodeList = (u1, u2, u3);
  PRNode = ^TRNode;
  TRNode = record
    flags: Longword;
    nd_file: PAnsiChar;
    case TRNodeList of
    u1: (
      u1_node: PRNode;
      u1_id: Tid;
      u1_value: Tvalue;
      cfunc: Pointer; // VALUE (*cfunc)(ANYARGS);
      tbl: Pid;
    );
    u2: (
      u2_node: PRNode;
      u2_id: Tid;
      argc: Longint;
      u2_value: Tvalue;
    );
    u3: (
      u3_node: PRNode;
      id: Tid;
      state: Longint;
      entry: Pglobal_entry;
      cnt: Longint;
      value: Tvalue;
    );
  end;
  
  PRFRAME = ^TRFRAME;
  TRFRAME = record
    self: Tvalue;
    argc: Integer;
    argv: Pvalue;
    last_func: Tid;
{$IFDEF RUBY18}
    orig_func: Tid;
{$ENDIF}
{$IFDEF RUBY18}
    last_class: Tvalue;
{$ELSE}
    cbase: Tvalue;
{$ENDIF}
    prev, tmp: PRFRAME;
{$IFDEF RUBY18}
    node: PRNode;
{$ELSE}
    filename: PAnsiChar;
    line: Integer;
{$ENDIF}
    iter: Integer;
    flags: Integer;
  end;

  PRSCOPE = ^TRSCOPE;
  TRSCOPE = record
    super: TRBasic;
    local_tbl: Pid;
    local_vars: Pvalue;
    flags: Integer;
  end;

  PRVarmap = ^TRVarmap;
  TRVarmap = record
    super: TRBasic;
    id: Tid;
    va: Tvalue;
    next: PRVarmap;
  end;

const
  RubyDLL =
{$IFDEF LINUX}
  'libruby.so'
{$ENDIF}
{$IFDEF MSWINDOWS}
  {$IFDEF RUBY18}
    'msvcrt-ruby18.dll'
  {$ELSE}
    'mswin32-ruby16.dll'
  {$ENDIF}
{$ENDIF}
  ;

const
  Qfalse = 0;
  Qtrue = 2;
  Qnil = 4;
  Qundef = 6;

  T_NONE   = $00;

  T_NIL    = $01;
  T_OBJECT = $02;
  T_CLASS  = $03;
  T_ICLASS = $04;
  T_MODULE = $05;
  T_FLOAT  = $06;
  T_STRING = $07;
  T_REGEXP = $08;
  T_ARRAY  = $09;
  T_FIXNUM = $0a;
  T_HASH   = $0b;
  T_STRUCT = $0c;
  T_BIGNUM = $0d;
  T_FILE   = $0e;

  T_TRUE   = $20;
  T_FALSE  = $21;
  T_DATA   = $22;
  T_MATCH  = $23;
  T_SYMBOL = $24;

  T_UNDEF  = $3c;
  T_VARMAP = $3d;
  T_SCOPE  = $3e;
  T_NODE   = $3f;

  T_MASK   = $3f;

  FIXNUM_FLAG = $01;
  IMMEDIATE_MASK = $03;
  SYMBOL_FLAG = $0e;

  FRAME_ALLOCA = 0;
  FRAME_MALLOC = 1;

  SCOPE_ALLOCA = 0;
  SCOPE_MALLOC = 1;
  SCOPE_NOSTACK = 2;
  SCOPE_DONT_RECYCLE = 4;

var
//  ruby_frame: PRFRAME;
//  ruby_scope: PRSCOPE;
  ruby_in_eval: Integer;
  ruby_class: Tvalue;
  ruby_dyna_vars: PRVarmap;

implementation

end.