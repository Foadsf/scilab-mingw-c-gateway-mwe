#include "minimal_lib.h"
#include <stdio.h> // Optional: for debugging printf inside C

// Simple C function implementation
int multiply_by_two(int input_value) {
    // printf("[C Lib] Input: %d\n", input_value); // Optional debug print
    int result = input_value * 2;
    // printf("[C Lib] Result: %d\n", result); // Optional debug print
    return result;
}