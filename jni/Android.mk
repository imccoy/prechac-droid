LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SHARED_LIBRARIES := gmp
LOCAL_MODULE    := swi-pl
LOCAL_SRC_FILES := pl-arith.c pl-atom.c pl-attvar.c pl-bag.c pl-beos.c pl-btree.c pl-codetable.c pl-comp.c pl-copyterm.c pl-dbref.c pl-dde.c pl-debug.c pl-dwim.c pl-error.c pl-ext.c pl-flag.c pl-funct.c pl-gc.c pl-gmp.c pl-gvar.c pl-hash.c pl-init.c pl-list.c pl-load.c pl-modul.c pl-op.c pl-prims.c pl-privitf.c pl-pro.c pl-proc.c pl-prof.c pl-rc.c pl-read.c pl-rec.c pl-segstack.c pl-setup.c pl-supervisor.c pl-sys.c pl-thread.c pl-trace.c pl-util.c pl-variant.c pl-version.c pl-wam.c pl-wic.c pl-write.c os/pl-buffer.c os/pl-codelist.c os/pl-cstack.c os/pl-ctype.c os/pl-dtoa.c os/pl-file.c os/pl-files.c os/pl-fmt.c os/pl-glob.c os/pl-option.c os/pl-os.c os/pl-prologflag.c os/pl-stream.c os/pl-string.c os/pl-table.c os/pl-text.c os/pl-utf8.c rc/access.c rc/build.c rc/html.c rc/rc.c rc/util.c

include $(BUILD_SHARED_LIBRARY)

