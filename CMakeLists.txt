cmake_minimum_required(VERSION 3.21)

project(vcopy LANGUAGES C CXX HIP)

add_executable(vcopy)

target_compile_features(vcopy PRIVATE cxx_std_20) #More modern

find_package(hip REQUIRED)

if(NOT CMAKE_HIP_ARCHITECTURES)
        message(FATAL_ERROR "No HIP architecture selected. Please set -DCMAKE_HIP_ARCHITECTURES=XX")
endif()

target_link_libraries(vcopy PRIVATE hip::device)


target_sources(vcopy PRIVATE vcopy.cpp)