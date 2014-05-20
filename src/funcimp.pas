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

