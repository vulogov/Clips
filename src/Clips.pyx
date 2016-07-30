__author__ = 'Vladimir Ulogov'

import os
import uuid
from cpython.mem cimport PyMem_Malloc, PyMem_Realloc, PyMem_Free


cdef extern from "clips.h":
    struct dataObject:
        void* supplimentalInfo
        unsigned short type
        void* value
        long begin
        long end
        dataObject* next
    ctypedef dataObject DATA_OBJECT
    ## DATATYPES
    cdef int FLOAT
    cdef int INTEGER
    cdef int SYMBOL
    cdef int STRING
    cdef int MULTIFIELD
    cdef int EXTERNAL_ADDRESS
    cdef int FACT_ADDRESS
    cdef int INSTANCE_NAME
    ## STRATEGY
    cdef int DEPTH_STRATEGY
    cdef int BREADTH_STRATEGY
    cdef int LEX_STRATEGY
    cdef int MEA_STRATEGY
    cdef int COMPLEXITY_STRATEGY
    cdef int SIMPLICITY_STRATEGY
    cdef int RANDOM_STRATEGY





#FLOAT=FLOAT
#INTEGER=INTEGER
#SYMBOL=SYMBOL
#STRING=STRING
#MULTIFIELD=MULTIFIELD
#EXTERNAL_ADDRESS=EXTERNAL_ADDRESS
#FACT_ADDRESS=FACT_ADDRESS
#INSTANCE_NAME=INSTANCE_NAME


_DEPTH_STRATEGY=DEPTH_STRATEGY
_BREADTH_STRATEGY=BREADTH_STRATEGY
_LEX_STRATEGY=LEX_STRATEGY
_MEA_STRATEGY=MEA_STRATEGY
_COMPLEXITY_STRATEGY=COMPLEXITY_STRATEGY
_SIMPLICITY_STRATEGY=SIMPLICITY_STRATEGY
_RANDOM_STRATEGY=RANDOM_STRATEGY




class EvalError(RuntimeError):
    pass
class ShellError(RuntimeError):
    pass



cdef extern from "clips.h":
    ## Datatypes
    char  *ValueToString(void* value)
    double ValueToDouble(void* value)
    long   ValueToLong(void* value)
    int    ValueToInteger(void* value)
    int    GetDOLength(DATA_OBJECT argument)
    int    GetMFType(void* multifieldPtr,int fieldPosition)
    void*  GetMFValue(void* multifieldPtr,int fieldPosition)
    ## Work with Environment
    void* CreateEnvironment()
    int   DeallocateEnvironmentData()
    int   DestroyEnvironment(void* theEnv)
    void  Clear(void* env)
    void  Reset(void* env)
    int   Load(void* env, char* name)
    int   Build(void* env, char* constructString)
    long int Run(void* env, long runLimit)
    int   SetStrategy(void* env, int value)
    int   GetStrategy(void* env)

    ## Work with modules
    void *GetCurrentModule(void* env)
    void *SetCurrentModule(void* env, void* defmodulePtr)
    void *FindDefmodule(void* env, char* defmoduleName)
    char *GetDefmoduleName(void* env, void* defmodulePtr)
    char *GetDefmodulePPForm(void* env, void* defmodulePtr)
    ## Work with Facts
    void *AssertString(void* env, char* fact)
    int   LoadFactsFromString(void* env, char* nputString,int maximumPosition)
    void PPFact(void* factPtr,char* logicalName,int ignoreDefaultFlag)
    void  GetFactPPForm(void* env, char* buffer,int bufferLength,void* factPtr)
    void IncrementFactCount(void* env, void* fact)
    void DecrementFactCount(void* env, void* fact)
    long  FactExistp(void* env, void* factPtr);
    void *GetNextFact(void* env, void* factPtr);
    int  Retract(void* env, void* factPtr)
    int GetFactListChanged(void* env)
    void SetFactListChanged(void* env, int changedFlag)
    void FactSlotNames(void* env, void* factPtr, DATA_OBJECT* theValue)
    ## Work with evaluations
    int Eval(void* env, char* expressionString, DATA_OBJECT* result)



def exists_and_can_read(fname):
    import posixpath
    _path = posixpath.abspath(fname)
    if posixpath.exists(_path) and posixpath.isfile(_path) and posixpath.getsize(_path) > 0:
        if os.access(_path, os.R_OK):
            return _path
    return None

cdef clp2py(DATA_OBJECT data):
    if data.type == FLOAT:
        return ValueToDouble(<void*>data.value)
    elif data.type == INTEGER:
        return ValueToLong(<void*>data.value)
    elif data.type in [SYMBOL, STRING]:
        return ValueToString(<void*>data.value)
    elif data.type == MULTIFIELD:
        res = []
        for v in range(1,GetDOLength(<DATA_OBJECT>data)+1):
            _t = GetMFType(<void*>data.value,v)
            if _t == FLOAT:
                res.append(ValueToDouble(<void*>GetMFValue(<void*>data.value, v)))
            elif _t == INTEGER:
                res.append(ValueToLong(<void*>GetMFValue(<void*>data.value, v)))
            elif _t in [SYMBOL, STRING]:
                res.append(ValueToString(<void*>GetMFValue(<void*>data.value, v)))
        return res
    else:
        return None


cdef class SHELL:
    cdef void* env
    cdef object ready
    def __cinit__(self):
        self.ready=False
        self.env = NULL
    cdef create(self, void* env):
        if env != NULL:
            self.env = env
            self.ready = True

    def STRATEGY(self, stra=None):
        if stra != None:
            SetStrategy(<void*>self.env, stra)
            return stra
        else:
            return GetStrategy(<void*>self.env)

    def EVAL(self, cmd):
        cdef DATA_OBJECT res

        if self.ready != True:
            raise EvalError,"SHELL() is not ready"

        try:
            if Eval(<void*>self.env, cmd, &res) == 1:
                return clp2py(res)
        except:
            raise EvalError,"Error in: %s"%cmd
        raise EvalError,"Error in: %s"%cmd
    def RUN(self, limit=-1):
        if self.ready != True:
            raise ShellError(),"SHELL() is not ready"
        return Run(<void*>self.env, limit)


cdef class FACT:
    cdef void* env
    cdef void* fact
    cdef object ready
    def __cinit__(self):
        self.ready = False
    cdef create(self, void* env, void* fact):
        self.env = env
        self.fact = fact
        if self.env != NULL and self.fact != NULL:
            self.ready = True
            IncrementFactCount(self.env, self.fact)
    def Print(self):
        cdef char* buf;
        buf = <char*> PyMem_Malloc(4096)
        GetFactPPForm(<void*>self.env, <char*>buf, 4096, <void*>self.fact)
        return buf
    def __repr__(self):
        return self.Print()
    def EXISTS(self):
        if FactExistp(<void*>self.env, <void*>self.fact) == 1:
            return True
        return False
    def RETRACT(self):
        if Retract(<void*>self.env, <void*>self.fact) == 1:
            DecrementFactCount(<void*>self.env, <void*>self.fact)
            return True
        return False
    def KEYS(self):
        cdef DATA_OBJECT slots
        cdef void* val
        FactSlotNames(<void*>self.env, <void*>self.fact, &slots)
        if slots.type != MULTIFIELD:
            raise ValueError,"Expected MULTIFIELD, acquired %d"%slots.type
        out = []
        for i in  range(1,GetDOLength(<DATA_OBJECT>slots)+1):
            if GetMFType(<void*>slots.value, i) not in  [SYMBOL, STRING]:
                continue
            val = GetMFValue(<void*>slots.value, i)
            if val == NULL:
                continue
            out.append(ValueToString(val))
        return out
    def __getitem__(self, key):
        keys = self.KEYS()
        if key not in keys:
            raise KeyError,key
        ix = keys.index(key)+1
    def __dealloc__(self):
        if self.ready == True:
            DecrementFactCount(self.env, self.fact)

cdef class MODULE:
    cdef void* module
    cdef void* env
    cdef object ready
    def __cinit__(self):
        self.ready=False
    cdef create(self, void* env, void*  module):
        self.env = env
        self.module = module
        if self.module != NULL or self.env != NULL:
            self.ready = True
    def currentModule(self):
        if self.ready == True:
            SetCurrentModule(<void*>self.env, <void*>self.module)
            return True
        else:
            return False
    def __repr__(self):
        if self.ready == True:
            return "CLIPSMODULE(%s)"%GetDefmoduleName(<void*>self.env, <void*>self.module)
        else:
            return "CLIPSMODULE(UNKNOWN)"
    def Print(self):
        if self.ready == True:
            pp_out = GetDefmodulePPForm(<void*>self.env, <void*>self.module)
            if pp_out != NULL:
                return pp_out
            else:
                return ""
        else:
            return ""


cdef class FACTS:
    cdef void* env
    cdef object ready
    cdef object transactions
    def __cinit__(self):
        self.ready=False
        self.env = NULL
        self.transactions = {}
    cdef create(self, void* env):
        if env != NULL:
            self.env = env
            self.ready = True
    def FACTS(self):
        f = GetNextFact(<void*>self.env, NULL)
        if f == NULL:
            return []
        fact = FACT()
        fact.create(<void*>self.env, <void*>f)
        res = [fact,]
        while True:
            f = GetNextFact(<void*>self.env, <void*>f)
            if f == NULL:
                break
            fact = FACT()
            fact.create(<void*>self.env, <void*>f)
            res.append(fact)
        return res
    def ASSERT(self, fact, trid=None):
        if trid == None:
            f = FACT()
            f.create(<void*>self.env, <void*>AssertString(<void*>self.env, fact))
            return f
        else:
            if trid not in self.transactions.keys():
                return False
            self.transactions[trid].append(fact)
            return True
    def ASSERTS(self, facts):
        if LoadFactsFromString(<void*>self.env, facts, -1) == 0:
            return False
        return True
    def BEGIN(self):
        trid = uuid.uuid4()
        self.transactions[trid] = []
        return trid
    def COMMIT(self, trid):
        if trid not in self.transactions.keys():
            return False
        facts = '\n'.join(self.transactions[trid])
        return self.ASSERTS(facts)

cdef class ENV:
    cdef void* env
    cdef object ready
    def __cinit__(self):
        self.ready = False
        self.env = <void*>CreateEnvironment()
        if self.env != NULL:
            self.ready = True
    def isReady(self):
        return self.ready
    def currentModule(self):
        m = MODULE()
        m.create(<void*>self.env, <void*>GetCurrentModule(<void*>self.env))
        return m
    def __getitem__(self, key):
        _m = <void*>FindDefmodule(<void*>self.env, key)
        if _m == NULL:
            raise KeyError,key
        else:
            m = MODULE()
            m.create(<void*>self.env, <void*>_m)
            return m
    def IS_CHANGED(self):
        if GetFactListChanged(<void*>self.env) == 0:
            return False
        SetFactListChanged(<void*>self.env, 0)
        return True
    def CLEAR(self):
        Clear(<void*>self.env)
    def RESET(self):
        Reset(<void*>self.env)
    def LOAD(self, name):
        _path = exists_and_can_read(name)
        if _path != None:
                if Load(<void*>self.env, _path) == 1:
                    return True
        return False
    def BUILD(self, constr):
        if Build(<void*>self.env, constr) == 1:
            return True
        return False
    def FACTS(self):
        if self.ready != True:
            return None
        f = FACTS()
        f.create(<void*>self.env)
        return f
    def SHELL(self):
        if self.ready != True:
            return None
        s = SHELL()
        s.create(<void*>self.env)
        return s
    def __dealloc__(self):
        if self.ready == True:
            DestroyEnvironment(self.env)


