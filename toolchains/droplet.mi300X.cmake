#apt install rocminfo
#apt install cmake
#apt install python3.12-venv
#export CMAKE_PREFIX_PATH=/opt/rocm:$CMAKE_PREFIX_PATH
#car hip est dans  /opt/rocm/lib/cmake/ 
#chercher avec find / -name "*Config.cmake" -o -name "*-config.cmake" 2>/dev/null | grep -i hip
#also utile:
#readlink -f $(which rocprof-compute)
#ls -ln ..


set(CMAKE_CXX_COMPILER amdclang++)
set(CMAKE_HIP_COMPILER amdclang++)
set(CMAKE_HIP_ARCHITECTURES gfx942  CACHE STRING "") #rocminfo | grep gfx
set(GPU_TARGETS gfx942  CACHE STRING "") #rocminfo | grep gfx