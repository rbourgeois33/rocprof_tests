cmake_minimum_required(VERSION 3.21)


#module load rocm/7
#set(CMAKE_C_COMPILER amdclang)
#set(CMAKE_CXX_COMPILER amdclang++)
#set(CMAKE_HIP_COMPILER hipcc) #Let cmake use default apparently
# Cache: persistent across configure and if given by user, not overriden by ""



## toolchain droplet

#cmake .. \
#  -DCMAKE_CXX_COMPILER=/opt/rocm-7.2.0/bin/amdclang++ \
#  -DCMAKE_HIP_COMPILER=/opt/rocm-7.2.0/bin/amdclang++ \
#  -DCMAKE_HIP_ARCHITECTURES=gfx942 \
#  -DCMAKE_PREFIX_PATH=/opt/rocm-7.2.0

project(vcopy LANGUAGES C CXX HIP)

add_executable(vcopy)

target_compile_features(vcopy PRIVATE cxx_std_20) #More modern

find_package(hip REQUIRED)

if(NOT CMAKE_HIP_ARCHITECTURES)
        message(FATAL_ERROR "No HIP architecture selected. Please set -DCMAKE_HIP_ARCHITECTURES=XX")
endif()

target_link_libraries(vcopy PRIVATE hip::device)


target_sources(vcopy PRIVATE vcopy.cpp)