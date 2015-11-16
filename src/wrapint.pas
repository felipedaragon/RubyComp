{ $Id: wrapint.pas,v 1.1.1.1 2003/10/31 13:26:26 pka Exp $

  Author: Kazuhiro Yoshida
  Modifications: Pirmin Kalberer <pi@sourcepole.com>
                 Felipe Daragon (FD)
                 
  Changes:
  * 15.11.2015, FD - Added support for Delphi XE2 or higher.
}

function ruby_frame: PRFRAME;
function ruby_scope: PRSCOPE;
function ap_cArray: Tvalue;
function ap_cBignum: Tvalue;
function ap_mComparable: Tvalue;
function ap_cDir: Tvalue;
function ap_mEnumerable: Tvalue;
function ap_eException: Tvalue;
function ap_eSystemExit: Tvalue;
function ap_eInterrupt: Tvalue;
function ap_eSignal: Tvalue;
function ap_eFatal: Tvalue;
function ap_eStandardError: Tvalue;
function ap_eRuntimeError: Tvalue;
function ap_eTypeError: Tvalue;
function ap_eArgError: Tvalue;
function ap_eIndexError: Tvalue;
function ap_eRangeError: Tvalue;
function ap_eSecurityError: Tvalue;
function ap_eNotImpError: Tvalue;
function ap_eNoMemError: Tvalue;
function ap_eScriptError: Tvalue;
function ap_eNameError: Tvalue;
function ap_eSyntaxError: Tvalue;
function ap_eLoadError: Tvalue;
function ap_eSystemCallError: Tvalue;
function ap_mErrno: Tvalue;
function ap_cProc: Tvalue;
function ap_load_path: Tvalue;
function ap_cThread: Tvalue;
function ap_cFile: Tvalue;
function ap_mFileTest: Tvalue;
function ap_mGC: Tvalue;
function ap_cHash: Tvalue;
function ap_cIO: Tvalue;
function ap_eEOFError: Tvalue;
function ap_eIOError: Tvalue;
function ap_stdin: Tvalue;
function ap_stdout: Tvalue;
function ap_stderr: Tvalue;
{$IFNDEF RUBY18}
function ap_defout: Tvalue;
{$ENDIF}
function ap_fs: Tvalue;
function ap_output_fs: Tvalue;
function ap_rs: Tvalue;
function ap_output_rs: Tvalue;
function ap_default_rs: Tvalue;
function ap_mMath: Tvalue;
function ap_cNumeric: Tvalue;
function ap_cFloat: Tvalue;
function ap_cInteger: Tvalue;
function ap_cFixnum: Tvalue;
function ap_eZeroDivError: Tvalue;
function ap_eFloatDomainError: Tvalue;
function ap_mKernel: Tvalue;
function ap_cObject: Tvalue;
function ap_cModule: Tvalue;
function ap_cClass: Tvalue;
function ap_cData: Tvalue;
function ap_cNilClass: Tvalue;
function ap_cTrueClass: Tvalue;
function ap_cFalseClass: Tvalue;
function ap_cSymbol: Tvalue;
function ap_mPrecision: Tvalue;
function ap_mProcess: Tvalue;
function ap_cRange: Tvalue;
function ap_cRegexp: Tvalue;
function ap_progname: Tvalue;
function ap_argv: Tvalue;
function ap_argv0: Tvalue;
function ap_cString: Tvalue;
function ap_cStruct: Tvalue;
function ap_cTime: Tvalue;
function ap_errinfo: Tvalue;
procedure ap_set_errinfo(v: Tvalue);
{$IFNDEF RUBY18}
procedure ap_set_defout(v: Tvalue);
{$ENDIF}
procedure ap_set_stdin(v: Tvalue);
procedure ap_set_stdout(v: Tvalue);
procedure ap_set_stderr(v: Tvalue);
function ap_safe_level: Integer;
function ap_verbose: Tvalue;
function ap_debug: Tvalue;
function ap_nerrs: Integer;
function ap_sourceline: Integer;
function ap_sourcefile: PAnsiChar;
function ap_trap_immediate: rb_atomic_t;
function ap_prohibit_interrupt: Integer;
function ap_trap_pending: rb_atomic_t;
function ap_thread_critical(i: Integer): Integer;
function ap_thread_tick: Integer;
function ap_ignorecase: Integer;
function rb_frame_orig_func: Tid;
function ap_ary_ptr(obj: Tvalue): Pvalue;
function ap_ary_len(ary: Tvalue): Integer;
function ap_ary_aset(ary, index, v: Tvalue): Tvalue; cdecl;
function ap_ary_insert(ary, index, v: Tvalue): Tvalue; cdecl;
procedure ap_ary_move(ary: Tvalue; CurIndex, NewIndex: Integer); cdecl;
function ap_str_ptr(str: Tvalue): PAnsiChar;
function ap_str_len(str: Tvalue): Integer;
function ap_hash_ifnone(hash: Tvalue): Tvalue;
function ap_data_get_struct(obj: Tvalue): Pointer;
function ap_match_size(match: Tvalue): Integer;
function rb_reg_match_m(re, str: Tvalue): Integer;
function ap_match_begin(match: Tvalue; i: Integer): Integer;
function ap_match_end(match: Tvalue; i: Integer): Integer;
