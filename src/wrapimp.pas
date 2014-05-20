function GetProcAddr(Symbol: PChar): Pointer;
{$IFDEF LINUX}
var
  Handle: Pointer;
begin
  Result := nil;
  Handle := dlopen(RuntimeRubyDLL, RTLD_LAZY or RTLD_GLOBAL);
  if Handle = nil then Exit;
  Result := dlsym(Handle, Symbol);
  if Result = nil then dlclose(Handle);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
var
  Module: HMODULE;
begin
  //writeln('enter GetProcAddr');
  //writeln('Symbol=', Symbol);
  //writeln('RuntimeRubyDLL=', RuntimeRubyDLL);
//  Result := nil;
  Module := LoadLibraryExA(RuntimeRubyDLL, 0, LOAD_WITH_ALTERED_SEARCH_PATH);
  if Module = 0 then
  begin
    //writeln('LoadLibraryExA GetLastError=', GetLastError);
    //writeln('Symbol=', Symbol);
    //writeln('RuntimeRubyDLL=', RuntimeRubyDLL);
    //writeln('halt');
    Halt;
  end;
  Result := GetProcAddress(Module, Symbol);
  if Result = nil then
  begin
    //writeln('GetProcAddress GetLastError=', GetLastError);
    //writeln('Symbol=', Symbol);
    //writeln('RuntimeRubyDLL=', RuntimeRubyDLL);
    //writeln('halt');
    Halt;
  end;
  //writeln('Result=', LongWord(Result));
  //writeln('leave GetProcAddr');
(*
  Result := nil;
  Module := LoadLibraryExA(RuntimeRubyDLL, 0, LOAD_WITH_ALTERED_SEARCH_PATH);
  if Module = 0 then Exit;
  Result := GetProcAddress(Module, Symbol);
*)
end;
{$ENDIF}

function ruby_frame: PRFRAME;
begin
  Result := PRFRAME(GetProcAddr('ruby_frame')^);
end;

function ruby_scope: PRSCOPE;
begin
  Result := PRSCOPE(GetProcAddr('ruby_scope')^);
end;

function GetVar(Symbol: PChar): Tvalue;
begin
  Result := Tvalue(GetProcAddr(Symbol)^);
end;

procedure SetVar(Symbol: PChar; v: Tvalue);
begin
  Tvalue(GetProcAddr(Symbol)^) := v;
end;

function ap_cArray: Tvalue;
begin
  Result := GetVar('rb_cArray');
end;

function ap_cBignum: Tvalue;
begin
  Result := GetVar('rb_cBignum');
end;

function ap_mComparable: Tvalue;
begin
  Result := GetVar('rb_mComparable');
end;

function ap_cDir: Tvalue;
begin
  Result := GetVar('rb_cDir');
end;

function ap_mEnumerable: Tvalue;
begin
  Result := GetVar('rb_mEnumerable');
end;

function ap_eException: Tvalue;
begin
  Result := GetVar('rb_eException');
end;

function ap_eSystemExit: Tvalue;
begin
  Result := GetVar('rb_eSystemExit');
end;

function ap_eInterrupt: Tvalue;
begin
  Result := GetVar('rb_eInterrupt');
end;

function ap_eSignal: Tvalue;
begin
  Result := GetVar('rb_eSignal');
end;

function ap_eFatal: Tvalue;
begin
  Result := GetVar('rb_eFatal');
end;

function ap_eStandardError: Tvalue;
begin
  Result := GetVar('rb_eStandardError');
end;

function ap_eRuntimeError: Tvalue;
begin
  Result := GetVar('rb_eRuntimeError');
end;

function ap_eTypeError: Tvalue;
begin
  Result := GetVar('rb_eTypeError');
end;

function ap_eArgError: Tvalue;
begin
  Result := GetVar('rb_eArgError');
end;

function ap_eIndexError: Tvalue;
begin
  Result := GetVar('rb_eIndexError');
end;

function ap_eRangeError: Tvalue;
begin
  Result := GetVar('rb_eRangeError');
end;

function ap_eSecurityError: Tvalue;
begin
  Result := GetVar('rb_eSecurityError');
end;

function ap_eNotImpError: Tvalue;
begin
  Result := GetVar('rb_eNotImpError');
end;

function ap_eNoMemError: Tvalue;
begin
  Result := GetVar('rb_eNoMemError');
end;

function ap_eScriptError: Tvalue;
begin
  Result := GetVar('rb_eScriptError');
end;

function ap_eNameError: Tvalue;
begin
  Result := GetVar('rb_eNameError');
end;

function ap_eSyntaxError: Tvalue;
begin
  Result := GetVar('rb_eSyntaxError');
end;

function ap_eLoadError: Tvalue;
begin
  Result := GetVar('rb_eLoadError');
end;

function ap_eSystemCallError: Tvalue;
begin
  Result := GetVar('rb_eSystemCallError');
end;

function ap_mErrno: Tvalue;
begin
  Result := GetVar('rb_mErrno');
end;

function ap_cProc: Tvalue;
begin
  Result := GetVar('rb_cProc');
end;

function ap_load_path: Tvalue;
begin
  Result := GetVar('rb_load_path');
end;

function ap_cThread: Tvalue;
begin
  Result := GetVar('rb_cThread');
end;

function ap_cFile: Tvalue;
begin
  Result := GetVar('rb_cFile');
end;

function ap_mFileTest: Tvalue;
begin
  Result := GetVar('rb_mFileTest');
end;

function ap_mGC: Tvalue;
begin
  Result := GetVar('rb_mGC');
end;

function ap_cHash: Tvalue;
begin
  Result := GetVar('rb_cHash');
end;

function ap_cIO: Tvalue;
begin
  Result := GetVar('rb_cIO');
end;

function ap_eEOFError: Tvalue;
begin
  Result := GetVar('rb_eEOFError');
end;

function ap_eIOError: Tvalue;
begin
  Result := GetVar('rb_eIOError');
end;

function ap_stdin: Tvalue;
begin
  Result := GetVar('rb_stdin');
end;

function ap_stdout: Tvalue;
begin
  Result := GetVar('rb_stdout');
end;

function ap_stderr: Tvalue;
begin
  Result := GetVar('rb_stderr');
end;

{$IFNDEF RUBY18}
function ap_defout: Tvalue;
begin
  Result := GetVar('rb_defout');
end;
{$ENDIF}

function ap_fs: Tvalue;
begin
  Result := GetVar('rb_fs');
end;

function ap_output_fs: Tvalue;
begin
  Result := GetVar('rb_output_fs');
end;

function ap_rs: Tvalue;
begin
  Result := GetVar('rb_rs');
end;

function ap_output_rs: Tvalue;
begin
  Result := GetVar('rb_output_rs');
end;

function ap_default_rs: Tvalue;
begin
  Result := GetVar('rb_default_rs');
end;

function ap_mMath: Tvalue;
begin
  Result := GetVar('rb_mMath');
end;

function ap_cNumeric: Tvalue;
begin
  Result := GetVar('rb_cNumeric');
end;

function ap_cFloat: Tvalue;
begin
  Result := GetVar('rb_cFloat');
end;

function ap_cInteger: Tvalue;
begin
  Result := GetVar('rb_cInteger');
end;

function ap_cFixnum: Tvalue;
begin
  Result := GetVar('rb_cFixnum');
end;

function ap_eZeroDivError: Tvalue;
begin
  Result := GetVar('rb_eZeroDivError');
end;

function ap_eFloatDomainError: Tvalue;
begin
  Result := GetVar('rb_eFloatDomainError');
end;

function ap_mKernel: Tvalue;
begin
  Result := GetVar('rb_mKernel');
end;

function ap_cObject: Tvalue;
begin
  Result := GetVar('rb_cObject');
//  Result := rb_cObject;
end;

function ap_cModule: Tvalue;
begin
  Result := GetVar('rb_cModule');
end;

function ap_cClass: Tvalue;
begin
  Result := GetVar('rb_cClass');
end;

function ap_cData: Tvalue;
begin
  Result := GetVar('rb_cData');
end;

function ap_cNilClass: Tvalue;
begin
  Result := GetVar('rb_cNilClass');
end;

function ap_cTrueClass: Tvalue;
begin
  Result := GetVar('rb_cTrueClass');
end;

function ap_cFalseClass: Tvalue;
begin
  Result := GetVar('rb_cFalseClass');
end;

function ap_cSymbol: Tvalue;
begin
  Result := GetVar('rb_cSymbol');
end;

function ap_mPrecision: Tvalue;
begin
  Result := GetVar('rb_mPrecision');
end;

function ap_mProcess: Tvalue;
begin
  Result := GetVar('rb_mProcess');
end;

function ap_cRange: Tvalue;
begin
  Result := GetVar('rb_cRange');
end;

function ap_cRegexp: Tvalue;
begin
  Result := GetVar('rb_cRegexp');
end;

function ap_progname: Tvalue;
begin
  Result := GetVar('rb_progname');
end;

function ap_argv: Tvalue;
begin
  Result := GetVar('rb_argv');
end;

function ap_argv0: Tvalue;
begin
  Result := GetVar(@rb_argv0);
end;

function ap_cString: Tvalue;
begin
  Result := GetVar('rb_cString');
end;

function ap_cStruct: Tvalue;
begin
  Result := GetVar('rb_cStruct');
end;

function ap_cTime: Tvalue;
begin
  Result := GetVar('rb_cTime');
end;

function ap_errinfo: Tvalue;
begin
  Result := GetVar('ruby_errinfo');
end;

procedure ap_set_errinfo(v: Tvalue);
begin
  SetVar('ruby_errinfo', v);
end;

{$IFNDEF RUBY18}
procedure ap_set_defout(v: Tvalue);
begin
  SetVar('rb_defout', v);
end;
{$ENDIF}

procedure ap_set_stdin(v: Tvalue);
begin
  SetVar('rb_stdin', v);
end;

procedure ap_set_stdout(v: Tvalue);
begin
  SetVar('rb_stdout', v);
end;

procedure ap_set_stderr(v: Tvalue);
begin
  SetVar('rb_stderr', v);
end;

function ap_safe_level: Integer;
begin
  Result := GetVar('ruby_safe_level');
end;

function ap_verbose: Tvalue;
begin
  Result := GetVar('ruby_verbose');
end;

function ap_debug: Tvalue;
begin
  Result := GetVar('ruby_debug');
end;

function ap_nerrs: Integer;
begin
  Result := GetVar('ruby_nerrs');
end;

function ap_sourceline: Integer;
begin
  Result := GetVar('ruby_sourceline');
end;

function ap_sourcefile: PChar;
begin
  Result := PChar(GetVar('ruby_sourcefile'));
end;

function ap_trap_immediate: rb_atomic_t;
begin
  Result := GetVar('rb_trap_immediate');
end;

function ap_prohibit_interrupt: Integer;
begin
  Result := GetVar('rb_prohibit_interrupt');
end;

function ap_trap_pending: rb_atomic_t;
begin
  Result := GetVar('rb_trap_pending');
end;

function ap_thread_critical(i: Integer): Integer;
begin
  Result := GetVar('rb_thread_critical');
end;

function ap_thread_tick: Integer;
begin
  Result := GetVar('rb_thread_tick');
end;

function ap_ignorecase: Integer;
begin
  Result := GetVar('ruby_ignorecase');
end;

function rb_frame_orig_func: Tid;
begin
{$IFDEF RUBY18}
  Result := ruby_frame^.orig_func;
{$ELSE}
  Result := ruby_frame^.last_func;
{$ENDIF}
end;

function ap_ary_ptr(obj: Tvalue): Pvalue;
begin
  Result := PRArray(obj)^.ptr;
end;

function ap_ary_len(ary: Tvalue): Integer;
begin
  Result := PRArray(ary)^.len;
end;

function ap_ary_aset(ary, index, v: Tvalue): Tvalue; cdecl;
var
  n, len: Integer;
  ptr: Pvalue;
begin
  len := ap_ary_len(ary);
  n := FIX2INT(index);
  if (n < 0) or (len <= n) then
    ap_raise(ap_eIndexError, sOut_of_range);
  ptr := ap_ary_ptr(ary);
  Inc(ptr, n);
  ptr^:= v;
  result := v;
end;

function ap_ary_insert(ary, index, v: Tvalue): Tvalue; cdecl;
var
  i, n, len: Integer;
  tmp: Tvalue;
begin
  tmp := rb_ary_new;
  len := ap_ary_len(ary);
  n := FIX2INT(index);
  if (n < 0) or (len < n) then
    ap_raise(ap_eIndexError, sOut_of_range);
  for i := n+1 to len do rb_ary_push(tmp, rb_ary_pop(ary));
  rb_ary_push(ary, v);
  for i := n+1 to len do rb_ary_push(ary, rb_ary_pop(tmp));
  result := ary;
end;

procedure ap_ary_move(ary: Tvalue; CurIndex, NewIndex: Integer); cdecl;
const
  MaxListSize = Maxint div 16;
type
  PvalueList = ^TvalueList;
  TvalueList = array[0..MaxListSize - 1] of Tvalue;
var
  Count: Integer;
  List: PvalueList;
  Item: Tvalue;
begin
  if CurIndex <> NewIndex then
  begin
    Count := ap_ary_len(ary);
    if (NewIndex < 0) or (NewIndex >= Count) then
      ap_raise(ap_eArgError, sOut_of_range);
    List := PvalueList(ap_ary_ptr(ary));
    Item := List^[CurIndex];
    if CurIndex <= Count then
      System.Move(List^[CurIndex + 1], List^[CurIndex],
        (Count-1 - CurIndex) * SizeOf(Tvalue));
    if NewIndex <= Count then
      System.Move(List^[NewIndex], List^[NewIndex + 1],
        (Count-1 - NewIndex) * SizeOf(Tvalue));
    List^[NewIndex] := Item;
  end;
end;

function ap_str_ptr(str: Tvalue): PChar;
begin
  Result := PRString(str)^.ptr;
end;

function ap_str_len(str: Tvalue): Integer;
begin
  Result := PRString(str)^.len;
end;

function ap_hash_ifnone(hash: Tvalue): Tvalue;
begin
  Result := PRHash(hash)^.ifnone;
end;

function ap_data_get_struct(obj: Tvalue): Pointer;
begin
  if obj = Qnil then
    Result := nil
  else begin
    Check_Type(obj, T_DATA);
    Result := PRData(obj)^.data;
  end;
end;

function ap_match_size(match: Tvalue): Integer;
begin
  result := PRMatch(match)^.regs^.num_regs;
end;

function rb_reg_match_m(re, str: Tvalue): Integer;
begin
  result := rb_reg_match(re, str);
  if result <> Qnil then
  begin
    result := rb_backref_get;
    rb_match_busy(result);
  end
end;

function ap_match_begin(match: Tvalue; i: Integer): Integer;
var
  p: PInteger;
begin
  if (i < 0) or (PRMatch(match)^.regs^.num_regs <= i) then
    ap_raise(ap_eIndexError, Format('index %d out of matches', [i]));
  p := PRMatch(match)^.regs^.beg_index;
  inc(p, i);
  result := p^;
end;

function ap_match_end(match: Tvalue; i: Integer): Integer;
var
  p: PInteger;
begin
  if (i < 0) or (PRMatch(match)^.regs^.num_regs <= i) then
    ap_raise(ap_eIndexError, Format('index %d out of matches', [i]));
  p := PRMatch(match)^.regs^.end_index;
  inc(p, i);
  result := p^;
end;

