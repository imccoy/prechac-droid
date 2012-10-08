#include <stdlib.h>
#include <android/log.h>
#include "jni.h"
#include "SWI-Prolog.h"

#define APPNAME "SwiPrologBridge"

static JavaVM *g_jvm = NULL;
static JNIEnv *g_env = NULL;

jint JNI_OnLoad(JavaVM* vm, void* reserved)
{
    JNIEnv* env;
    jclass cls;
    __android_log_print(ANDROID_LOG_VERBOSE, APPNAME, "Getting env");
    if ((*vm)->GetEnv(vm, (void**)&env, JNI_VERSION_1_6) != JNI_OK) {
        __android_log_print(ANDROID_LOG_ERROR, APPNAME, "Couldn't get env");
        return JNI_ERR;
    }
    g_jvm = vm;
    g_env = env;
    __android_log_print(ANDROID_LOG_VERBOSE, APPNAME, "Got env.");

    return JNI_VERSION_1_6;
}

jint JNI_CreateJavaVM(JavaVM** vm, JNIEnv** env, void* vm_args)
{
    *vm = g_jvm;
    *env = g_env;
    return 0;
}

jint JNI_GetCreatedJavaVMs(JavaVM** vm, jsize n_in, jsize* n_out) {
    *vm = g_jvm;
    *n_out = 1;
    return 0;
}



