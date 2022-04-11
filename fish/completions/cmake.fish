complete -f -c cmake -r -s "G" -d "Build environment generator" -a "Ninja"
complete -f -c cmake -r -s "S" -d "Source root path"
complete -f -c cmake -r -s "B" -d "Build root path"
complete -f -c cmake -r -l "build" -d "Build root to build"

complete -f -c cmake -r -o "DCMAKE_C_FLAGS" -d "Extra C compiler flags"
complete -f -c cmake -r -o "DCMAKE_CXX_FLAGS" -d "Extra C++ compiler flags"
complete -f -c cmake -r -o "DCMAKE_BUILD_TYPE" -d "Type of build to configure" -a "Debug Release RelWithDebInfo MinSizeRel"
complete -f -c cmake -r -o "DCMAKE_EXPORT_COMPILE_COMMANDS" -d "Generate compile_commands.json"
