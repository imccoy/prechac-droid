/*  File: pl-codetable.c

    This file provides a description of the virtual machine instructions
    and their arguments. It  is  used by  pl-comp.c  to facilitate the
    compiler and decompiler, as well as pl-wic.c to save/reload sequences
    of virtual machine qinstructions.

    Note: this file is generated by ./mkvmi from pl-vmi.c.  DO NOT EDIT    
*/

#include "pl-incl.h"

const code_info codeTable[] = {
  /* {name, ID, flags, #args, argtype} */
  {"d_break", D_BREAK, 0, 0, {0}},
  {"i_nop", I_NOP, 0, 0, {0}},
  {"h_const", H_CONST, 0, 1, {CA1_DATA}},
  {"h_nil", H_NIL, 0, 0, {0}},
  {"h_integer", H_INTEGER, 0, 1, {CA1_INTEGER}},
  {"h_int64", H_INT64, 0, WORDS_PER_INT64, {CA1_INT64}},
  {"h_float", H_FLOAT, 0, WORDS_PER_DOUBLE, {CA1_FLOAT}},
  {"h_mpz", H_MPZ, 0, VM_DYNARGC, {CA1_MPZ}},
  {"h_string", H_STRING, 0, VM_DYNARGC, {CA1_STRING}},
  {"h_void", H_VOID, 0, 0, {0}},
  {"h_void_n", H_VOID_N, 0, 1, {CA1_INTEGER}},
  {"h_var", H_VAR, 0, 1, {CA1_VAR}},
  {"h_firstvar", H_FIRSTVAR, 0, 1, {CA1_VAR}},
  {"h_functor", H_FUNCTOR, 0, 1, {CA1_FUNC}},
  {"h_rfunctor", H_RFUNCTOR, 0, 1, {CA1_FUNC}},
  {"h_list", H_LIST, 0, 0, {0}},
  {"h_rlist", H_RLIST, 0, 0, {0}},
  {"h_pop", H_POP, 0, 0, {0}},
  {"h_list_ff", H_LIST_FF, 0, 2, {CA1_VAR,CA1_VAR}},
  {"b_const", B_CONST, 0, 1, {CA1_DATA}},
  {"b_nil", B_NIL, 0, 0, {0}},
  {"b_integer", B_INTEGER, 0, 1, {CA1_INTEGER}},
  {"b_int64", B_INT64, 0, WORDS_PER_INT64, {CA1_INT64}},
  {"b_float", B_FLOAT, 0, WORDS_PER_DOUBLE, {CA1_FLOAT}},
  {"b_mpz", B_MPZ, 0, VM_DYNARGC, {CA1_MPZ}},
  {"b_string", B_STRING, 0, VM_DYNARGC, {CA1_STRING}},
  {"b_argvar", B_ARGVAR, 0, 1, {CA1_VAR}},
  {"b_var0", B_VAR0, 0, 0, {0}},
  {"b_var1", B_VAR1, 0, 0, {0}},
  {"b_var2", B_VAR2, 0, 0, {0}},
  {"b_var", B_VAR, 0, 1, {CA1_VAR}},
  {"b_unify_firstvar", B_UNIFY_FIRSTVAR, 0, 1, {CA1_VAR}},
  {"b_unify_var", B_UNIFY_VAR, 0, 1, {CA1_VAR}},
  {"b_unify_exit", B_UNIFY_EXIT, VIF_BREAK, 0, {0}},
  {"b_unify_ff", B_UNIFY_FF, VIF_BREAK, 2, {CA1_VAR,CA1_VAR}},
  {"b_unify_fv", B_UNIFY_FV, VIF_BREAK, 2, {CA1_VAR,CA1_VAR}},
  {"b_unify_vv", B_UNIFY_VV, VIF_BREAK, 2, {CA1_VAR,CA1_VAR}},
  {"b_unify_fc", B_UNIFY_FC, VIF_BREAK, 2, {CA1_VAR, CA1_DATA}},
  {"b_unify_vc", B_UNIFY_VC, VIF_BREAK, 2, {CA1_VAR, CA1_DATA}},
  {"b_eq_vv", B_EQ_VV, VIF_BREAK, 2, {CA1_VAR,CA1_VAR}},
  {"b_eq_vc", B_EQ_VC, VIF_BREAK, 2, {CA1_VAR,CA1_DATA}},
  {"b_neq_vv", B_NEQ_VV, VIF_BREAK, 2, {CA1_VAR,CA1_VAR}},
  {"b_neq_vc", B_NEQ_VC, VIF_BREAK, 2, {CA1_VAR,CA1_DATA}},
  {"b_argfirstvar", B_ARGFIRSTVAR, 0, 1, {CA1_VAR}},
  {"b_firstvar", B_FIRSTVAR, 0, 1, {CA1_VAR}},
  {"b_void", B_VOID, 0, 0, {0}},
  {"b_functor", B_FUNCTOR, 0, 1, {CA1_FUNC}},
  {"b_rfunctor", B_RFUNCTOR, 0, 1, {CA1_FUNC}},
  {"b_list", B_LIST, 0, 0, {0}},
  {"b_rlist", B_RLIST, 0, 0, {0}},
  {"b_pop", B_POP, 0, 0, {0}},
  {"i_enter", I_ENTER, VIF_BREAK, 0, {0}},
  {"i_context", I_CONTEXT, 0, 1, {CA1_MODULE}},
  {"i_call", I_CALL, VIF_BREAK, 1, {CA1_PROC}},
  {"i_depart", I_DEPART, VIF_BREAK, 1, {CA1_PROC}},
  {"i_departatm", I_DEPARTATM, VIF_BREAK, 3, {CA1_MODULE, CA1_MODULE, CA1_PROC}},
  {"i_departm", I_DEPARTM, VIF_BREAK, 2, {CA1_MODULE, CA1_PROC}},
  {"i_exit", I_EXIT, VIF_BREAK, 0, {0}},
  {"i_exitfact", I_EXITFACT, 0, 0, {0}},
  {"i_exitquery", I_EXITQUERY, 0, 0, {0}},
  {"i_cut", I_CUT, VIF_BREAK, 0, {0}},
  {"c_jmp", C_JMP, 0, 1, {CA1_JUMP}},
  {"c_or", C_OR, 0, 1, {CA1_JUMP}},
  {"c_softifthen", C_SOFTIFTHEN, 0, 1, {CA1_CHP}},
  {"c_ifthen", C_IFTHEN, 0, 1, {CA1_CHP}},
  {"c_not", C_NOT, 0, 2, {CA1_CHP,CA1_JUMP}},
  {"c_ifthenelse", C_IFTHENELSE, 0, 2, {CA1_CHP,CA1_JUMP}},
  {"c_var", C_VAR, 0, 1, {CA1_VAR}},
  {"c_var_n", C_VAR_N, 0, 2, {CA1_VAR,CA1_INTEGER}},
  {"c_lscut", C_LSCUT, 0, 1, {CA1_CHP}},
  {"c_lcut", C_LCUT, 0, 1, {CA1_CHP}},
  {"i_cutchp", I_CUTCHP, 0, 0, {0}},
  {"c_scut", C_SCUT, 0, 1, {CA1_CHP}},
  {"c_lcutifthen", C_LCUTIFTHEN, 0, 1, {CA1_CHP}},
  {"c_cut", C_CUT, 0, 1, {CA1_CHP}},
  {"c_softif", C_SOFTIF, 0, 2, {CA1_CHP,CA1_JUMP}},
  {"c_softcut", C_SOFTCUT, 0, 1, {CA1_CHP}},
  {"c_end", C_END, 0, 0, {0}},
  {"c_fail", C_FAIL, 0, 0, {0}},
  {"i_fail", I_FAIL, VIF_BREAK, 0, {0}},
  {"i_true", I_TRUE, VIF_BREAK, 0, {0}},
  {"i_var", I_VAR, VIF_BREAK, 1, {CA1_VAR}},
  {"i_nonvar", I_NONVAR, VIF_BREAK, 1, {CA1_VAR}},
  {"s_virgin", S_VIRGIN, 0, 0, {0}},
  {"s_undef", S_UNDEF, 0, 0, {0}},
  {"s_static", S_STATIC, 0, 0, {0}},
  {"s_dynamic", S_DYNAMIC, 0, 0, {0}},
  {"s_thread_local", S_THREAD_LOCAL, 0, 0, {0}},
  {"s_multifile", S_MULTIFILE, 0, 0, {0}},
  {"s_trustme", S_TRUSTME, 0, 1, {CA1_CLAUSEREF}},
  {"s_allclauses", S_ALLCLAUSES, 0, 0, {0}},
  {"s_nextclause", S_NEXTCLAUSE, 0, 0, {0}},
  {"s_list", S_LIST, 0, 2, {CA1_CLAUSEREF, CA1_CLAUSEREF}},
  {"s_mqual", S_MQUAL, 0, 1, {CA1_VAR}},
  {"s_lmqual", S_LMQUAL, 0, 1, {CA1_VAR}},
  {"a_enter", A_ENTER, 0, 0, {0}},
  {"a_integer", A_INTEGER, 0, 1, {CA1_INTEGER}},
  {"a_int64", A_INT64, 0, WORDS_PER_INT64, {CA1_INT64}},
  {"a_mpz", A_MPZ, 0, VM_DYNARGC, {CA1_MPZ}},
  {"a_double", A_DOUBLE, 0, WORDS_PER_DOUBLE, {CA1_FLOAT}},
  {"a_var", A_VAR, 0, 1, {CA1_VAR}},
  {"a_var0", A_VAR0, 0, 0, {0}},
  {"a_var1", A_VAR1, 0, 0, {0}},
  {"a_var2", A_VAR2, 0, 0, {0}},
  {"a_func0", A_FUNC0, 0, 1, {CA1_AFUNC}},
  {"a_func1", A_FUNC1, 0, 1, {CA1_AFUNC}},
  {"a_func2", A_FUNC2, 0, 1, {CA1_AFUNC}},
  {"a_func", A_FUNC, 0, 2, {CA1_AFUNC, CA1_INTEGER}},
  {"a_add", A_ADD, 0, 0, {0}},
  {"a_mul", A_MUL, 0, 0, {0}},
  {"a_add_fc", A_ADD_FC, VIF_BREAK, 3, {CA1_VAR, CA1_VAR, CA1_INTEGER}},
  {"a_lt", A_LT, VIF_BREAK, 0, {0}},
  {"a_le", A_LE, VIF_BREAK, 0, {0}},
  {"a_gt", A_GT, VIF_BREAK, 0, {0}},
  {"a_ge", A_GE, VIF_BREAK, 0, {0}},
  {"a_eq", A_EQ, VIF_BREAK, 0, {0}},
  {"a_ne", A_NE, VIF_BREAK, 0, {0}},
  {"a_is", A_IS, VIF_BREAK, 0, {0}},
  {"a_firstvar_is", A_FIRSTVAR_IS, VIF_BREAK, 1, {CA1_VAR}},
  {"i_fopen", I_FOPEN, 0, 0, {0}},
  {"i_fcalldetva", I_FCALLDETVA, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet0", I_FCALLDET0, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet1", I_FCALLDET1, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet2", I_FCALLDET2, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet3", I_FCALLDET3, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet4", I_FCALLDET4, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet5", I_FCALLDET5, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet6", I_FCALLDET6, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet7", I_FCALLDET7, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet8", I_FCALLDET8, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet9", I_FCALLDET9, 0, 1, {CA1_FOREIGN}},
  {"i_fcalldet10", I_FCALLDET10, 0, 1, {CA1_FOREIGN}},
  {"i_fexitdet", I_FEXITDET, 0, 0, {0}},
  {"i_fopenndet", I_FOPENNDET, 0, 0, {0}},
  {"i_fcallndetva", I_FCALLNDETVA, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet0", I_FCALLNDET0, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet1", I_FCALLNDET1, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet2", I_FCALLNDET2, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet3", I_FCALLNDET3, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet4", I_FCALLNDET4, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet5", I_FCALLNDET5, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet6", I_FCALLNDET6, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet7", I_FCALLNDET7, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet8", I_FCALLNDET8, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet9", I_FCALLNDET9, 0, 1, {CA1_FOREIGN}},
  {"i_fcallndet10", I_FCALLNDET10, 0, 1, {CA1_FOREIGN}},
  {"i_fexitndet", I_FEXITNDET, 0, 0, {0}},
  {"i_fredo", I_FREDO, 0, 0, {0}},
  {"i_callcleanup", I_CALLCLEANUP, 0, 0, {0}},
  {"i_exitcleanup", I_EXITCLEANUP, 0, 0, {0}},
  {"i_catch", I_CATCH, 0, 0, {0}},
  {"i_exitcatch", I_EXITCATCH, VIF_BREAK, 0, {0}},
  {"b_throw", B_THROW, 0, 0, {0}},
  {"i_callatm", I_CALLATM, VIF_BREAK, 3, {CA1_MODULE, CA1_MODULE, CA1_PROC}},
  {"i_departatmv", I_DEPARTATMV, VIF_BREAK, 3, {CA1_MODULE, CA1_VAR, CA1_PROC}},
  {"i_callatmv", I_CALLATMV, VIF_BREAK, 3, {CA1_MODULE, CA1_VAR, CA1_PROC}},
  {"i_callm", I_CALLM, VIF_BREAK, 2, {CA1_MODULE, CA1_PROC}},
  {"i_usercall0", I_USERCALL0, VIF_BREAK, 0, {0}},
  {"i_usercalln", I_USERCALLN, VIF_BREAK, 1, {CA1_INTEGER}},
  { NULL, 0, 0, 0, {0} }
};
