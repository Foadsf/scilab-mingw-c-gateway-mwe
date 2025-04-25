#ifndef __GATEWAY_C_H__
#define __GATEWAY_C_H__

/*
 * ==========================================================================
 * DUMMY DEFINITIONS - FOR DEBUGGING INCLUDE ISSUES ONLY
 * These are likely incorrect and will cause linking/runtime errors if API changes.
 * The real gateway_c.h is part of the Scilab source/development headers.
 * ==========================================================================
 */
#include "api_scilab.h" // Needs basic Scilab types

/* Define a generic function pointer type */
typedef int (*GenericFuncPtrType)(scilabEnv, int, scilabVar*, int, scilabOpt*, int, scilabVar*);

/* Define the required types using the placeholder */
#define GW_C_FUNC GenericFuncPtrType
// Define others if needed by included headers, though not strictly used by our simple gateway
#define OLDGW_FUNC GenericFuncPtrType
#define MEXGW_FUNC GenericFuncPtrType

#endif /* __GATEWAY_C_H__ */