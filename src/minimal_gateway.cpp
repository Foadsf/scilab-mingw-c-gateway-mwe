// Minimal Scilab Gateway in C++

// Must be extern C for Scilab linkage
extern "C" {
    // Standard C/C++ headers
    #include <stdio.h>
    #include <wchar.h>

    // --- Scilab Headers ---
    // Core API
    #include "api_scilab.h"
    // Error reporting
    #include "Scierror.h"
    // Include dummy header required by addfunction.h
    #include "gateway_c.h"
    // Function registration mechanism
    #include "addfunction.h"

    // --- Our C Library Header ---
    #include "minimal_lib.h"

    // Define the function name as it will appear in Scilab
    static const char fname_scilab[] = "minimal_multiply_by_two";

    // --- The Gateway Function Implementation ---
    // This function bridges Scilab variables and the C function call
    int sci_minimal_multiply_by_two(scilabEnv env, int nin, scilabVar* in, int nopt, scilabOpt* opt, int nout, scilabVar* out)
    {
        int input_val = 0;
        int result_val = 0;
        int* matrix_in = NULL;
        double dbl_val = 0.0;

        // --- Argument Checking ---
        if (nin != 1) {
            Scierror(77, "%s: Wrong number of input argument(s): %d expected.\n", fname_scilab, 1);
            return 1;
        }
        if (nout > 1) {
            Scierror(78, "%s: Wrong number of output argument(s): %d expected.\n", fname_scilab, 1);
            return 1;
        }

        // --- Get Input Argument ---
        // Check if it's a double (Scilab's default numeric type)
        if (!scilab_isDouble(env, in[0])) {
            if (!scilab_isInt(env, in[0])) {
                Scierror(999, "%s: Wrong type for input argument #1: Double or Integer expected.\n", fname_scilab);
                return 1;
            }
        }
        
        // Check if it's a scalar
        if (!scilab_isScalar(env, in[0])) {
            Scierror(999, "%s: Wrong size for input argument #1: Scalar expected.\n", fname_scilab);
            return 1;
        }

        // Get the value - handle both double and integer types
        if (scilab_isDouble(env, in[0])) {
            // Fixed: Pass the address of dbl_val directly
            scilab_getDouble(env, in[0], &dbl_val);
            input_val = (int)(dbl_val); // Cast to int
        } else {
            // Integer type - for simplicity, assume 32-bit int
            scilab_getInteger32Array(env, in[0], &matrix_in);
            if (matrix_in == NULL) {
                Scierror(999, "%s: Failed to get input matrix data pointer.\n", fname_scilab);
                return 1;
            }
            input_val = matrix_in[0];
        }

        // --- Call the C Library Function ---
        result_val = multiply_by_two(input_val);

        // --- Create and Assign Output Argument ---
        // Return as double (Scilab's preferred numeric type)
        out[0] = scilab_createDouble(env, (double)result_val);
        if (out[0] == NULL) {
            Scierror(999, "%s: Memory allocation error for output variable.\n", fname_scilab);
            return 1;
        }

        return 0; // Indicate success
    }

    // --- Gateway Registration Function ---
    // This function is called by Scilab's addinter to register the gateway functions.
    // The exported name MUST match the second argument of addinter.
    #define MODULE_NAME L"minimal_module" // A logical name for Scilab

    __declspec(dllexport) int minimal_gateway(wchar_t* _pwstFuncName)
    {
        // The _pwstFuncName argument allows a single DLL entry point to potentially
        // register multiple Scilab functions. Scilab calls this entry point once
        // for each function name listed in the third argument of addinter.

        // Check if Scilab is asking to register the function this gateway provides
        if (wcscmp(_pwstFuncName, L"minimal_multiply_by_two") == 0)
        {
            // Register the Scilab-callable function named "minimal_multiply_by_two"
            // It maps to the C implementation function pointed to by &sci_minimal_multiply_by_two
            // It belongs to the logical module defined by MODULE_NAME
            // The cast (GW_C_FUNC) ensures type compatibility.
            addCFunction(L"minimal_multiply_by_two", (GW_C_FUNC)sci_minimal_multiply_by_two, MODULE_NAME);
        }
        // Add more `else if` blocks here if this DLL
        // were to register more functions via this single entry point.

        return 1; // Indicate success to Scilab's loader mechanism
    }

} // End extern "C"