/* Dummy sci_mem_alloc.h for basic compatibility */
#ifndef __SCI_MEM_ALLOC_H__
#define __SCI_MEM_ALLOC_H__

#include <stdlib.h>

#define MALLOC(x) malloc(x)
#define FREE(x) free(x)
#define CALLOC(x,y) calloc(x,y)
#define REALLOC(x,y) realloc(x,y)

#endif /* __SCI_MEM_ALLOC_H__ */