cmake_minimum_required(VERSION 3.21)

project(hip_sample LANGUAGES C CXX HIP)

add_executable(hip_sample)

target_compile_features(hip_sample PRIVATE cxx_std_20) #More modern

find_package(hip REQUIRED)

if(NOT CMAKE_HIP_ARCHITECTURES)
        message(FATAL_ERROR "No HIP architecture selected. Please set -DCMAKE_HIP_ARCHITECTURES=XX")
endif()

target_link_libraries(hip_sample PRIVATE hip::device)


target_sources(hip_sample PRIVATE hip_sample.cpp)