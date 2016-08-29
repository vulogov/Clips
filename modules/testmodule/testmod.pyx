cimport CLPmod as clp


cdef public double get_clock(void* env):
    import time
    return time.time()

cdef public double get_number_of_params(void* env):
    #return clp.ArgCountCheck(env, "rtn_args", clp.EXACTLY, 3)
    print "Check params",clp.ArgCountCheck(env, "rtn_args", clp.EXACTLY, 3)
    str_param = clp.RtnLexeme(env, 1)
    float_param = clp.RtnDouble(env, 2)
    int_param = clp.RtnLong(env, 3)
    print repr(str_param),repr(float_param), repr(int_param)
    print repr(float_param+float(int_param))
    return float_param+float(int_param)


cdef public int init_clips_testmod(void* env):
    cdef void* current_env

    if env == NULL:
        return 1
    current_env = env

    return 0

