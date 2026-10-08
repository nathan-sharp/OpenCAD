cmake_minimum_required(VERSION 3.10)
project(ocis_cpp_parser)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# In a real project we might fetch nlohmann_json, but we downloaded the single header
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(parse_example main.cpp)
