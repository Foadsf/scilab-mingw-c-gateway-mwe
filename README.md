# Scilab-MinGW C Gateway MWE

Minimal working example of calling a C function from Scilab on Windows via MinGW-compiled gateway DLL.

This repository provides the simplest possible demonstration of integrating a function written in C into Scilab using the gateway mechanism, specifically targeting a Windows environment with MinGW (via MSYS2) and a standard Scilab installation.

## Purpose

This MWE shows the core components needed:
*   A simple C library (`src/minimal_lib.c`, `src/minimal_lib.h`).
*   A C++ Scilab gateway (`src/minimal_gateway.cpp`) to bridge the two.
*   Minimal dummy Scilab headers (`includes/`) needed for compilation outside a full Scilab source build.
*   A single Windows batch script (`build_and_run.bat`) to compile the C and C++ code into a DLL and then run a Scilab test script.
*   A Scilab script (`scilab_scripts/run_example.sce`) to load the DLL and call the C function.

## Prerequisites

*   **Windows Operating System**
*   **Scilab (64-bit):** Installed, preferably via official installer, winget, or choco. The path is configured in `build_and_run.bat`. Tested with Scilab 2024.0.0.
*   **MSYS2 with MinGW-w64 (64-bit):** Installed, with the `mingw-w64-x86_64-gcc` compiler accessible from the MSYS2 MINGW64 terminal (and thus usually via the system PATH configured by MSYS2). Ensure the MinGW bin path is set correctly in `build_and_run.bat`.
    *   Install compiler if needed: `pacman -S mingw-w64-x86_64-gcc` within MSYS2 MINGW64 terminal.

## How to Use

1.  **Clone:** Clone this repository.
2.  **Configure Paths (if needed):** Open `build_and_run.bat` in a text editor and verify/correct the paths set for `SCILAB_ROOT` and `MINGW_PATH` to match your installations.
3.  **Run the Batch Script:** Open a standard Windows Command Prompt (`cmd.exe`) or PowerShell, navigate (`cd`) to the root directory of the cloned repository, and simply run the batch file:
    ```cmd
    build_and_run.bat
    ```
    This script will:
    *   Clean previous artifacts.
    *   Compile the C library source (`minimal_lib.c`).
    *   Compile the C++ gateway source (`minimal_gateway.cpp`).
    *   Link them together with necessary Scilab libraries into `minimal_toolbox.dll` in the repository root.
    *   Launch Scilab in terminal mode (`WScilex-cli.exe`).
    *   Execute `scilab_scripts/run_example.sce`.
    *   The Scilab script loads the DLL and calls the `minimal_multiply_by_two(10)` function.
    *   Scilab exits.

## How the Gateway Works

The Scilab-C gateway mechanism enables Scilab to call C/C++ functions through a well-defined API. Here's how it works in this MWE:

1. **Gateway Architecture:**
   - `minimal_lib.c` contains a simple C function (`multiply_by_two`) that multiplies an integer by 2.
   - `minimal_gateway.cpp` creates a "bridge" function (`sci_minimal_multiply_by_two`) that:
     - Extracts input values from Scilab variables
     - Calls the C function
     - Packages the result back into Scilab format
   - `minimal_gateway` export function registers the function with Scilab's function dispatcher.

2. **Data Type Handling:**
   - Scilab uses different data types than C/C++
   - The gateway handles conversion between:
     - Scilab's primary numeric type (double)
     - C-style integers and floating-point types
   - The gateway checks input parameters for correct type and dimensions

3. **Function Registration:**
   - Scilab uses the exported `minimal_gateway` function to find available functions
   - Each function is registered using `addCFunction` with:
     - Scilab-visible name
     - Implementation function pointer
     - Module grouping

4. **Compilation and Linking:**
   - The gateway and C library are compiled separately
   - They're linked together with Scilab API libraries
   - The result is a DLL that Scilab can load at runtime

## Common Pitfalls and Solutions

When building Scilab-C gateways, these issues often arise:

1. **Parameter Type Mismatches:**
   - The Scilab API functions have specific parameter types
   - Pass parameters exactly as specified in the API header files
   - Use appropriate type casting when necessary

2. **Input/Output Handling:**
   - Handle both integer and double inputs for flexibility
   - Return data in Scilab's preferred format (usually double)
   - Always check that function parameters are valid before using them

3. **Memory Management:**
   - Be careful with pointer handling
   - Check for NULL pointers after allocation or retrieval operations
   - Use proper error handling to avoid memory leaks

4. **Unused Parameters:**
   - Some API functions require parameters you might not use
   - Mark them with `(void)parameter;` to avoid compiler warnings
   - Don't remove parameters from function signatures as this breaks the API contract

## Expected Output

The batch script output should show successful compilation and linking steps. The Scilab part should output something similar to:

```
--- Running Minimal Scilab-C Gateway Example ---
Script Path: C:\path\to\repo\scilab_scripts\
Repo Root Path: C:\path\to\repo\
Looking for DLL: C:\path\to\repo\minimal_toolbox.dll
Loading DLL using addinter...
SUCCESS: addinter completed.
Testing the function minimal_multiply_by_two(10)...
SUCCESS: Function returned -> 20
--- Example Finished ---
--- Script Finished ---
```

## Extending This Example

To add your own functions:

1. Add your C/C++ function to `minimal_lib.c` or create a new source file
2. Create a corresponding gateway function in `minimal_gateway.cpp` following the `sci_minimal_multiply_by_two` pattern
3. Add a new condition in the `minimal_gateway` function to register your new function
4. Update the `addinter` call in `run_example.sce` to include your new function name in the list of functions

## License

[![License: CC BY-SA 4.0](https://licensebuttons.net/l/by-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-sa/4.0/)

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

## Author

*   Foad S. Farimani (f.s.farimani@gmail.com)

*(Based on concepts from the Scilab Spoken Tutorial by IIT Bombay)*
