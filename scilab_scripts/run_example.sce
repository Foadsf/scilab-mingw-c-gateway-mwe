// Scilab script to load and test the minimal gateway DLL

function run_minimal_example()
    mprintf("--- Running Minimal Scilab-C Gateway Example ---\n");

    // Get the path where this script is located
    script_path = get_absolute_file_path("run_example.sce");
    // Go up one level to the repository root
    root_path = getshortpathname(script_path + ".." + filesep());

    // Define the path to the compiled DLL (expected in the root)
    dll_name = "minimal_toolbox.dll";
    dll_path = root_path + dll_name;

    mprintf("Script Path: %s\n", script_path);
    mprintf("Repo Root Path: %s\n", root_path);
    mprintf("Looking for DLL: %s\n", dll_path);

    // Check if DLL exists
    if ~isfile(dll_path) then
        error("ERROR: %s not found. Please run build_and_run.bat first.\n", dll_name);
        return;
    end

    // --- Load the DLL and register the function ---
    // Unlink first in case it was previously loaded
    [bOK, ilib] = c_link("minimal_gateway"); // Use the exported function name
    if bOK then
        mprintf("Unlinking previous version...\n");
        ulink(ilib);
    end

    // Load the interface
    // Arg1: Path to DLL
    // Arg2: Name of the exported C registration function inside the DLL
    // Arg3: List of Scilab function names this registration function provides
    try
        mprintf("Loading DLL using addinter...\n");
        addinter(dll_path, "minimal_gateway", ["minimal_multiply_by_two"]);
        mprintf("SUCCESS: addinter completed.\n");
    catch
        err = lasterror();
        error("ERROR loading DLL with addinter: %s\n", err);
        return;
    end

    // --- Test the loaded function ---
    try
        mprintf("Testing the function minimal_multiply_by_two(10)...\n");
        result = minimal_multiply_by_two(10);
        mprintf("SUCCESS: Function returned -> %d\n", result);

        expected = 20;
        if result <> expected then
             mprintf("WARNING: Result differs from expected value %d!\n", expected);
        end

    catch
        err = lasterror();
        error("ERROR calling minimal_multiply_by_two: %s\n", err);
    end

    mprintf("--- Example Finished ---\n");

endfunction

// Execute the function
run_minimal_example();
clear run_minimal_example; // Clean up stack