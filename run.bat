cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=C:/devtools/vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-windows
cmake --build build --config debug --clean-first
start build/Debug/VestaEngine.exe