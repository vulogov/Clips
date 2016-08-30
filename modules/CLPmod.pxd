cdef extern from "clips.h":
    struct dataObject:
        void* supplimentalInfo
        unsigned short type
        void* value
        long begin
        long end
        dataObject* next
    ## DATATYPES
    cdef int FLOAT
    cdef int INTEGER
    cdef int SYMBOL
    cdef int STRING
    cdef int MULTIFIELD
    cdef int EXTERNAL_ADDRESS
    cdef int FACT_ADDRESS
    cdef int INSTANCE_NAME
    ctypedef dataObject DATA_OBJECT
    int ArgCountCheck(void* env, char* functionName, int restr, int count)
    int ArgRangeCheck(void* env, char* functionName, int min, int max)
    int RtnArgCount(void* env)
    char*    RtnLexeme(void* env, int argumentPosition)
    double   RtnDouble(void* env, int argumentPosition)
    long     RtnLong(void* env, int argumentPosition)
    void*    RtnUnknown(void* env, int argumentPosition, DATA_OBJECT *data)

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
