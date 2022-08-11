mkdir build
cd build
cmake -DCMAKE_PREFIX_PATH=/opt/homebrew/Cellar/libtorch/1.12.1  ..
cmake --build . --config Release
