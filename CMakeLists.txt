cmake_minimum_required(VERSION 3.21)

project(hip_sample LANGUAGES CXX HIP)

find_package(hip REQUIRED)

add_executable(hip_sample)

target_compile_features(hip_sample PRIVATE cxx_std_20) #More modern

if(NOT CMAKE_HIP_ARCHITECTURES)
        message(FATAL_ERROR "No HIP architecture selected. Please set -DCMAKE_HIP_ARCHITECTURES=XX")
endif()

#https://rocm.docs.amd.com/en/latest/conceptual/cmake-packages.html#consuming-the-hip-api-in-c-code: 
#if HIP sources don’t have .hip as their extension, use set_source_files_properties(<hip_sources>… PROPERTIES LANGUAGE HIP) on them
set_source_files_properties(hip_sample.cpp PROPERTIES LANGUAGE HIP)

target_sources(hip_sample PRIVATE hip_sample.cpp)