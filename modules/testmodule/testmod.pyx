cimport CLPmod as clp


cdef public double get_clock(void* env):
    import time
    return time.time()

cdef public int get_number_of_params(void* env):
    return clp.RtnArgCount(env)


cdef public int init_clips_testmod(void* env):
    cdef void* current_env

    if env == NULL:
        return 1
    current_env = env

    return 0

