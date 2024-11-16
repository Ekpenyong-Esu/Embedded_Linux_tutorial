# Set cross-compiler
SET(CMAKE_C_COMPILER   arm-cortex_a8-linux-gnueabihf-gcc)
SET(CMAKE_CXX_COMPILER arm-cortex_a8-linux-gnueabihf-g++)

# Specify the necessary flags
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
