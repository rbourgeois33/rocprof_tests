#module load rocm
set(CMAKE_C_COMPILER amdclang)
set(CMAKE_CXX_COMPILER amdclang++)
set(CMAKE_HIP_COMPILER hipcc) #Let cmake use default apparently
set(GPU_TARGETS gfx90a CACHE STRING "") #rocminfo | grep gfx