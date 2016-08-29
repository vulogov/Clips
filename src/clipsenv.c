#include <dlfcn.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "clips.h"

void aaa(void* env, DATA_OBJECT* ret) {
    SetpType(ret, FLOAT);
    SetpValue(ret, AddDouble(env, 0.0));
}

void* dl(void* env) {
    int res;
    void* handle;
    DATA_OBJECT temp;
    DATA_OBJECT temp2;
    char* fname;
    char* modname;
    char  modsym[4096];
    char* error;
    void (*initmod)(void);
    int (*init_fun)(void*);
    dlerror();

    if (ArgCountCheck(env, "dl", EXACTLY, 2) == -1)
        return (void*)(NULL);
    if (ArgTypeCheck(env, "dl",2,STRING,&temp) == 0)
        return (void*)(NULL);
    if (ArgTypeCheck(env, "dl",1,STRING,&temp2) == 0)
        return (void*)(NULL);
    if ((fname = DOToString(temp)) == NULL)
        return (void*)(NULL);
    if ((modname = DOToString(temp2)) == NULL)
        return (void*)(NULL);
    if ((handle = dlopen(fname, RTLD_NOW)) == NULL) {
        error = dlerror();
        return (void*)(NULL);
    }
    snprintf(modsym, 4095, "init%s", modname);
    initmod = dlsym(handle, modsym);
    if ((error = dlerror()) != NULL) {
        dlclose(handle);
        return (void*)(NULL);
    }
    if (initmod == NULL)
        return (void*)(NULL);
    (*initmod)();
    snprintf(modsym, 4095, "init_clips_%s", modname);
    init_fun = dlsym(handle, modsym);
    if (init_fun == NULL)
        return (void*)(NULL);
    res = (*init_fun)(env);
    if (res == 1)
        return (void*)(NULL);
    return (void*)(handle);
}

void* dl_sym(void* env) {
    DATA_OBJECT temp;
    DATA_OBJECT temp2;
    void (*ffun)(void*);
    char *fun_name;
    char *error;

    if (ArgCountCheck(env, "dlsym", EXACTLY, 2) == -1)
        return (void*)(NULL);
    if (ArgTypeCheck(env, "dlsym",1,EXTERNAL_ADDRESS,&temp) == 0)
        return (void*)(NULL);
    if (ArgTypeCheck(env, "dlsym",2,STRING,&temp2) == 0)
        return (void*)(NULL);
    if ((fun_name = DOToString(temp2)) == NULL)
        return (void*)(NULL);
    dlerror();
    if (temp.value == NULL)
        return (void*)(NULL);
    ffun = dlsym(temp.value, fun_name);
    if ((error = dlerror()) != NULL)
        return (void*)(NULL);
    return ffun;
}

int dl_register(void* env) {
    DATA_OBJECT temp;
    DATA_OBJECT temp2;
    DATA_OBJECT temp3;
    DATA_OBJECT temp4;
    char* fname;
    char* param;
    char* retval;

    if (ArgCountCheck(env, "dlregister", EXACTLY, 4) == -1)
        return (FALSE);
    if (ArgTypeCheck(env, "dlregister",1,EXTERNAL_ADDRESS,&temp) == 0)
        return (FALSE);
    if (temp.value == NULL)
        return (FALSE);
    if (ArgTypeCheck(env, "dlregister",2,STRING,&temp2) == 0)
        return (FALSE);
    if ((fname = DOToString(temp2)) == NULL)
        return (FALSE);
    if (ArgTypeCheck(env, "dlregister",3,STRING,&temp3) == 0)
        return (FALSE);
    if ((param = DOToString(temp3)) == NULL)
        return (FALSE);
    if (ArgTypeCheck(env, "dlregister",4,STRING,&temp4) == 0)
        return (FALSE);
    if ((retval = DOToString(temp4)) == NULL)
        return (FALSE);
    EnvDefineFunction2(env, fname, retval[0], PTIEF temp.value, fname, param);
    return (TRUE);
}

int dl_close(void* env) {
    DATA_OBJECT temp;

    if (ArgCountCheck(env, "dlclose", EXACTLY, 1) == -1)
        return (FALSE);
    if (ArgTypeCheck(env, "dlclose",1,EXTERNAL_ADDRESS,&temp) == 0)
        return (FALSE);
    if (temp.value == NULL)
        return (FALSE);
    dlerror();
    dlclose(temp.value);
    return (TRUE);
}


int is_dir(void* env) {
    struct stat statbuf;
    DATA_OBJECT temp;
    char* path;

    if (ArgCountCheck(env, "is_dir", EXACTLY, 1) == -1)
        return (FALSE);
    if (ArgTypeCheck(env, "is_dir",1,STRING,&temp) == 0)
        return (FALSE);
    if ((path = DOToString(temp)) == NULL)
        return (FALSE);
    if (stat(path, &statbuf) != 0)
        return (FALSE);
    if (S_ISDIR(statbuf.st_mode))
        return (TRUE);
    return (FALSE);
}

int is_file(void* env) {
    struct stat statbuf;
    DATA_OBJECT temp;
    char* path;

    if (ArgCountCheck(env, "is_file", EXACTLY, 1) == -1)
        return (FALSE);
    if (ArgTypeCheck(env, "is_file",1,STRING,&temp) == 0)
        return (FALSE);
    if ((path = DOToString(temp)) == NULL)
        return (FALSE);
    if (stat(path, &statbuf) != 0)
        return (FALSE);
    if (S_ISREG(statbuf.st_mode))
        return (TRUE);
    return (FALSE);
}


void EnvUserFunctions(void *env) {
    EnvDefineFunction2(env, "dl", 'a', PTIEF dl, "dl", "2s");
    EnvDefineFunction2(env, "dlsym", 'a', PTIEF dl_sym, "dlsym", "as");
    EnvDefineFunction2(env, "dlregister", 'b', PTIEF dl_register, "dlregister", "asss");
    EnvDefineFunction2(env, "dlclose", 'b', PTIEF dl_close, "dlclose", "a");
    EnvDefineFunction2(env, "is_dir", 'b', PTIEF is_dir, "is_dir", "s");
    EnvDefineFunction2(env, "is_file", 'b', PTIEF is_file, "is_file", "s");

}

void UserFunctions(void *env) {

}