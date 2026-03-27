set(CMAKE_C_COMPILER amdclang)
set(CMAKE_CXX_COMPILER amdclang++)
set(CMAKE_HIP_ARCHITECTURES gfx90a CACHE STRING "") #rocminfo | grep gfx