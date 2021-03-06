/* Generated by Cython 0.24 */

#ifndef __PYX_HAVE__testmod
#define __PYX_HAVE__testmod


#ifndef __PYX_HAVE_API__testmod

#ifndef __PYX_EXTERN_C
  #ifdef __cplusplus
    #define __PYX_EXTERN_C extern "C"
  #else
    #define __PYX_EXTERN_C extern
  #endif
#endif

#ifndef DL_IMPORT
  #define DL_IMPORT(_T) _T
#endif

__PYX_EXTERN_C DL_IMPORT(double) get_clock(void *);
__PYX_EXTERN_C DL_IMPORT(double) get_number_of_params(void *);
__PYX_EXTERN_C DL_IMPORT(PyObject) *make_class(void *);
__PYX_EXTERN_C DL_IMPORT(PyObject) *call_a(void *);
__PYX_EXTERN_C DL_IMPORT(PyObject) *call_b(void *);
__PYX_EXTERN_C DL_IMPORT(PyObject) *print_params(void *);
__PYX_EXTERN_C DL_IMPORT(int) init_clips_testmod(void *);

#endif /* !__PYX_HAVE_API__testmod */

#if PY_MAJOR_VERSION < 3
PyMODINIT_FUNC inittestmod(void);
#else
PyMODINIT_FUNC PyInit_testmod(void);
#endif

#endif /* !__PYX_HAVE__testmod */
