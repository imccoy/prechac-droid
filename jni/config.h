/* config.h.  Generated from config.h.in by configure.  */
/* config.h.in.  Generated from configure.in by autoheader.  */

/* Define if building universal (internal helper macro) */
/* #undef AC_APPLE_UNIVERSAL_BUILD */

/* The normal alignment of `double', in bytes. */
#define ALIGNOF_DOUBLE 4

/* The normal alignment of `int64_t', in bytes. */
#define ALIGNOF_INT64_T 4

/* The normal alignment of `void*', in bytes. */
#define ALIGNOF_VOIDP 4

/* Define if <assert.h> requires <stdio.h> */
/* #undef ASSERT_H_REQUIRES_STDIO_H */

/* Name of the file to boot from */
#define BOOTFILE "boot32.prc"

/* Define if BSD compatible signals (i.e. no reset when fired) */
#define BSD_SIGNALS 1

/* Define if regular files can be mapped */
#define CAN_MMAP_FILES 1

#undef HAVE_LOCALECONV

/* Define to one of `_getb67', `GETB67', `getb67' for Cray-2 and Cray-YMP
   systems. This function is required for `alloca.c' support on those systems.
   */
/* #undef CRAY_STACKSEG_END */

/* Define to 1 if using `alloca.c'. */
/* #undef C_ALLOCA */

/* Define if you want to use dmalloc */
/* #undef DMALLOC */

/* we have fcntl() and it supports F_SETLKW */
#define FCNTL_LOCKS 1

/* Define to 1 if you have the `access' function. */
#define HAVE_ACCESS 1

/* Define to 1 if you have the `aint' function. */
/* #undef HAVE_AINT */

/* Define to 1 if you have `alloca', as a function or macro. */
#define HAVE_ALLOCA 1

/* Define to 1 if you have <alloca.h> and it should be used (not on Ultrix).
   */
#define HAVE_ALLOCA_H 1

/* Define to 1 if you have the `asctime_r' function. */
#define HAVE_ASCTIME_R 1

/* Define to 1 if you have Boehm GC. */
/* #undef HAVE_BOEHM_GC */

/* Define to 1 if you have the <bstring.h> header file. */
/* #undef HAVE_BSTRING_H */

/* Define to 1 if you have the `ceil' function. */
#define HAVE_CEIL 1

/* Define to 1 if you have the `cfmakeraw' function. */
#define HAVE_CFMAKERAW 1

/* Define to 1 if you have the `chmod' function. */
#define HAVE_CHMOD 1

/* Define to 1 if you have the `clock_gettime' function. */
/* #undef HAVE_CLOCK_GETTIME */

/* Define to 1 if you have the `confstr' function. */
#define HAVE_CONFSTR 1

/* Define to 1 if you have the <crtdbg.h> header file. */
/* #undef HAVE_CRTDBG_H */

/* Define to 1 if you have the <curses.h> header file. */
#define HAVE_CURSES_H 1

/* Define to 1 if you have the <dbghelp.h> header file. */
/* #undef HAVE_DBGHELP_H */

/* Define to 1 if you have the declaration of `mbsnrtowcs', and to 0 if you
   don't. */
#define HAVE_DECL_MBSNRTOWCS 0

/* Define to 1 if you have the declaration of `rl_done', and to 0 if you
   don't. */
/* #undef HAVE_DECL_RL_DONE */

/* Define to 1 if you have the <dirent.h> header file, and it defines `DIR'.
   */
#define HAVE_DIRENT_H 1

/* Define to 1 if you have the `dladdr' function. */
#define HAVE_DLADDR 1

/* Define to 1 if you have the <dlfcn.h> header file. */
#define HAVE_DLFCN_H 1

/* Define if you have a working dlopen() */
#define HAVE_DLOPEN 1

/* Define to 1 if you have the `dossleep' function. */
/* #undef HAVE_DOSSLEEP */

/* Define to 1 if you have the <execinfo.h> header file. */
//#define HAVE_EXECINFO_H 1
#undef HAVE_EXECINFO_H

/* Define to 1 if you have the `fchmod' function. */
#define HAVE_FCHMOD 1

/* Define to 1 if you have the `fcntl' function. */
#define HAVE_FCNTL 1

/* Define to 1 if you have the <floatingpoint.h> header file. */
/* #undef HAVE_FLOATINGPOINT_H */

/* Define to 1 if you have the <float.h> header file. */
#define HAVE_FLOAT_H 1

/* Define to 1 if you have the `floor' function. */
#define HAVE_FLOOR 1

/* Define to 1 if you have the `fork' function. */
#define HAVE_FORK 1

/* Define to 1 if you have the `fpclass' function. */
/* #undef HAVE_FPCLASS */

/* Define to 1 if you have the `fpclassify' function. */
/* #undef HAVE_FPCLASSIFY */

/* Define to 1 if you have the `fpgetmask' function. */
/* #undef HAVE_FPGETMASK */

/* Define to 1 if you have the `fpresetsticky' function. */
/* #undef HAVE_FPRESETSTICKY */

/* Define to 1 if you have the `fstat' function. */
#define HAVE_FSTAT 1

/* Define to 1 if you have the `ftruncate' function. */
#define HAVE_FTRUNCATE 1

/* Define to 1 if you have the `GC_set_flags' function. */
/* #undef HAVE_GC_SET_FLAGS */

/* Define to 1 if you have the `getcwd' function. */
#define HAVE_GETCWD 1

/* Define to 1 if you have the `getpagesize' function. */
#define HAVE_GETPAGESIZE 1

/* Define to 1 if you have the `getpid' function. */
#define HAVE_GETPID 1

/* Define to 1 if you have the `getpwnam' function. */
#define HAVE_GETPWNAM 1

/* Define to 1 if you have the `getrlimit' function. */
#define HAVE_GETRLIMIT 1

/* Define to 1 if you have the `getrusage' function. */
#define HAVE_GETRUSAGE 1

/* Define to 1 if you have the Linux gettid() _syscall0 macro */
/* #undef HAVE_GETTID_MACRO */

/* Define to 1 if you have syscall support for gettid() */
/* #undef HAVE_GETTID_SYSCALL */

/* Define to 1 if you have the `gettimeofday' function. */
#define HAVE_GETTIMEOFDAY 1

/* Define to 1 if you have the `getwd' function. */
#define HAVE_GETWD 1

/* Define to 1 if you have the <gmp.h> header file. */
/* #undef HAVE_GMP_H */

/* Define you you have gmp_randinit_mt (gmp > 4.2.0) */
/* #undef HAVE_GMP_RANDINIT_MT */

/* Define to 1 if you have the `grantpt' function. */
#define HAVE_GRANTPT 1

/* Define to 1 if you have the <ieeefp.h> header file. */
/* #undef HAVE_IEEEFP_H */

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Define to 1 if you have the `isinf' function. */
#define HAVE_ISINF 1

/* Define to 1 if you have the `isnan' function. */
#define HAVE_ISNAN 1

/* Define to 1 if you have the `curses' library (-lcurses). */
/* #undef HAVE_LIBCURSES */

/* Define to 1 if you have the `dl' library (-ldl). */
#define HAVE_LIBDL 1

/* Define to 1 if you have the `dld' library (-ldld). */
/* #undef HAVE_LIBDLD */

/* Define to 1 if you have the `exc' library (-lexc). */
/* #undef HAVE_LIBEXC */

/* Define to 1 if you have the `execinfo' library (-lexecinfo). */
#undef HAVE_LIBEXECINFO

/* Define to 1 if you have the `m' library (-lm). */
#define HAVE_LIBM 1

/* Define to 1 if you have the `ncurses' library (-lncurses). */
#define HAVE_LIBNCURSES 1

/* Define to 1 if you have the `ncursesw' library (-lncursesw). */
/* #undef HAVE_LIBNCURSESW */

/* Define to 1 if you have the `pthread' library (-lpthread). */
/* #undef HAVE_LIBPTHREAD */

/* Define to 1 if you have the `pthreadGC' library (-lpthreadGC). */
/* #undef HAVE_LIBPTHREADGC */

/* Define to 1 if you have the `pthreadGC2' library (-lpthreadGC2). */
/* #undef HAVE_LIBPTHREADGC2 */

/* Define to 1 if you have the `readline' library (-lreadline). */
#undef HAVE_LIBREADLINE

/* Define to 1 if you have the `rt' library (-lrt). */
/* #undef HAVE_LIBRT */

/* Define to 1 if you have the `shell32' library (-lshell32). */
/* #undef HAVE_LIBSHELL32 */

/* Define to 1 if you have the `termcap' library (-ltermcap). */
/* #undef HAVE_LIBTERMCAP */

/* Define to 1 if you have the `thread' library (-lthread). */
/* #undef HAVE_LIBTHREAD */

/* Define to 1 if you have the `ucb' library (-lucb). */
/* #undef HAVE_LIBUCB */

/* Define if you have libunwind and libunwind.h */
/* #undef HAVE_LIBUNWIND */

/* Define to 1 if you have the `winmm' library (-lwinmm). */
/* #undef HAVE_LIBWINMM */

/* Define to 1 if you have the `wsock32' library (-lwsock32). */
/* #undef HAVE_LIBWSOCK32 */

/* Define to 1 if you have the <locale.h> header file. */
#define HAVE_LOCALE_H 1

/* Define to 1 if you have the `localtime_r' function. */
#define HAVE_LOCALTIME_R 1

/* Define to 1 if you have the `localtime_s' function. */
/* #undef HAVE_LOCALTIME_S */

/* Define to 1 if you have the <mach-o/rld.h> header file. */
/* #undef HAVE_MACH_O_RLD_H */

/* Define to 1 if you have the <mach/thread_act.h> header file. */
/* #define HAVE_MACH_THREAD_ACT_H 1 */

/* Define to 1 if you have the `mallinfo' function. */
/* #undef HAVE_MALLINFO */

/* Define to 1 if you have the <malloc.h> header file. */
/* #undef HAVE_MALLOC_H */

/* Define to 1 if you have the `mbscasecoll' function. */
/* #undef HAVE_MBSCASECOLL */

/* Define to 1 if you have the `mbscoll' function. */
/* #undef HAVE_MBSCOLL */

/* Define to 1 if you have the `mbsnrtowcs' function. */
// #define HAVE_MBSNRTOWCS 1
#undef HAVE_MBSNRTOWCS

/* Define to 1 if you have the `memmove' function. */
#define HAVE_MEMMOVE 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the `mmap' function. */
#define HAVE_MMAP 1

/* Define to 1 if you have the `mtrace' function. */
/* #undef HAVE_MTRACE */

/* Define to 1 if you have the `nanosleep' function. */
#define HAVE_NANOSLEEP 1

/* Define to 1 if you have the <ncurses/curses.h> header file. */
/* #undef HAVE_NCURSES_CURSES_H */

/* Define to 1 if you have the <ncurses/term.h> header file. */
/* #undef HAVE_NCURSES_TERM_H */

/* Define to 1 if you have the <ndir.h> header file, and it defines `DIR'. */
/* #undef HAVE_NDIR_H */

/* Define to 1 if you have the `opendir' function. */
#define HAVE_OPENDIR 1

/* Define to 1 if you have the `popen' function. */
#define HAVE_POPEN 1

/* Define to 1 if you have the `posix_openpt' function. */
#define HAVE_POSIX_OPENPT 1

/* Define to 1 if you have the `pthread_kill' function. */
#define HAVE_PTHREAD_KILL 1

/* Define to 1 if you have the `pthread_mutexattr_setkind_np' function. */
/* #undef HAVE_PTHREAD_MUTEXATTR_SETKIND_NP */

/* Define to 1 if you have the `pthread_mutexattr_settype' function. */
#define HAVE_PTHREAD_MUTEXATTR_SETTYPE 1

/* Define to 1 if you have the `pthread_setconcurrency' function. */
#undef HAVE_PTHREAD_SETCONCURRENCY

/* Define to 1 if you have the `pthread_sigmask' function. */
#define HAVE_PTHREAD_SIGMASK 1

/* Define to 1 if you have the `putenv' function. */
#define HAVE_PUTENV 1

/* Define to 1 if you have the <pwd.h> header file. */
#define HAVE_PWD_H 1

/* Define to 1 if you have the `random' function. */
#define HAVE_RANDOM 1

/* Define to 1 if you have the <readline/history.h> header file. */
/* #undef HAVE_READLINE_HISTORY_H */

/* Define to 1 if you have the <readline/readline.h> header file. */
/* #undef HAVE_READLINE_READLINE_H */

/* Define to 1 if you have the `readlink' function. */
#define HAVE_READLINK 1

/* Define to 1 if you have the `remove' function. */
#define HAVE_REMOVE 1

/* Define to 1 if you have the `rename' function. */
#define HAVE_RENAME 1

/* Define to 1 if you have the `rint' function. */
#define HAVE_RINT 1

/* Define if the type rlim_t is defined by <sys/resource.h> */
#define HAVE_RLIM_T 1

/* Define to 1 if you have the `rl_cleanup_after_signal' function. */
/* #undef HAVE_RL_CLEANUP_AFTER_SIGNAL */

/* Define to 1 if you have the `rl_clear_pending_input' function. */
/* #undef HAVE_RL_CLEAR_PENDING_INPUT */

/* Define to 1 if you have the `rl_completion_matches' function. */
/* #undef HAVE_RL_COMPLETION_MATCHES */

/* Define to 1 if libreadline has the `rl_done' variable. */
/* #undef HAVE_RL_DONE */

/* Define to 1 if libreadline has the `rl_event_hook' variable. */
/* #undef HAVE_RL_EVENT_HOOK */

/* Define to 1 if you have the `rl_filename_completion_function' function. */
/* #undef HAVE_RL_FILENAME_COMPLETION_FUNCTION */

/* Define to 1 if you have the `rl_insert_close' function. */
/* #undef HAVE_RL_INSERT_CLOSE */

/* Define to 1 if libreadline has the `rl_readline_state' variable. */
/* #undef HAVE_RL_READLINE_STATE */

/* Define to 1 if you have the `rl_set_keyboard_input_timeout' function. */
/* #undef HAVE_RL_SET_KEYBOARD_INPUT_TIMEOUT */

/* Define to 1 if you have the `rl_set_prompt' function. */
/* #undef HAVE_RL_SET_PROMPT */

/* Define if struct rusage contains the field ru_idrss */
#define HAVE_RU_IDRSS 1

/* Define if you have sysconf support for _SC_NPROCESSORS_CONF */
#define HAVE_SC_NPROCESSORS_CONF 1

/* Define to 1 if you have the `select' function. */
#define HAVE_SELECT 1

/* Define to 1 if you have the `sema_init' function. */
/* #undef HAVE_SEMA_INIT */

/* Define to 1 if you have the `sem_init' function. */
#define HAVE_SEM_INIT 1

/* Define to 1 if you have the `setenv' function. */
#define HAVE_SETENV 1

/* Define to 1 if you have the `setlocale' function. */
#define HAVE_SETLOCALE 1

/* Define if you don't have termio(s), but struct sgttyb */
/* #undef HAVE_SGTTYB */

/* Define to 1 if you have the <shlobj.h> header file. */
/* #undef HAVE_SHLOBJ_H */

/* Define to 1 if you have the `shl_load' function. */
/* #undef HAVE_SHL_LOAD */

/* Define to 1 if you have the `sigaction' function. */
#define HAVE_SIGACTION 1

/* Define to 1 if you have the `sigblock' function. */
#define HAVE_SIGBLOCK 1

/* Define to 1 if you have the `siggetmask' function. */
/* #undef HAVE_SIGGETMASK */

/* Define if signal handler is compliant to POSIX.1b */
#define HAVE_SIGINFO 1

/* Define to 1 if you have the <siginfo.h> header file. */
/* #undef HAVE_SIGINFO_H */

/* Define to 1 if you have the `signal' function. */
#define HAVE_SIGNAL 1

/* Define if you have signbit */
#define HAVE_SIGNBIT 1

/* Define to 1 if you have the `sigprocmask' function. */
#define HAVE_SIGPROCMASK 1

/* Define to 1 if you have the `sigset' function. */
#define HAVE_SIGSET 1

/* Define to 1 if you have the `sigsetmask' function. */
#define HAVE_SIGSETMASK 1

/* Define to 1 if you have the `sleep' function. */
#define HAVE_SLEEP 1

/* Define to 1 if you have the `srand' function. */
#define HAVE_SRAND 1

/* Define to 1 if you have the `srandom' function. */
#define HAVE_SRANDOM 1

/* Define to 1 if you have the `stat' function. */
#define HAVE_STAT 1

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the `strcasecmp' function. */
#define HAVE_STRCASECMP 1

/* Define to 1 if you have the `strerror' function. */
#define HAVE_STRERROR 1

/* Define to 1 if you have the `stricmp' function. */
/* #undef HAVE_STRICMP */

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the `strlwr' function. */
/* #undef HAVE_STRLWR */

/* Define is struct tm has tm_gmtoff */
#define HAVE_STRUCT_TIME_TM_GMTOFF 

/* Define to 1 if you have the <SupportDefs.h> header file. */
/* #undef HAVE_SUPPORTDEFS_H */

/* Define if the ln command supports -s */
#define HAVE_SYMLINKS 1

/* Define to 1 if you have the `syscall' function. */
#define HAVE_SYSCALL 1

/* Define to 1 if you have the `sysconf' function. */
#define HAVE_SYSCONF 1

/* Define to 1 if you have the `sysctlbyname' function. */
#define HAVE_SYSCTLBYNAME 1

/* Define to 1 if you have the <sys/dir.h> header file, and it defines `DIR'.
   */
/* #undef HAVE_SYS_DIR_H */

/* Define to 1 if you have the <sys/file.h> header file. */
#define HAVE_SYS_FILE_H 1

/* Define to 1 if you have the <sys/mman.h> header file. */
#define HAVE_SYS_MMAN_H 1

/* Define to 1 if you have the <sys/ndir.h> header file, and it defines `DIR'.
   */
/* #undef HAVE_SYS_NDIR_H */

/* Define to 1 if you have the <sys/param.h> header file. */
#define HAVE_SYS_PARAM_H 1

/* Define to 1 if you have the <sys/resource.h> header file. */
#define HAVE_SYS_RESOURCE_H 1

/* Define to 1 if you have the <sys/select.h> header file. */
#define HAVE_SYS_SELECT_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/stropts.h> header file. */
/* #undef HAVE_SYS_STROPTS_H */

/* Define to 1 if you have the <sys/syscall.h> header file. */
#define HAVE_SYS_SYSCALL_H 1

/* Define to 1 if you have the <sys/termios.h> header file. */
#define HAVE_SYS_TERMIOS_H 1

/* Define to 1 if you have the <sys/termio.h> header file. */
/* #undef HAVE_SYS_TERMIO_H */

/* Define to 1 if you have the <sys/time.h> header file. */
#define HAVE_SYS_TIME_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have <sys/wait.h> that is POSIX.1 compatible. */
#define HAVE_SYS_WAIT_H 1

/* Define to 1 if you have the `tcsetattr' function. */
#define HAVE_TCSETATTR 1

/* Define to 1 if you have the <term.h> header file. */
#define HAVE_TERM_H 1

/* Define to 1 if you have the `tgetent' function. */
#define HAVE_TGETENT 1

/* Define to 1 if you have the `times' function. */
#define HAVE_TIMES 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to 1 if you have the `unsetenv' function. */
#define HAVE_UNSETENV 1

/* Define to 1 if you have the `usleep' function. */
#define HAVE_USLEEP 1

/* Define if tzset sets timezone variable */
#define HAVE_VAR_TIMEZONE 1

/* Define to 1 if you have the `vfork' function. */
#define HAVE_VFORK 1

/* Define to 1 if you have the <vfork.h> header file. */
/* #undef HAVE_VFORK_H */

/* Define if __attribute__ visibility is supported */
/* #undef HAVE_VISIBILITY_ATTRIBUTE */

/* Define to 1 if you have the `waitpid' function. */
#define HAVE_WAITPID 1

/* Define to 1 if you have the <wchar.h> header file. */
#define HAVE_WCHAR_H 1

/* Define to 1 if you have the `wcsdup' function. */
/* #undef HAVE_WCSDUP */

/* Define to 1 if you have the `wcsxfrm' function. */
#define HAVE_WCSXFRM 1

/* Define to 1 if you have the <winsock2.h> header file. */
/* #undef HAVE_WINSOCK2_H */

/* Define to 1 if `fork' works. */
#define HAVE_WORKING_FORK 1

/* Define to 1 if `vfork' works. */
#define HAVE_WORKING_VFORK 1

/* Define if you have __builtin_clz */
#define HAVE__BUILTIN_CLZ 1

/* Define if you have __sync_synchronize */
#define HAVE__SYNC_SYNCHRONIZE 1

/* Define if int64_t cannot be aligned as pointers */
/* #undef INT64_ALIGNMENT */

/* printf format for int64_t datatype */
#define INT64_FORMAT "%lld"

/* String used to prefix all symbols requested through dlsym() */
#define LD_SYMBOL_PREFIX "_"

/* Define if you have Linux cpu clocks (2.6.12 and greater) */
/* #undef LINUX_CPUCLOCKS */

/* Define if you have Linux 2.6 compatible /proc */
/* #undef LINUX_PROCFS */

/* Define if, in addition to <errno.h>, extern int errno; is needed */
/* #undef NEED_DECL_ERRNO */

/* Define if uchar is not defined in <sys/types.h> */
#define NEED_UCHAR 1

/* Define if it is allowed to access intptr_t integers with non-aligned
   pointers */
/* #undef NON_ALIGNED_ACCESS */

/* "Define if you can't use asm("nop") to separate two labels" */
/* #undef NO_ASM_NOP */

/* Define if <sys/ioctl> should *not* be included after <sys/termios.h> */
/* #undef NO_SYS_IOCTL_H_WITH_SYS_TERMIOS_H */

/* Define to 1 if &&label and goto *var is supported (GCC-2) */
#define O_LABEL_ADDRESSES 1

/* Define to include support for multi-threading */
#define O_PLMT 1

/* Define if SIGPROF and setitimer() are available */
#define O_PROFILE 1

/* "Define if Prolog kernel is in shared object" */
#define O_SHARED_KERNEL 1

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT ""

/* Define to the full name of this package. */
#define PACKAGE_NAME ""

/* Define to the full name and version of this package. */
#define PACKAGE_STRING ""

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME ""

/* Define to the home page for this package. */
#define PACKAGE_URL ""

/* Define to the version of this package. */
#define PACKAGE_VERSION ""

/* Define if you have Linux compatible /proc/cpuinfo */
/* #undef PROCFS_CPUINFO */

/* Program to run the C preprocessor */
#define PROG_CPP "gcc -E"

/* Name of the SWI-Prolog executable (normally swipl[.exe]) */
#define PROG_PL "swipl"

/* Define if you have pthread cpu clocks (glibc 2.4 and greater) */
/* #undef PTHREAD_CPUCLOCKS */

/* Define to make use of standard (UNIX98) pthread recursive mutexes */
#define RECURSIVE_MUTEXES 1

/* Define as the return type of signal handlers (`int' or `void'). */
#define RETSIGTYPE void

/* breaks arguments */
#define SCRIPT_BREAKDOWN_ARGS 1

/* The size of `int', as computed by sizeof. */
#define SIZEOF_INT 4

/* The size of `long', as computed by sizeof. */
#define SIZEOF_LONG 4

/* The size of `long long', as computed by sizeof. */
#define SIZEOF_LONG_LONG 8

/* The size of `void*', as computed by sizeof. */
#define SIZEOF_VOIDP 4

/* The size of `wchar_t', as computed by sizeof. */
#define SIZEOF_WCHAR_T 4

/* Define to the extension of shared objects (often .so) */
#define SO_EXT "so"

/* Program to link shared objects */
#define SO_LD "gcc"

/* Flags to use for linking shared objects */
#define SO_LDFLAGS "-bundle -dynamic -flat_namespace -undefined suppress"

/* Search path for shared objects (often LD_LIBRARY_PATH) */
#define SO_PATH "DYLD_LIBRARY_PATH"

/* Flags for compiling position-independent BIG object */
#define SO_PIC "-fno-common"

/* Flags for compiling position-independent small object */
#define SO_pic "-fno-common"

/* If using the C implementation of alloca, define if you know the
   direction of stack growth for your system; otherwise it will be
   automatically deduced at runtime.
	STACK_DIRECTION > 0 => grows toward higher addresses
	STACK_DIRECTION < 0 => grows toward lower addresses
	STACK_DIRECTION = 0 => direction of growth unknown */
/* #undef STACK_DIRECTION */

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Define if (type)var = value is allowed */
#define TAGGED_LVALUE 1

/* Define to 1 if you can safely include both <sys/time.h> and <time.h>. */
#define TIME_WITH_SYS_TIME 1

/* Define if wait() uses union wait */
#define UNION_WAIT 1

/* Define if we must use sem_open() instead of the preferred sem_init() */
#define USE_SEM_OPEN 1

/* Define if unsetenv() is void */
/* #undef VOID_UNSETENV */

/* Define to 1 if your processor stores words with the most significant byte
   first (like Motorola and SPARC, unlike Intel and VAX). */
/* #undef WORDS_BIGENDIAN */

/* Number of bits in a file offset, on hosts where this is settable. */
/* #undef _FILE_OFFSET_BITS */

/* Define for large files, on AIX-style hosts. */
/* #undef _LARGE_FILES */

/* Required in FreeBSD for compiling thread-safe code */
/* #undef _THREAD_SAFE */

/* Define to `__inline__' or `__inline' if that's what the C compiler
   calls it, or to nothing if 'inline' is not supported under any name.  */
#ifndef __cplusplus
/* #undef inline */
#endif

/* Define to `int' if <sys/types.h> does not define. */
/* #undef pid_t */

/* Define to `unsigned int' if <sys/types.h> does not define. */
/* #undef size_t */

/* Define as `fork' if `vfork' does not work. */
/* #undef vfork */
