{ $Id: RubyWrapper.pas,v 1.1.1.1 2003/10/31 13:26:23 pka Exp $

  Author: Kazuhiro Yoshida
  Modifications: Pirmin Kalberer <pi@sourcepole.com>
                 Felipe Daragon (FD)

  Changes:
  * 15.11.2015, FD - Added support for Delphi XE2 or higher.
  * 15.11.2015, FD - Replaced ASM code for 64-bit compilation.
}

unit RubyWrapper;

{$I heverdef.inc}

interface

uses
{$IFDEF LINUX}
  Libc,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils, st, RbType;

{$IFDEF MSWINDOWS}
const
  NL = #13#10;
{$ENDIF}

{$IFDEF LINUX}
const
  NL = #10;
{$ENDIF}

{ array.c }
procedure rb_mem_clear(mem: Pvalue; size: Integer); cdecl;
function rb_assoc_new(car, cdr: Tvalue): Tvalue; cdecl;
function rb_ary_new: Tvalue; cdecl;
function rb_ary_new2(len: Integer): Tvalue; cdecl;
//function rb_ary_new3(long,...): Tvalue;
function rb_ary_new4(n: Integer; elts: Pvalue): Tvalue; cdecl;
function rb_ary_freeze(ary: Tvalue): Tvalue; cdecl;
function rb_ary_aref(argc: Integer; argv: Pvalue; ary: Tvalue): Tvalue; cdecl;
procedure rb_ary_store(ary: Tvalue; idx: Integer; val: Tvalue); cdecl;
function rb_ary_to_s(ary: Tvalue): Tvalue; cdecl;
function rb_ary_push(ary, item: Tvalue): Tvalue; cdecl;
function rb_ary_pop(ary: Tvalue): Tvalue; cdecl;
function rb_ary_shift(ary: Tvalue): Tvalue; cdecl;
function rb_ary_unshift(ary, item: Tvalue): Tvalue; cdecl;
function rb_ary_entry(ary: Tvalue; offset: Integer): Tvalue; cdecl;
function rb_ary_each(ary: Tvalue): Tvalue; cdecl;
function rb_ary_join(ary, sep: Tvalue): Tvalue; cdecl;
//function rb_ary_print_on(ary, f: Tvalue): Tvalue;
function rb_ary_reverse(ary: Tvalue): Tvalue; cdecl;
function rb_ary_sort(ary: Tvalue): Tvalue; cdecl;
function rb_ary_sort_bang(ary: Tvalue): Tvalue; cdecl;
function rb_ary_delete(ary, item: Tvalue): Tvalue; cdecl;
function rb_ary_delete_at(ary: Tvalue; at: LongInt): Tvalue; cdecl;
function rb_ary_clear(ary: Tvalue): Tvalue; cdecl;
function rb_ary_plus(x, y: Tvalue): Tvalue; cdecl;
function rb_ary_concat(x, y: Tvalue): Tvalue; cdecl;
function rb_ary_assoc(ary, key: Tvalue): Tvalue; cdecl;
function rb_ary_rassoc(ary, value: Tvalue): Tvalue; cdecl;
function rb_ary_includes(ary, item: Tvalue): Tvalue; cdecl;
function rb_protect_inspect(func: Pointer; obj, arg: Tvalue): Tvalue; cdecl;
function rb_inspecting_p(obj: Tvalue): Tvalue; cdecl;

{ bignum.c }
function rb_big_clone(x: Tvalue): Tvalue; cdecl;
procedure rb_big_2comp(x: Tvalue); cdecl;
function rb_big_norm(x: Tvalue): Tvalue; cdecl;
function rb_uint2big(n: Cardinal): Tvalue; cdecl;
function rb_int2big(n: Integer): Tvalue; cdecl;
function rb_uint2inum(n: Cardinal): Tvalue; cdecl;
function rb_int2inum(n: Integer): Tvalue; cdecl;
function rb_str2inum(const ptr: PAnsiChar; len: Integer): Tvalue; cdecl;
function rb_big2str(x: Tvalue; len: Integer): Tvalue; cdecl;
function rb_big2long(x: Tvalue): Integer; cdecl;
function rb_big2ulong(x: Tvalue): Cardinal; cdecl;
function rb_dbl2big(n: Double): Tvalue; cdecl;
function rb_big2dbl(x: Tvalue): Double; cdecl;
function rb_big_plus(x, y: Tvalue): Tvalue; cdecl;
function rb_big_minus(x, y: Tvalue): Tvalue; cdecl;
function rb_big_mul(x, y: Tvalue): Tvalue; cdecl;
function rb_big_pow(x, y: Tvalue): Tvalue; cdecl;
function rb_big_and(x, y: Tvalue): Tvalue; cdecl;
function rb_big_or(x, y: Tvalue): Tvalue; cdecl;
function rb_big_xor(x, y: Tvalue): Tvalue; cdecl;
function rb_big_lshift(x, y: Tvalue): Tvalue; cdecl;
function rb_big_rand(x: Tvalue; rand: Double): Tvalue; cdecl;

{ class.c }
function rb_class_new(super: Tvalue): Tvalue; cdecl;
function rb_singleton_class_new(super: Tvalue): Tvalue; cdecl;
function rb_singleton_class_clone(klass: Tvalue): Tvalue; cdecl;
procedure rb_singleton_class_attached(klass, obj: Tvalue); cdecl;
function rb_define_class_id(id: Tid; super: Tvalue): Tvalue; cdecl;
function rb_module_new: Tvalue; cdecl;
function rb_define_module_id(id: Tid): Tvalue; cdecl;
function rb_mod_included_modules(module: Tvalue): Tvalue; cdecl;
function rb_mod_ancestors(module: Tvalue): Tvalue; cdecl;
function rb_class_instance_methods(argc: Integer; argv: Pvalue; module: Tvalue): Tvalue; cdecl;
function rb_class_protected_instance_methods(argc: Integer; argv: Pvalue; module: Tvalue): Tvalue; cdecl;
function rb_class_private_instance_methods(argc: Integer; argv: Pvalue; module: Tvalue): Tvalue; cdecl;
function rb_obj_singleton_methods(obj: Tvalue): Tvalue; cdecl;
procedure rb_define_method_id(klass: Tvalue; name: Tid; func: TFunc0; argc: Integer); cdecl;
procedure rb_define_protected_method(klass: Tvalue; const name: PAnsiChar; func: TFunc0; argc: Integer); cdecl;
procedure rb_define_private_method(klass: Tvalue; const name: PAnsiChar; func: TFunc0; argc: Integer); cdecl;
procedure rb_define_singleton_method(obj: Tvalue; const name: PAnsiChar; func: TFunc0; argc: Integer); cdecl;
function rb_singleton_class(obj: Tvalue): Tvalue; cdecl;

{ error.c }
function rb_exc_new(etype: Tvalue; const ptr: PAnsiChar; len: Integer): Tvalue; cdecl;
function rb_exc_new2(etype: Tvalue; const s: PAnsiChar): Tvalue; cdecl;
function rb_exc_new3(etype, str: Tvalue): Tvalue; cdecl;

{ eval.c }
procedure rb_exc_raise(mesg: Tvalue); cdecl;
procedure rb_exc_fatal(mesg: Tvalue); cdecl;
procedure rb_remove_method(klass: Tvalue; const name: PAnsiChar); cdecl;
procedure rb_disable_super(klass: Tvalue; const name: PAnsiChar); cdecl;
procedure rb_enable_super(klass: Tvalue; const name: PAnsiChar); cdecl;
procedure rb_clear_cache; cdecl;
procedure rb_alias(klass: Tvalue; name, def: Tid); cdecl;
procedure rb_attr(klass: Tvalue; id: Tid; read, write, ex: Integer); cdecl;
function rb_method_boundp(klass: Tvalue; id: Tid; ex: Integer): Integer; cdecl;
function rb_dvar_defined(id: Tid): Tvalue; cdecl;
function rb_dvar_ref(i: Tid): Tvalue; cdecl;
procedure rb_dvar_asgn(id: Tid; v: Tvalue); cdecl;
procedure rb_dvar_push(id: Tid; v: Tvalue); cdecl;
function rb_eval_cmd(cmd, arg: Tvalue): Tvalue; cdecl;
function rb_respond_to(obj: Tvalue; id: Tid): Integer; cdecl;
procedure rb_interrupt; cdecl;
function rb_apply(recv: Tvalue; mid: Tid; args: Tvalue): Tvalue; cdecl;
procedure rb_backtrace; cdecl;
function rb_frame_last_func: Tid; cdecl;
function rb_obj_instance_eval(argc: Integer; argv: Pvalue; This: Tvalue): Tvalue; cdecl;
procedure rb_set_end_proc(func: TFunc0; data: Tvalue); cdecl;
procedure rb_exec_end_proc; cdecl;
procedure rb_mark_end_proc; cdecl;
procedure rb_gc_mark_threads; cdecl;
procedure rb_thread_start_timer; cdecl;
procedure rb_thread_stop_timer; cdecl;
procedure rb_thread_schedule; cdecl;
procedure rb_thread_wait_fd(fd: Integer); cdecl;
function rb_thread_fd_writable(fd: Integer): Integer; cdecl;
procedure rb_thread_fd_close(fd: Integer); cdecl;
function rb_thread_alone: Integer; cdecl;
procedure rb_thread_sleep(time: Integer); cdecl;
procedure rb_thread_sleep_forever; cdecl;
function rb_thread_stop: Tvalue; cdecl;
function rb_thread_wakeup(thread: Tvalue): Tvalue; cdecl;
function rb_thread_run(thread: Tvalue): Tvalue; cdecl;
function rb_thread_create(fn: TFunc0; arg: Pointer): Tvalue; cdecl;
function rb_thread_scope_shared_p: Integer; cdecl;
procedure rb_thread_interrupt; cdecl;
procedure rb_thread_trap_eval(cmd: Tvalue; sig: Integer); cdecl;
procedure rb_thread_signal_raise(sig: PAnsiChar); cdecl;
function rb_thread_select: Integer; cdecl;
procedure rb_thread_wait_for; cdecl;
function rb_thread_current: Tvalue; cdecl;
function rb_thread_main: Tvalue; cdecl;
function rb_thread_local_aref(thread: Tvalue; id: Tid): Tvalue; cdecl;
function rb_thread_local_aset(thread: Tvalue; id: Tid; val: Tvalue): Tvalue; cdecl;

{ file.c }
function eaccess(const path: PAnsiChar; mode: Integer): Integer; cdecl;
function rb_file_s_expand_path(argc: Integer; argv: Pvalue): Tvalue; cdecl;
procedure rb_file_const(const fname: PAnsiChar; v: Tvalue); cdecl;
function rb_find_file(fname :PAnsiChar): PAnsiChar; cdecl;

{ gc.c }
procedure rb_global_variable(val: Pvalue); cdecl;
procedure rb_gc_mark_locations(start, fin: Pvalue); cdecl;
//procedure rb_mark_tbl(Ptable);
//procedure rb_mark_hash(Ptable);
procedure rb_gc_mark_maybe(obj: Pointer); cdecl;
procedure rb_gc_mark(obj: Pointer); cdecl;
procedure rb_gc_force_recycle(p: Tvalue); cdecl;
procedure rb_gc; cdecl;
procedure rb_gc_call_finalizer_at_exit; cdecl;

{ hash.c }
function rb_hash(hash :Tvalue): Tvalue; cdecl;
function rb_hash_new: Tvalue; cdecl;
function rb_hash_freeze(hash :Tvalue): Tvalue; cdecl;
function rb_hash_aref(hash, key : Tvalue): Tvalue; cdecl;
function rb_hash_aset(hash, key, val: Tvalue): Tvalue; cdecl;
function rb_path_check(path: PAnsiChar): Integer; cdecl;
function rb_env_path_tainted: Integer; cdecl;

{ intern.h }
procedure rb_load(fname: Tvalue; wrap: Integer); cdecl;
procedure rb_load_protect(fname: Tvalue; wrap: Integer; var state: Integer); cdecl;
procedure rb_jump_tag(tag: Integer); cdecl;
procedure rb_provide(const feature: PAnsiChar); cdecl;
function rb_f_require(obj, fname: Tvalue): Tvalue; cdecl;
procedure rb_obj_call_init(obj: Tvalue; argc: Integer; argv: Pvalue); cdecl;
function rb_class_new_instance(argc: Integer; argv: Pvalue; klass: Tvalue): Tvalue; cdecl;
function rb_f_lambda: Tvalue; cdecl;
function rb_protect(proc: TGetValFunc; data: Tvalue; var state: Integer): Tvalue; cdecl;

function rb_id_attrset(id: Tid): Tid; cdecl;

{ io.c }
function rb_io_write(io, str: Tvalue): Tvalue; cdecl;
function rb_io_gets(io: Tvalue): Tvalue; cdecl;
function rb_io_getc(io: Tvalue): Tvalue; cdecl;
function rb_io_ungetc(io, c: Tvalue): Tvalue; cdecl;
function rb_io_close(io: Tvalue): Tvalue; cdecl;
function rb_io_eof(io: Tvalue): Tvalue; cdecl;
function rb_io_binmode(io: Tvalue): Tvalue; cdecl;
function rb_file_open(const fname, mode: Tvalue): Tvalue; cdecl;
function rb_gets: Tvalue; cdecl;
procedure rb_str_setter(val: Tvalue; id: Tid; ptr: Pvalue); cdecl;
function rb_io_mode_flags(mode: PAnsiChar): Integer; cdecl;

{ numeric.c }
procedure rb_num_zerodiv; cdecl;
function rb_num_coerce_bin(x, y: Tvalue): Tvalue; cdecl;
function rb_float_new(d: Double): Tvalue; cdecl;
function rb_num2fix(val: Tvalue): Tvalue; cdecl;
function rb_fix2str(x: Tvalue; base: Integer): Tvalue; cdecl;
function rb_fix_upto(from, too: Tvalue): Tvalue; cdecl;

{ object.c }
function rb_inspect(obj: Tvalue): Tvalue; cdecl;
function rb_obj_is_instance_of(obj, c: Tvalue): Tvalue; cdecl;
function rb_obj_is_kind_of(obj, c: Tvalue): Tvalue; cdecl;

{ parse.c }
function yyparse: Integer; cdecl;
procedure rb_parser_append_print; cdecl;
procedure rb_parser_while_loop(chop, split: Integer); cdecl;
function rb_is_const_id(id: Tid): Integer; cdecl;
function rb_is_instance_id(id: Tid): Integer; cdecl;
function rb_backref_get: Tvalue; cdecl;
procedure rb_backref_set(val: Tvalue); cdecl;
function rb_lastline_get: Tvalue; cdecl;
procedure rb_lastline_set(val: Tvalue); cdecl;

{ process.c }
function rb_proc_exec(const str: PAnsiChar): Integer; cdecl;
procedure rb_syswait(pid: Integer); cdecl;

{ range.c }
function rb_range_new(beg, fin: Tvalue; exclude_end: Integer): Tvalue; cdecl;
function rb_range_beg_len(range: Tvalue; begp, lenp: Pointer; len, err: Integer): Tvalue; cdecl;

{ re.c }
function rb_mbclen2(c: Cardinal; re: Tvalue): Integer; cdecl;
function rb_str_cicmp(str1, str2: Tvalue): Integer; cdecl;
function rb_reg_search(reg, str: Tvalue; pos, reverse: Integer): Integer; cdecl;
function rb_reg_nth_defined(nth: Integer; match: Tvalue): Tvalue; cdecl;
function rb_reg_nth_match(nth: Integer; match: Tvalue): Tvalue; cdecl;
function rb_reg_last_match(match: Tvalue): Tvalue; cdecl;
function rb_reg_match_pre(match: Tvalue): Tvalue; cdecl;
function rb_reg_match_post(match: Tvalue): Tvalue; cdecl;
function rb_reg_match_last(match: Tvalue): Tvalue; cdecl;
function rb_reg_new(const s: PAnsiChar; len, options: Integer): Tvalue; cdecl;
function rb_reg_regcomp(str : Tvalue): Tvalue; cdecl;
function rb_reg_match(re, str: Tvalue): Tvalue; cdecl;
function rb_reg_match2(re: Tvalue): Tvalue; cdecl;
function rb_kcode: Integer; cdecl;
function rb_reg_options(re: Tvalue): Integer; cdecl;
function rb_reg_regsub(str, src: Tvalue; regs: PRERegisters): Tvalue; cdecl;
function rb_get_kcode: PAnsiChar; cdecl;
procedure rb_set_kcode(const code: PAnsiChar); cdecl;
procedure rb_match_busy(match: Tvalue); cdecl;

{ ruby.c }
procedure rb_check_type(x: Tvalue; t: Integer); cdecl;
procedure rb_check_safe_str(x: Tvalue); cdecl;
procedure rb_secure(level: Integer); cdecl;
function rb_num2long(val: Tvalue): Integer; cdecl;
function rb_num2ulong(val: Tvalue): Cardinal; cdecl;
function rb_num2dbl(n: Tvalue): Double; cdecl;
function rb_str2cstr(x: Tvalue; var len: Integer): PAnsiChar; cdecl;

function rb_newobj: Tvalue; cdecl;

function rb_data_object_alloc(klass: Tvalue; datap, dmark, dfree: Pointer): Tvalue; cdecl;

function rb_define_class(const name: PAnsiChar; super: Tvalue): Tvalue; cdecl;
function rb_define_module(const name: PAnsiChar): Tvalue; cdecl;
function rb_define_class_under(module: Tvalue; const name: PAnsiChar; super: Tvalue): Tvalue; cdecl;
function rb_define_module_under(module: Tvalue; const name: PAnsiChar): Tvalue; cdecl;

procedure rb_include_module(klass, module: Tvalue); cdecl;
procedure rb_extend_object(obj, module: Tvalue); cdecl;

procedure rb_define_variable(const name: PAnsiChar; v: Pvalue); cdecl;
procedure rb_define_virtual_variable(const name: PAnsiChar; getter, setter: Pointer); cdecl;
procedure rb_define_hooked_variable(const name: PAnsiChar; v: Pvalue; getter, setter: Pointer); cdecl;
procedure rb_define_readonly_variable(const name: PAnsiChar; v: Pvalue); cdecl;
procedure rb_define_const(klass: Tvalue; const name: PAnsiChar; v: Tvalue); cdecl;
procedure rb_define_global_const(const name: PAnsiChar; v: Tvalue); cdecl;

function rb_define_method(klass: Tvalue; name: PAnsiChar; func: Pointer; argc: integer): Tvalue; cdecl;
function rb_define_module_function(module: Tvalue; name: PAnsiChar; func: Pointer; argc: integer): Tvalue; cdecl;
function rb_define_global_function(name: PAnsiChar; func: Pointer; argc: integer): Tvalue; cdecl;

procedure rb_undef_method(klass: Tvalue; const name: PAnsiChar); cdecl;
procedure rb_define_alias(klass: Tvalue; const name1, name2: PAnsiChar); cdecl;
procedure rb_define_attr(klass: Tvalue; const name: PAnsiChar; r, w: Integer); cdecl;

function rb_intern(name: PAnsiChar): Tid; cdecl;
function rb_id2name(id: Tid): PAnsiChar; cdecl;
function rb_to_id(obj: Tvalue): Tid; cdecl;

function rb_class2name(klass: Tvalue): PAnsiChar; cdecl;

procedure rb_p(obj: Tvalue); cdecl;

function rb_eval_string(const str: PAnsiChar): Tvalue; cdecl;
function rb_eval_string_protect(const str: PAnsiChar; var state: Integer): Tvalue; cdecl;
function rb_eval_string_wrap(const str: PAnsiChar; var state: Integer): Tvalue; cdecl;
function rb_funcall2(recv: Tvalue; mid: Tid; argc: Integer; argv: Pointer): Tvalue; cdecl;
function rb_funcall3(recv: Tvalue; mid: Tid; argc: Integer; argv: Pointer): Tvalue; cdecl;

function rb_gv_set(const name: PAnsiChar; val: Tvalue): Tvalue; cdecl;
function rb_gv_get(const name: PAnsiChar): Tvalue; cdecl;
function rb_iv_get(obj: Tvalue; const name: PAnsiChar): Tvalue; cdecl;
function rb_iv_set(obj: Tvalue; const name: PAnsiChar; val: Tvalue): Tvalue; cdecl;
function rb_cv_get(obj: Tvalue; const name: PAnsiChar): Tvalue; cdecl;
function rb_cv_set(obj: Tvalue; const name: PAnsiChar; val: Tvalue): Tvalue; cdecl;
function rb_const_get(klass: Tvalue; id: Tid): Tvalue; cdecl;
function rb_const_get_at(klass: Tvalue; id: Tid): Tvalue; cdecl;
procedure rb_const_set(klass: Tvalue; id: Tid; val: Tvalue); cdecl;

function rb_equal(x, y: Tvalue): Tvalue; cdecl;

function rb_safe_level: Integer; cdecl;
procedure rb_set_safe_level(level: Integer); cdecl;

procedure rb_sys_fail(const mesg: PAnsiChar); cdecl;
procedure rb_iter_break; cdecl;
procedure rb_exit(status: Integer); cdecl;
procedure rb_notimplement; cdecl;

function rb_each(obj: Tvalue): Tvalue; cdecl;
function rb_yield(val: Tvalue): Tvalue; cdecl;
function rb_block_given_p: Integer; cdecl;
function rb_iterate(it_proc: Pointer; data1: Tvalue; bl_proc: Pointer; data2: Tvalue): Tvalue; cdecl;
function rb_rescue(b_proc: Pointer; data1: Tvalue; r_proc: Pointer; data2: Tvalue): Tvalue; cdecl;
function rb_ensure(b_proc: Pointer; data1: Tvalue; e_proc: Pointer; data2: Tvalue): Tvalue; cdecl;
function rb_catch(const tag: PAnsiChar; proc: Pointer; data: Tvalue): Tvalue; cdecl;
procedure rb_throw(const tag: PAnsiChar; val: Tvalue); cdecl;

function rb_require(const fname: PAnsiChar): Tvalue; cdecl;

procedure ruby_init; cdecl;
procedure ruby_options(argc: Integer; argv: Pointer); cdecl;
procedure ruby_run; cdecl;
procedure ruby_finalize; cdecl;
{$IFDEF RUBY18}
function ruby_cleanup(ex: Integer): Integer; cdecl;
function ruby_exec: Integer; cdecl;
{$ENDIF}
procedure ruby_stop(ex: Integer); cdecl;

procedure ruby_incpush(const path: PAnsiChar); cdecl;
procedure ruby_init_loadpath; cdecl;
procedure require_libraries; cdecl;

procedure rb_load_file(fname: PAnsiChar); cdecl;
procedure ruby_script(fname: PAnsiChar); cdecl;
procedure ruby_prog_init; cdecl;
procedure ruby_set_argv(argc: Integer; argv: Pointer); cdecl;
procedure ruby_process_options(argc: Integer; argv: Pointer); cdecl;
procedure ruby_load_script; cdecl;

{ signal.c }
function rb_f_kill(argc: Integer; argv: Pvalue): Tvalue; cdecl;
procedure rb_gc_mark_trap_list; cdecl;
procedure rb_trap_exit; cdecl;
procedure rb_trap_exec; cdecl;
procedure rb_trap_restore_mask; cdecl;

{ string.c }
function rb_str_new(const ptr: PAnsiChar; len: Longint): Tvalue; cdecl;
function rb_str_new2(const ptr: PAnsiChar): Tvalue; cdecl;
function rb_str_new3(str: Tvalue): Tvalue; cdecl;
function rb_str_new4(orig: Tvalue): Tvalue; cdecl;
function rb_tainted_str_new(const ptr: PAnsiChar; len: Longint): Tvalue; cdecl;
function rb_tainted_str_new2(const ptr: PAnsiChar): Tvalue; cdecl;
function rb_obj_as_string(obj: Tvalue): Tvalue; cdecl;
function rb_str_to_str(str: Tvalue): Tvalue; cdecl;
function rb_str_dup(str: Tvalue): Tvalue; cdecl;
function rb_str_plus(str1, str2: Tvalue): Tvalue; cdecl;
function rb_str_times(str, times: Tvalue): Tvalue; cdecl;
function rb_str_substr(str: Tvalue; beg, len: Longint): Tvalue; cdecl;
procedure rb_str_modify(str: Tvalue); cdecl;
function rb_str_freeze(str: Tvalue): Tvalue; cdecl;
function rb_str_resize(str: Tvalue; len: Longint): Tvalue; cdecl;
function rb_str_cat(str: Tvalue; const ptr: PAnsiChar; len: Longint): Tvalue; cdecl;
function rb_str_concat(str1, str2: Tvalue): Tvalue; cdecl;
function rb_str_hash(str: Tvalue): Integer; cdecl;
function rb_str_cmp(str1, str2: Tvalue): Integer; cdecl;
function rb_str_upto(beg, fin: Tvalue; excl: Integer): Tvalue; cdecl;
function rb_str_inspect(str: Tvalue): Tvalue; cdecl;
function rb_str_split(str: Tvalue; const sep: PAnsiChar): Tvalue; cdecl;

{ struct.c }
function rb_struct_alloc(klass, values: Tvalue): Tvalue; cdecl;

{ util.c }
function rb_test_false_or_nil(v: Tvalue): Integer; cdecl;
function ruby_scan_oct(const start: PAnsiChar; len: Integer; retlen: Pointer): Integer; cdecl;
function ruby_scan_hex(const start: PAnsiChar; len: Integer; retlen: Pointer): Integer; cdecl;
function ruby_mktemp: PAnsiChar; cdecl;
procedure ruby_qsort(base: Pointer; nel, size: Integer; cmp: TRetIntFunc); cdecl;

{ variable.c }
function rb_mod_name(module: Tvalue): Tvalue; cdecl;
function rb_class_path(klass: Tvalue): Tvalue; cdecl;
procedure rb_set_class_path(klass, under: Tvalue; const name: PAnsiChar); cdecl;
function rb_path2class(const path: PAnsiChar): Tvalue; cdecl;

procedure rb_name_class(klass: Tvalue; id: Tid); cdecl;
procedure rb_autoload(const klass, filename: PAnsiChar); cdecl;
function rb_f_autoload(obj, klass, f: Tvalue): Tvalue; cdecl;
procedure rb_gc_mark_global_tbl; cdecl;
function rb_f_trace_var(argc: Integer; argv: Pvalue): Tvalue; cdecl;
function rb_f_untrace_var(argc: Integer; argv: Pvalue): Tvalue; cdecl;
function rb_f_global_variables: Tvalue; cdecl;
procedure rb_alias_variable(name1, name2: Tid); cdecl;
function rb_generic_ivar_table(obj: Tvalue): PSTTable; cdecl;
procedure rb_clone_generic_ivar(clone, obj: Tvalue); cdecl;
procedure rb_mark_generic_ivar(obj: Tvalue); cdecl;
procedure rb_mark_generic_ivar_tbl; cdecl;
procedure rb_free_generic_ivar(obj: Tvalue); cdecl;

function rb_ivar_get(obj: Tvalue; id: Tid): Tvalue; cdecl;
function rb_ivar_set(obj: Tvalue; id: Tid; val: Tvalue): Tvalue; cdecl;
function rb_ivar_defined(obj: Tvalue; id: Tid): Tvalue; cdecl;

function rb_obj_instance_variables(obj: Tvalue): Tvalue; cdecl;
function rb_obj_remove_instance_variable(obj, name: Tvalue): Tvalue; cdecl;
function rb_mod_const_at(module, ary: Tvalue): Tvalue; cdecl;
function rb_mod_constants(module: Tvalue): Tvalue; cdecl;
function rb_mod_const_of(module, ary: Tvalue): Tvalue; cdecl;
function rb_mod_remove_const(module, name: Tvalue): Tvalue; cdecl;
function rb_const_defined_at(klass: Tvalue; id: Tid): Integer; cdecl;
function rb_autoload_defined(id: Tid): Integer; cdecl;
function rb_const_defined(klass: Tvalue; id: Tid): Integer; cdecl;

{ version.c }
procedure ruby_show_version; cdecl;
procedure ruby_show_copyright; cdecl;

{ win32.c }
procedure NtInitialize(argcp, argvp: Pointer); cdecl;
procedure win32_disable_interrupt; cdecl;
procedure win32_enable_interrupt; cdecl;

implementation

uses uStrUtils, wrapimp, macroimp;

{ array.c }
procedure rb_mem_clear; cdecl; external RubyDLL;
function rb_assoc_new; cdecl; external RubyDLL;
function rb_ary_new; cdecl; external RubyDLL;
function rb_ary_new2; cdecl; external RubyDLL;
//function rb_ary_new3: Tvalue;
function rb_ary_new4; cdecl; external RubyDLL;
function rb_ary_freeze; cdecl; external RubyDLL;
function rb_ary_aref; cdecl; external RubyDLL;
procedure rb_ary_store; cdecl; external RubyDLL;
function rb_ary_to_s; cdecl; external RubyDLL;
function rb_ary_push; cdecl; external RubyDLL;
function rb_ary_pop; cdecl; external RubyDLL;
function rb_ary_shift; cdecl; external RubyDLL;
function rb_ary_unshift; cdecl; external RubyDLL;
function rb_ary_entry; cdecl; external RubyDLL;
function rb_ary_each; cdecl; external RubyDLL;
function rb_ary_join; cdecl; external RubyDLL;
//function rb_ary_print_on: Tvalue;
function rb_ary_reverse; cdecl; external RubyDLL;
function rb_ary_sort; cdecl; external RubyDLL;
function rb_ary_sort_bang; cdecl; external RubyDLL;
function rb_ary_delete; cdecl; external RubyDLL;
function rb_ary_delete_at; cdecl; external RubyDLL;
function rb_ary_clear; cdecl; external RubyDLL;
function rb_ary_plus; cdecl; external RubyDLL;
function rb_ary_concat; cdecl; external RubyDLL;
function rb_ary_assoc; cdecl; external RubyDLL;
function rb_ary_rassoc; cdecl; external RubyDLL;
function rb_ary_includes; cdecl; external RubyDLL;
function rb_protect_inspect; cdecl; external RubyDLL;
function rb_inspecting_p; cdecl; external RubyDLL;

{ bignum.c }
function rb_big_clone; cdecl; external RubyDLL;
procedure rb_big_2comp; cdecl; external RubyDLL;
function rb_big_norm; cdecl; external RubyDLL;
function rb_uint2big; cdecl; external RubyDLL;
function rb_int2big; cdecl; external RubyDLL;
function rb_uint2inum; cdecl; external RubyDLL;
function rb_int2inum; cdecl; external RubyDLL;
function rb_str2inum; cdecl; external RubyDLL;
function rb_big2str; cdecl; external RubyDLL;
function rb_big2long; cdecl; external RubyDLL;
function rb_big2ulong; cdecl; external RubyDLL;
function rb_dbl2big; cdecl; external RubyDLL;
function rb_big2dbl; cdecl; external RubyDLL;
function rb_big_plus; cdecl; external RubyDLL;
function rb_big_minus; cdecl; external RubyDLL;
function rb_big_mul; cdecl; external RubyDLL;
function rb_big_pow; cdecl; external RubyDLL;
function rb_big_and; cdecl; external RubyDLL;
function rb_big_or; cdecl; external RubyDLL;
function rb_big_xor; cdecl; external RubyDLL;
function rb_big_lshift; cdecl; external RubyDLL;
function rb_big_rand; cdecl; external RubyDLL;

{ class.c }
function rb_class_new; cdecl; external RubyDLL;
function rb_singleton_class_new; cdecl; external RubyDLL;
function rb_singleton_class_clone; cdecl; external RubyDLL;
procedure rb_singleton_class_attached; cdecl; external RubyDLL;
function rb_define_class_id; cdecl; external RubyDLL;
function rb_module_new; cdecl; external RubyDLL;
function rb_define_module_id; cdecl; external RubyDLL;
function rb_mod_included_modules; cdecl; external RubyDLL;
function rb_mod_ancestors; cdecl; external RubyDLL;
function rb_class_instance_methods; cdecl; external RubyDLL;
function rb_class_protected_instance_methods; cdecl; external RubyDLL;
function rb_class_private_instance_methods; cdecl; external RubyDLL;
function rb_obj_singleton_methods; cdecl; external RubyDLL;
procedure rb_define_method_id; cdecl; external RubyDLL;
procedure rb_define_protected_method; cdecl; external RubyDLL;
procedure rb_define_private_method; cdecl; external RubyDLL;
procedure rb_define_singleton_method; cdecl; external RubyDLL;
function rb_singleton_class; cdecl; external RubyDLL;

{ error.c }
function rb_exc_new; cdecl; external RubyDLL;
function rb_exc_new2; cdecl; external RubyDLL;
function rb_exc_new3; cdecl; external RubyDLL;

{ eval.c }
procedure rb_exc_raise; cdecl; external RubyDLL;
procedure rb_exc_fatal; cdecl; external RubyDLL;
procedure rb_remove_method; cdecl; external RubyDLL;
procedure rb_disable_super; cdecl; external RubyDLL;
procedure rb_enable_super; cdecl; external RubyDLL;
procedure rb_clear_cache; cdecl; external RubyDLL;
procedure rb_alias; cdecl; external RubyDLL;
procedure rb_attr; cdecl; external RubyDLL;
function rb_method_boundp; cdecl; external RubyDLL;
function rb_dvar_defined; cdecl; external RubyDLL;
function rb_dvar_ref; cdecl; external RubyDLL;
procedure rb_dvar_asgn; cdecl; external RubyDLL;
procedure rb_dvar_push; cdecl; external RubyDLL;
function rb_eval_cmd; cdecl; external RubyDLL;
function rb_respond_to; cdecl; external RubyDLL;
procedure rb_interrupt; cdecl; external RubyDLL;
function rb_apply; cdecl; external RubyDLL;
procedure rb_backtrace; cdecl; external RubyDLL;
function rb_frame_last_func; cdecl; external RubyDLL;
function rb_obj_instance_eval; cdecl; external RubyDLL;
procedure rb_set_end_proc; cdecl; external RubyDLL;
procedure rb_exec_end_proc; cdecl; external RubyDLL;
procedure rb_mark_end_proc; cdecl; external RubyDLL;
procedure rb_gc_mark_threads; cdecl; external RubyDLL;
procedure rb_thread_start_timer; cdecl; external RubyDLL;
procedure rb_thread_stop_timer; cdecl; external RubyDLL;
procedure rb_thread_schedule; cdecl; external RubyDLL;
procedure rb_thread_wait_fd; cdecl; external RubyDLL;
function rb_thread_fd_writable; cdecl; external RubyDLL;
procedure rb_thread_fd_close; cdecl; external RubyDLL;
function rb_thread_alone; cdecl; external RubyDLL;
procedure rb_thread_sleep; cdecl; external RubyDLL;
procedure rb_thread_sleep_forever; cdecl; external RubyDLL;
function rb_thread_stop; cdecl; external RubyDLL;
function rb_thread_wakeup; cdecl; external RubyDLL;
function rb_thread_run; cdecl; external RubyDLL;
function rb_thread_create; cdecl; external RubyDLL;
function rb_thread_scope_shared_p; cdecl; external RubyDLL;
procedure rb_thread_interrupt; cdecl; external RubyDLL;
procedure rb_thread_trap_eval; cdecl; external RubyDLL;
procedure rb_thread_signal_raise; cdecl; external RubyDLL;
function rb_thread_select; cdecl; external RubyDLL;
procedure rb_thread_wait_for; cdecl; external RubyDLL;
function rb_thread_current; cdecl; external RubyDLL;
function rb_thread_main; cdecl; external RubyDLL;
function rb_thread_local_aref; cdecl; external RubyDLL;
function rb_thread_local_aset; cdecl; external RubyDLL;

{ file.c }
function eaccess; cdecl; external RubyDLL;
function rb_file_s_expand_path; cdecl; external RubyDLL;
procedure rb_file_const; cdecl; external RubyDLL;
function rb_find_file; cdecl; external RubyDLL;

{ gc.c }
procedure rb_global_variable; cdecl; external RubyDLL;
procedure rb_gc_mark_locations; cdecl; external RubyDLL;
//procedure rb_mark_tbl;
//procedure rb_mark_hash;
procedure rb_gc_mark_maybe; cdecl; external RubyDLL;
procedure rb_gc_mark; cdecl; external RubyDLL;
procedure rb_gc_force_recycle; cdecl; external RubyDLL;
procedure rb_gc; cdecl; external RubyDLL;
procedure rb_gc_call_finalizer_at_exit; cdecl; external RubyDLL;

{ hash.c }
function rb_hash; cdecl; external RubyDLL;
function rb_hash_new; cdecl; external RubyDLL;
function rb_hash_freeze; cdecl; external RubyDLL;
function rb_hash_aref; cdecl; external RubyDLL;
function rb_hash_aset; cdecl; external RubyDLL;
function rb_path_check; cdecl; external RubyDLL;
function rb_env_path_tainted; cdecl; external RubyDLL;

{ intern.h }
procedure rb_load; cdecl; external RubyDLL;
procedure rb_load_protect; cdecl; external RubyDLL;
procedure rb_jump_tag; cdecl; external RubyDLL;
procedure rb_provide; cdecl; external RubyDLL;
function rb_f_require; cdecl; external RubyDLL;
procedure rb_obj_call_init; cdecl; external RubyDLL;
function rb_class_new_instance; cdecl; external RubyDLL;
function rb_f_lambda; cdecl; external RubyDLL;
function rb_protect; cdecl; external RubyDLL;

function rb_id_attrset; cdecl; external RubyDLL;

{ io.c }
function rb_io_write; cdecl; external RubyDLL;
function rb_io_gets; cdecl; external RubyDLL;
function rb_io_getc; cdecl; external RubyDLL;
function rb_io_ungetc; cdecl; external RubyDLL;
function rb_io_close; cdecl; external RubyDLL;
function rb_io_eof; cdecl; external RubyDLL;
function rb_io_binmode; cdecl; external RubyDLL;
function rb_file_open; cdecl; external RubyDLL;
function rb_gets; cdecl; external RubyDLL;
procedure rb_str_setter; cdecl; external RubyDLL;
function rb_io_mode_flags; cdecl; external RubyDLL;

{ numeric.c }
procedure rb_num_zerodiv; cdecl; external RubyDLL;
function rb_num_coerce_bin; cdecl; external RubyDLL;
function rb_float_new; cdecl; external RubyDLL;
function rb_num2fix; cdecl; external RubyDLL;
function rb_fix2str; cdecl; external RubyDLL;
function rb_fix_upto; cdecl; external RubyDLL;

{ object.c }
function rb_inspect; cdecl; external RubyDLL;
function rb_obj_is_instance_of; cdecl; external RubyDLL;
function rb_obj_is_kind_of; cdecl; external RubyDLL;

{ parse.c }
function yyparse; cdecl; external RubyDLL;
procedure rb_parser_append_print; cdecl; external RubyDLL;
procedure rb_parser_while_loop; cdecl; external RubyDLL;
function rb_is_const_id; cdecl; external RubyDLL;
function rb_is_instance_id; cdecl; external RubyDLL;
function rb_backref_get; cdecl; external RubyDLL;
procedure rb_backref_set; cdecl; external RubyDLL;
function rb_lastline_get; cdecl; external RubyDLL;
procedure rb_lastline_set; cdecl; external RubyDLL;

{ process.c }
function rb_proc_exec; cdecl; external RubyDLL;
procedure rb_syswait; cdecl; external RubyDLL;

{ range.c }
function rb_range_new; cdecl; external RubyDLL;
function rb_range_beg_len; cdecl; external RubyDLL;

{ re.c }
function rb_mbclen2; cdecl; external RubyDLL;
function rb_str_cicmp; cdecl; external RubyDLL;
function rb_reg_search; cdecl; external RubyDLL;
function rb_reg_nth_defined; cdecl; external RubyDLL;
function rb_reg_nth_match; cdecl; external RubyDLL;
function rb_reg_last_match; cdecl; external RubyDLL;
function rb_reg_match_pre; cdecl; external RubyDLL;
function rb_reg_match_post; cdecl; external RubyDLL;
function rb_reg_match_last; cdecl; external RubyDLL;
function rb_reg_new; cdecl; external RubyDLL;
function rb_reg_regcomp; cdecl; external RubyDLL;
function rb_reg_match; cdecl; external RubyDLL;
function rb_reg_match2; cdecl; external RubyDLL;
function rb_kcode; cdecl; external RubyDLL;
function rb_reg_options; cdecl; external RubyDLL;
function rb_reg_regsub; cdecl; external RubyDLL;
function rb_get_kcode; cdecl; external RubyDLL;
procedure rb_set_kcode; cdecl; external RubyDLL;
procedure rb_match_busy; cdecl; external RubyDLL;

{ ruby.c }
procedure rb_check_type; cdecl; external RubyDLL;
procedure rb_check_safe_str; cdecl; external RubyDLL;
procedure rb_secure; cdecl; external RubyDLL;
function rb_num2long; cdecl; external RubyDLL;
function rb_num2ulong; cdecl; external RubyDLL;
function rb_num2dbl; cdecl; external RubyDLL;
function rb_str2cstr; cdecl; external RubyDLL;

function rb_newobj; cdecl; external RubyDLL;

function rb_data_object_alloc; cdecl; external RubyDLL;

function rb_define_class; cdecl; external RubyDLL;
function rb_define_module; cdecl; external RubyDLL;
function rb_define_class_under; cdecl; external RubyDLL;
function rb_define_module_under; cdecl; external RubyDLL;

procedure rb_include_module; cdecl; external RubyDLL;
procedure rb_extend_object; cdecl; external RubyDLL;

procedure rb_define_variable; cdecl; external RubyDLL;
procedure rb_define_virtual_variable; cdecl; external RubyDLL;
procedure rb_define_hooked_variable; cdecl; external RubyDLL;
procedure rb_define_readonly_variable; cdecl; external RubyDLL;
procedure rb_define_const; cdecl; external RubyDLL;
procedure rb_define_global_const; cdecl; external RubyDLL;

function rb_define_method; cdecl; external RubyDLL;
function rb_define_module_function; cdecl; external RubyDLL;
function rb_define_global_function; cdecl; external RubyDLL;

procedure rb_undef_method; cdecl; external RubyDLL;
procedure rb_define_alias; cdecl; external RubyDLL;
procedure rb_define_attr; cdecl; external RubyDLL;

function rb_intern; cdecl; external RubyDLL;
function rb_id2name; cdecl; external RubyDLL;
function rb_to_id; cdecl; external RubyDLL;

function rb_class2name; cdecl; external RubyDLL;

procedure rb_p; cdecl; external RubyDLL;

function rb_eval_string; cdecl; external RubyDLL;
function rb_eval_string_protect; cdecl; external RubyDLL;
function rb_eval_string_wrap; cdecl; external RubyDLL;
function rb_funcall2; cdecl; external RubyDLL;
function rb_funcall3; cdecl; external RubyDLL;

function rb_gv_set; cdecl; external RubyDLL;
function rb_gv_get; cdecl; external RubyDLL;
function rb_iv_get; cdecl; external RubyDLL;
function rb_iv_set; cdecl; external RubyDLL;
function rb_cv_get; cdecl; external RubyDLL;
function rb_cv_set; cdecl; external RubyDLL;
function rb_const_get; cdecl; external RubyDLL;
function rb_const_get_at; cdecl; external RubyDLL;
procedure rb_const_set; cdecl; external RubyDLL;

function rb_equal; cdecl; external RubyDLL;

function rb_safe_level; cdecl; external RubyDLL;
procedure rb_set_safe_level; cdecl; external RubyDLL;

procedure rb_sys_fail; cdecl; external RubyDLL;
procedure rb_iter_break; cdecl; external RubyDLL;
procedure rb_exit; cdecl; external RubyDLL;
procedure rb_notimplement; cdecl; external RubyDLL;

function rb_each; cdecl; external RubyDLL;
function rb_yield; cdecl; external RubyDLL;
function rb_block_given_p; cdecl; external RubyDLL;
function rb_iterate; cdecl; external RubyDLL;
function rb_rescue; cdecl; external RubyDLL;
function rb_ensure; cdecl; external RubyDLL;
function rb_catch; cdecl; external RubyDLL;
procedure rb_throw; cdecl; external RubyDLL;

function rb_require; cdecl; external RubyDLL;

procedure ruby_init; cdecl; external RubyDLL;
procedure ruby_options; cdecl; external RubyDLL;
procedure ruby_run; cdecl; external RubyDLL;
procedure ruby_finalize; cdecl; external RubyDLL;
{$IFDEF RUBY18}
function ruby_cleanup; cdecl; external RubyDLL;
function ruby_exec; cdecl; external RubyDLL;
{$ENDIF}
procedure ruby_stop; cdecl; external RubyDLL;

procedure ruby_incpush; cdecl; external RubyDLL;
procedure ruby_init_loadpath; cdecl; external RubyDLL;
procedure require_libraries; cdecl; external RubyDLL;

procedure rb_load_file; cdecl; external RubyDLL;
procedure ruby_script; cdecl; external RubyDLL;
procedure ruby_prog_init; cdecl; external RubyDLL;
procedure ruby_set_argv; cdecl; external RubyDLL;
procedure ruby_process_options; cdecl; external RubyDLL;
procedure ruby_load_script; cdecl; external RubyDLL;

{ signal.c }
function rb_f_kill; cdecl; external RubyDLL;
procedure rb_gc_mark_trap_list; cdecl; external RubyDLL;
procedure rb_trap_exit; cdecl; external RubyDLL;
procedure rb_trap_exec; cdecl; external RubyDLL;
procedure rb_trap_restore_mask; cdecl; external RubyDLL;

{ string.c }
function rb_str_new; cdecl; external RubyDLL;
function rb_str_new2; cdecl; external RubyDLL;
function rb_str_new3; cdecl; external RubyDLL;
function rb_str_new4; cdecl; external RubyDLL;
function rb_tainted_str_new; cdecl; external RubyDLL;
function rb_tainted_str_new2; cdecl; external RubyDLL;
function rb_obj_as_string; cdecl; external RubyDLL;
function rb_str_to_str; cdecl; external RubyDLL;
function rb_str_dup; cdecl; external RubyDLL;
function rb_str_plus; cdecl; external RubyDLL;
function rb_str_times; cdecl; external RubyDLL;
function rb_str_substr; cdecl; external RubyDLL;
procedure rb_str_modify; cdecl; external RubyDLL;
function rb_str_freeze; cdecl; external RubyDLL;
function rb_str_resize; cdecl; external RubyDLL;
function rb_str_cat; cdecl; external RubyDLL;
function rb_str_concat; cdecl; external RubyDLL;
function rb_str_hash; cdecl; external RubyDLL;
function rb_str_cmp; cdecl; external RubyDLL;
function rb_str_upto; cdecl; external RubyDLL;
function rb_str_inspect; cdecl; external RubyDLL;
function rb_str_split; cdecl; external RubyDLL;

{ struct.c }
function rb_struct_alloc; cdecl; external RubyDLL;

{ util.c }
function rb_test_false_or_nil; cdecl; external RubyDLL;
function ruby_scan_oct; cdecl; external RubyDLL;
function ruby_scan_hex; cdecl; external RubyDLL;
function ruby_mktemp; cdecl; external RubyDLL;
procedure ruby_qsort; cdecl; external RubyDLL;

{ variable.c }
function rb_mod_name; cdecl; external RubyDLL;
function rb_class_path; cdecl; external RubyDLL;
procedure rb_set_class_path; cdecl; external RubyDLL;
function rb_path2class; cdecl; external RubyDLL;

procedure rb_name_class; cdecl; external RubyDLL;
procedure rb_autoload; cdecl; external RubyDLL;
function rb_f_autoload; cdecl; external RubyDLL;
procedure rb_gc_mark_global_tbl; cdecl; external RubyDLL;
function rb_f_trace_var; cdecl; external RubyDLL;
function rb_f_untrace_var; cdecl; external RubyDLL;
function rb_f_global_variables; cdecl; external RubyDLL;
procedure rb_alias_variable; cdecl; external RubyDLL;
function rb_generic_ivar_table; cdecl; external RubyDLL;
procedure rb_clone_generic_ivar; cdecl; external RubyDLL;
procedure rb_mark_generic_ivar; cdecl; external RubyDLL;
procedure rb_mark_generic_ivar_tbl; cdecl; external RubyDLL;
procedure rb_free_generic_ivar; cdecl; external RubyDLL;

function rb_ivar_get; cdecl; external RubyDLL;
function rb_ivar_set; cdecl; external RubyDLL;
function rb_ivar_defined; cdecl; external RubyDLL;

function rb_obj_instance_variables; cdecl; external RubyDLL;
function rb_obj_remove_instance_variable; cdecl; external RubyDLL;
function rb_mod_const_at; cdecl; external RubyDLL;
function rb_mod_constants; cdecl; external RubyDLL;
function rb_mod_const_of; cdecl; external RubyDLL;
function rb_mod_remove_const; cdecl; external RubyDLL;
function rb_const_defined_at; cdecl; external RubyDLL;
function rb_autoload_defined; cdecl; external RubyDLL;
function rb_const_defined; cdecl; external RubyDLL;

{ version.c }
procedure ruby_show_version; cdecl; external RubyDLL;
procedure ruby_show_copyright; cdecl; external RubyDLL;

{ win32.c }
procedure NtInitialize; cdecl; external RubyDLL;
procedure win32_disable_interrupt; cdecl; external RubyDLL;
procedure win32_enable_interrupt; cdecl; external RubyDLL;

end.
