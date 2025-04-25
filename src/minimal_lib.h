#ifndef MINIMAL_LIB_H
#define MINIMAL_LIB_H

// Function declaration for our simple C library function
// Use __declspec(dllexport) if building the C code as a *separate* DLL
// But here we link it statically, so it's not strictly needed.
// extern "C" might be needed if linking from C++ directly without gateway,
// but the gateway handles the C linkage.
int multiply_by_two(int input_value);

#endif // MINIMAL_LIB_H