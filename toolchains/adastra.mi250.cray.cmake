#module load cpe/25.09 PrgEnv-cray craype-accel-amd-gfx90a rocm cray-python
set(CMAKE_C_COMPILER craycc)
set(CMAKE_CXX_COMPILER craycxx)
set(CMAKE_HIP_ARCHITECTURES gfx90a CACHE STRING "") #rocminfo | grep gfx
set(GPU_TARGETS gfx90a CACHE STRING "") #rocminfo | grep gfx