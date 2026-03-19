set(CMAKE_C_COMPILER amdclang)
set(CMAKE_CXX_COMPILER amdclang++)
set(GPU_TARGETS gfx90a CACHE STRING "") #rocminfo | grep gfx