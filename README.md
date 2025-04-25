# Scilab-MinGW C Gateway MWE

Minimal example of calling a C function from Scilab on Windows via MinGW-compiled gateway DLL.

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

## Expected Output

The batch script output should show successful compilation and linking steps. The Scilab part should output something similar to:

```
--- Running Minimal Scilab-C Gateway Example ---
Script Path: C:\path\to\repo\scilab_scripts\
Repo Root Path: C:\path\to\repo\
Looking for DLL: C:\path\to\repo\minimal_toolbox.dll
Unlinking previous version... (Only if run before)
Loading DLL using addinter...
SUCCESS: addinter completed.
Testing the function minimal_multiply_by_two(10)...
SUCCESS: Function returned -> 20
--- Example Finished ---
--- Script Finished ---
```

## License

[![License: CC BY-SA 4.0](https://licensebuttons.net/l/by-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-sa/4.0/)

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

## Author

*   Foad S. Farimani (f.s.farimani@gmail.com)

*(Based on concepts from the Scilab Spoken Tutorial by IIT Bombay)*
