unit gvarint;

interface

uses rbType;

procedure rb_cArray; cdecl; external RubyDLL;
procedure rb_cBignum; cdecl; external RubyDLL;
procedure rb_mComparable; cdecl; external RubyDLL;
procedure rb_cDir; cdecl; external RubyDLL;
procedure rb_mEnumerable; cdecl; external RubyDLL;
procedure rb_eException; cdecl; external RubyDLL;
procedure rb_eSystemExit; cdecl; external RubyDLL;
procedure rb_eInterrupt; cdecl; external RubyDLL;
procedure rb_eSignal; cdecl; external RubyDLL;
procedure rb_eFatal; cdecl; external RubyDLL;
procedure rb_eStandardError; cdecl; external RubyDLL;
procedure rb_eRuntimeError; cdecl; external RubyDLL;
procedure rb_eTypeError; cdecl; external RubyDLL;
procedure rb_eArgError; cdecl; external RubyDLL;
procedure rb_eIndexError; cdecl; external RubyDLL;
procedure rb_eRangeError; cdecl; external RubyDLL;
procedure rb_eSecurityError; cdecl; external RubyDLL;
procedure rb_eNotImpError; cdecl; external RubyDLL;
procedure rb_eNoMemError; cdecl; external RubyDLL;
procedure rb_eScriptError; cdecl; external RubyDLL;
procedure rb_eNameError; cdecl; external RubyDLL;
procedure rb_eSyntaxError; cdecl; external RubyDLL;
procedure rb_eLoadError; cdecl; external RubyDLL;
procedure rb_eSystemCallError; cdecl; external RubyDLL;
procedure rb_mErrno; cdecl; external RubyDLL;
procedure rb_cProc; cdecl; external RubyDLL;
procedure rb_load_path; cdecl; external RubyDLL;
procedure rb_cThread; cdecl; external RubyDLL;
procedure rb_cFile; cdecl; external RubyDLL;
procedure rb_mFileTest; cdecl; external RubyDLL;
procedure rb_mGC; cdecl; external RubyDLL;
procedure rb_cHash; cdecl; external RubyDLL;
procedure rb_cIO; cdecl; external RubyDLL;
procedure rb_eEOFError; cdecl; external RubyDLL;
procedure rb_eIOError; cdecl; external RubyDLL;
procedure rb_stdin; cdecl; external RubyDLL;
procedure rb_stdout; cdecl; external RubyDLL;
procedure rb_stderr; cdecl; external RubyDLL;
{$IFNDEF RUBY18}
procedure rb_defout; cdecl; external RubyDLL;
{$ENDIF}
procedure rb_fs; cdecl; external RubyDLL;
procedure rb_output_fs; cdecl; external RubyDLL;
procedure rb_rs; cdecl; external RubyDLL;
procedure rb_output_rs; cdecl; external RubyDLL;
procedure rb_default_rs; cdecl; external RubyDLL;
procedure rb_mMath; cdecl; external RubyDLL;
procedure rb_cNumeric; cdecl; external RubyDLL;
procedure rb_cFloat; cdecl; external RubyDLL;
procedure rb_cInteger; cdecl; external RubyDLL;
procedure rb_cFixnum; cdecl; external RubyDLL;
procedure rb_eZeroDivError; cdecl; external RubyDLL;
procedure rb_eFloatDomainError; cdecl; external RubyDLL;
procedure rb_mKernel; cdecl; external RubyDLL;
procedure rb_cObject; cdecl; external RubyDLL;
//function rb_cObject: Tvalue; cdecl; external RubyDLL;
procedure rb_cModule; cdecl; external RubyDLL;
procedure rb_cClass; cdecl; external RubyDLL;
procedure rb_cData; cdecl; external RubyDLL;
procedure rb_cNilClass; cdecl; external RubyDLL;
procedure rb_cTrueClass; cdecl; external RubyDLL;
procedure rb_cFalseClass; cdecl; external RubyDLL;
procedure rb_cSymbol; cdecl; external RubyDLL;
procedure rb_mPrecision; cdecl; external RubyDLL;
procedure rb_mProcess; cdecl; external RubyDLL;
procedure rb_cRange; cdecl; external RubyDLL;
procedure rb_cRegexp; cdecl; external RubyDLL;
procedure rb_progname; cdecl; external RubyDLL;
procedure rb_argv; cdecl; external RubyDLL;
procedure rb_argv0; cdecl; external RubyDLL;
procedure rb_cString; cdecl; external RubyDLL;
procedure rb_cStruct; cdecl; external RubyDLL;
procedure rb_cTime; cdecl; external RubyDLL;
procedure ruby_errinfo; cdecl; external RubyDLL;
procedure ruby_safe_level; cdecl; external RubyDLL;
procedure ruby_verbose; cdecl; external RubyDLL;
procedure ruby_debug; cdecl; external RubyDLL;
//function rb_class_of(obj: Tvalue): Integer; cdecl; external RubyDLL;
//function rb_type(obj: Tvalue): Integer; cdecl; external RubyDLL;
function rb_special_const_p(obj: Tvalue):Integer; cdecl; external RubyDLL;
procedure ruby_nerrs; cdecl; external RubyDLL;
procedure ruby_sourceline; cdecl; external RubyDLL;
procedure ruby_sourcefile; cdecl; external RubyDLL;
procedure rb_immediate; cdecl; external RubyDLL;
procedure rb_prohibit_interrupt; cdecl; external RubyDLL;
procedure rb_pending; cdecl; external RubyDLL;
procedure rb_thread_critical; cdecl; external RubyDLL;
procedure rb_thread_tick; cdecl; external RubyDLL;
procedure ruby_ignorecase; cdecl; external RubyDLL;
procedure rb_trap_immediate; cdecl; external RubyDLL;
procedure rb_trap_pending; cdecl; external RubyDLL;

implementation

end.
