cmake_minimum_required(VERSION 3.10)
project(shared)

# Include cross-compile toolchain file
include(../beagle-bone-tool-chain.cmake)
include_directories(${PROJECT_SOURCE_DIR}/../inc)

# Set compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -g -fPIC")

# Source files
set(SOURCES testlib.c)

# Build shared library
add_library(testlib SHARED ${SOURCES})

# Include directory
target_include_directories(testlib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
