
cmake_minimum_required(VERSION 3.10)
project(hello-arm)

# Include cross-compile toolchain file
include(../beagle-bone-tool-chain.cmake)
include_directories(${PROJECT_SOURCE_DIR}/../inc)

# Set compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")

# Source files
set(SOURCES hello-arm.c)

# Add executable
add_executable(hello-arm ${SOURCES})

# Link with testlib
target_link_libraries(hello-arm testlib)
