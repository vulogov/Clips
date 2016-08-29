cdef extern from "clips.h":
    int ArgCountCheck(void* env, char* functionName, int restr, int count)
    int ArgRangeCheck(void* env, char* functionName, int min, int max)
    int RtnArgCount(void* env)
    char    *RtnLexeme(void* env, int argumentPosition)
    double   RtnDouble(void* env, int argumentPosition)
    long     RtnLong(void* env, int argumentPosition)

    ## DATATYPES
    cdef int FLOAT
    cdef int INTEGER
    cdef int SYMBOL
    cdef int STRING
    cdef int MULTIFIELD
    cdef int EXTERNAL_ADDRESS
    cdef int FACT_ADDRESS
    cdef int INSTANCE_NAME

    ## Constraint
    cdef int EXACTLY
    cdef int AT_LEAST
    cdef int NO_MORE_THAN
    cdef int RANGE
