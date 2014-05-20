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
function rb_str2inum(const ptr: PChar; len: Integer): Tvalue; cdecl;
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
procedure rb_define_protected_method(klass: Tvalue; const name: PChar; func: TFunc0; argc: Integer); cdecl;
procedure rb_define_private_method(klass: Tvalue; const name: PChar; func: TFunc0; argc: Integer); cdecl;
procedure rb_define_singleton_method(obj: Tvalue; const name: PChar; func: TFunc0; argc: Integer); cdecl;
function rb_singleton_class(obj: Tvalue): Tvalue; cdecl;

{ error.c }
function rb_exc_new(etype: Tvalue; const ptr: PChar; len: Integer): Tvalue; cdecl;
function rb_exc_new2(etype: Tvalue; const s: PChar): Tvalue; cdecl;
function rb_exc_new3(etype, str: Tvalue): Tvalue; cdecl;

{ eval.c }
procedure rb_exc_raise(mesg: Tvalue); cdecl;
procedure rb_exc_fatal(mesg: Tvalue); cdecl;
procedure rb_remove_method(klass: Tvalue; const name: PChar); cdecl;
procedure rb_disable_super(klass: Tvalue; const name: PChar); cdecl;
procedure rb_enable_super(klass: Tvalue; const name: PChar); cdecl;
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
procedure rb_thread_signal_raise(sig: PChar); cdecl;
function rb_thread_select: Integer; cdecl;
procedure rb_thread_wait_for; cdecl;
function rb_thread_current: Tvalue; cdecl;
function rb_thread_main: Tvalue; cdecl;
function rb_thread_local_aref(thread: Tvalue; id: Tid): Tvalue; cdecl;
function rb_thread_local_aset(thread: Tvalue; id: Tid; val: Tvalue): Tvalue; cdecl;

{ file.c }
function eaccess(const path: PChar; mode: Integer): Integer; cdecl;
function rb_file_s_expand_path(argc: Integer; argv: Pvalue): Tvalue; cdecl;
procedure rb_file_const(const fname: PChar; v: Tvalue); cdecl;
function rb_find_file(fname :PChar): PChar; cdecl;

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
function rb_path_check(path: PChar): Integer; cdecl;
function rb_env_path_tainted: Integer; cdecl;

{ intern.h }
procedure rb_load(fname: Tvalue; wrap: Integer); cdecl;
procedure rb_load_protect(fname: Tvalue; wrap: Integer; var state: Integer); cdecl;
procedure rb_jump_tag(tag: Integer); cdecl;
procedure rb_provide(const feature: PChar); cdecl;
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
function rb_io_mode_flags(mode: PChar): Integer; cdecl;

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
function rb_proc_exec(const str: PChar): Integer; cdecl;
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
function rb_reg_new(const s: PChar; len, options: Integer): Tvalue; cdecl;
function rb_reg_regcomp(str : Tvalue): Tvalue; cdecl;
function rb_reg_match(re, str: Tvalue): Tvalue; cdecl;
function rb_reg_match2(re: Tvalue): Tvalue; cdecl;
function rb_kcode: Integer; cdecl;
function rb_reg_options(re: Tvalue): Integer; cdecl;
function rb_reg_regsub(str, src: Tvalue; regs: PRERegisters): Tvalue; cdecl;
function rb_get_kcode: PChar; cdecl;
procedure rb_set_kcode(const code: PChar); cdecl;
procedure rb_match_busy(match: Tvalue); cdecl;

{ ruby.c }
procedure rb_check_type(x: Tvalue; t: Integer); cdecl;
procedure rb_check_safe_str(x: Tvalue); cdecl;
procedure rb_secure(level: Integer); cdecl;
function rb_num2long(val: Tvalue): Integer; cdecl;
function rb_num2ulong(val: Tvalue): Cardinal; cdecl;
function rb_num2dbl(n: Tvalue): Double; cdecl;
function rb_str2cstr(x: Tvalue; var len: Integer): PChar; cdecl;

function rb_newobj: Tvalue; cdecl;

function rb_data_object_alloc(klass: Tvalue; datap, dmark, dfree: Pointer): Tvalue; cdecl;

function rb_define_class(const name: PChar; super: Tvalue): Tvalue; cdecl;
function rb_define_module(const name: PChar): Tvalue; cdecl;
function rb_define_class_under(module: Tvalue; const name: PChar; super: Tvalue): Tvalue; cdecl;
function rb_define_module_under(module: Tvalue; const name: PChar): Tvalue; cdecl;

procedure rb_include_module(klass, module: Tvalue); cdecl;
procedure rb_extend_object(obj, module: Tvalue); cdecl;

procedure rb_define_variable(const name: PChar; v: Pvalue); cdecl;
procedure rb_define_virtual_variable(const name: PChar; getter, setter: Pointer); cdecl;
procedure rb_define_hooked_variable(const name: PChar; v: Pvalue; getter, setter: Pointer); cdecl;
procedure rb_define_readonly_variable(const name: PChar; v: Pvalue); cdecl;
procedure rb_define_const(klass: Tvalue; const name: PChar; v: Tvalue); cdecl;
procedure rb_define_global_const(const name: PChar; v: Tvalue); cdecl;

function rb_define_method(klass: Tvalue; name: PChar; func: Pointer; argc: integer): Tvalue; cdecl;
function rb_define_module_function(module: Tvalue; name: PChar; func: Pointer; argc: integer): Tvalue; cdecl;
function rb_define_global_function(name: PChar; func: Pointer; argc: integer): Tvalue; cdecl;

procedure rb_undef_method(klass: Tvalue; const name: PChar); cdecl;
procedure rb_define_alias(klass: Tvalue; const name1, name2: PChar); cdecl;
procedure rb_define_attr(klass: Tvalue; const name: PChar; r, w: Integer); cdecl;

function rb_intern(name: PChar): Tid; cdecl;
function rb_id2name(id: Tid): PChar; cdecl;
function rb_to_id(obj: Tvalue): Tid; cdecl;

function rb_class2name(klass: Tvalue): PChar; cdecl;

procedure rb_p(obj: Tvalue); cdecl;

function rb_eval_string(const str: PChar): Tvalue; cdecl;
function rb_eval_string_protect(const str: PChar; var state: Integer): Tvalue; cdecl;
function rb_eval_string_wrap(const str: PChar; var state: Integer): Tvalue; cdecl;
function rb_funcall2(recv: Tvalue; mid: Tid; argc: Integer; argv: Pointer): Tvalue; cdecl;
function rb_funcall3(recv: Tvalue; mid: Tid; argc: Integer; argv: Pointer): Tvalue; cdecl;

function rb_gv_set(const name: PChar; val: Tvalue): Tvalue; cdecl;
function rb_gv_get(const name: PChar): Tvalue; cdecl;
function rb_iv_get(obj: Tvalue; const name: PChar): Tvalue; cdecl;
function rb_iv_set(obj: Tvalue; const name: PChar; val: Tvalue): Tvalue; cdecl;
function rb_cv_get(obj: Tvalue; const name: PChar): Tvalue; cdecl;
function rb_cv_set(obj: Tvalue; const name: PChar; val: Tvalue): Tvalue; cdecl;
function rb_const_get(klass: Tvalue; id: Tid): Tvalue; cdecl;
function rb_const_get_at(klass: Tvalue; id: Tid): Tvalue; cdecl;
procedure rb_const_set(klass: Tvalue; id: Tid; val: Tvalue); cdecl;

function rb_equal(x, y: Tvalue): Tvalue; cdecl;

function rb_safe_level: Integer; cdecl;
procedure rb_set_safe_level(level: Integer); cdecl;

procedure rb_sys_fail(const mesg: PChar); cdecl;
procedure rb_iter_break; cdecl;
procedure rb_exit(status: Integer); cdecl;
procedure rb_notimplement; cdecl;

function rb_each(obj: Tvalue): Tvalue; cdecl;
function rb_yield(val: Tvalue): Tvalue; cdecl;
function rb_block_given_p: Integer; cdecl;
function rb_iterate(it_proc: Pointer; data1: Tvalue; bl_proc: Pointer; data2: Tvalue): Tvalue; cdecl;
function rb_rescue(b_proc: Pointer; data1: Tvalue; r_proc: Pointer; data2: Tvalue): Tvalue; cdecl;
function rb_ensure(b_proc: Pointer; data1: Tvalue; e_proc: Pointer; data2: Tvalue): Tvalue; cdecl;
function rb_catch(const tag: PChar; proc: Pointer; data: Tvalue): Tvalue; cdecl;
procedure rb_throw(const tag: PChar; val: Tvalue); cdecl;

function rb_require(const fname: PChar): Tvalue; cdecl;

procedure ruby_init; cdecl;
procedure ruby_options(argc: Integer; argv: Pointer); cdecl;
procedure ruby_run; cdecl;
procedure ruby_finalize; cdecl;
{$IFDEF RUBY18}
function ruby_cleanup(ex: Integer): Integer; cdecl;
function ruby_exec: Integer; cdecl;
{$ENDIF}
procedure ruby_stop(ex: Integer); cdecl;

procedure ruby_incpush(const path: PChar); cdecl;
procedure ruby_init_loadpath; cdecl;
procedure require_libraries; cdecl;

procedure rb_load_file(fname: PChar); cdecl;
procedure ruby_script(fname: PChar); cdecl;
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
function rb_str_new(const ptr: PChar; len: Longint): Tvalue; cdecl;
function rb_str_new2(const ptr: PChar): Tvalue; cdecl;
function rb_str_new3(str: Tvalue): Tvalue; cdecl;
function rb_str_new4(orig: Tvalue): Tvalue; cdecl;
function rb_tainted_str_new(const ptr: PChar; len: Longint): Tvalue; cdecl;
function rb_tainted_str_new2(const ptr: PChar): Tvalue; cdecl;
function rb_obj_as_string(obj: Tvalue): Tvalue; cdecl;
function rb_str_to_str(str: Tvalue): Tvalue; cdecl;
function rb_str_dup(str: Tvalue): Tvalue; cdecl;
function rb_str_plus(str1, str2: Tvalue): Tvalue; cdecl;
function rb_str_times(str, times: Tvalue): Tvalue; cdecl;
function rb_str_substr(str: Tvalue; beg, len: Longint): Tvalue; cdecl;
procedure rb_str_modify(str: Tvalue); cdecl;
function rb_str_freeze(str: Tvalue): Tvalue; cdecl;
function rb_str_resize(str: Tvalue; len: Longint): Tvalue; cdecl;
function rb_str_cat(str: Tvalue; const ptr: Pchar; len: Longint): Tvalue; cdecl;
function rb_str_concat(str1, str2: Tvalue): Tvalue; cdecl;
function rb_str_hash(str: Tvalue): Integer; cdecl;
function rb_str_cmp(str1, str2: Tvalue): Integer; cdecl;
function rb_str_upto(beg, fin: Tvalue; excl: Integer): Tvalue; cdecl;
function rb_str_inspect(str: Tvalue): Tvalue; cdecl;
function rb_str_split(str: Tvalue; const sep: PChar): Tvalue; cdecl;

{ struct.c }
function rb_struct_alloc(klass, values: Tvalue): Tvalue; cdecl;

{ util.c }
function rb_test_false_or_nil(v: Tvalue): Integer; cdecl;
function ruby_scan_oct(const start: PChar; len: Integer; retlen: Pointer): Integer; cdecl;
function ruby_scan_hex(const start: PChar; len: Integer; retlen: Pointer): Integer; cdecl;
function ruby_mktemp: PChar; cdecl;
procedure ruby_qsort(base: Pointer; nel, size: Integer; cmp: TRetIntFunc); cdecl;

{ variable.c }
function rb_mod_name(module: Tvalue): Tvalue; cdecl;
function rb_class_path(klass: Tvalue): Tvalue; cdecl;
procedure rb_set_class_path(klass, under: Tvalue; const name: PChar); cdecl;
function rb_path2class(const path: PChar): Tvalue; cdecl;

procedure rb_name_class(klass: Tvalue; id: Tid); cdecl;
procedure rb_autoload(const klass, filename: PChar); cdecl;
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

