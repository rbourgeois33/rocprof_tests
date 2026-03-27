set(CMAKE_C_COMPILER craycc)
set(CMAKE_CXX_COMPILER craycxx)
set(CMAKE_HIP_ARCHITECTURES gfx90a CACHE STRING "") #rocminfo | grep gfx
set(GPU_TARGETS gfx90a CACHE STRING "") #rocminfo | grep gfx