cmake_minimum_required(VERSION 3.10)
project(ocis_cpp_parser)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# In a real project we might fetch nlohmann_json, but we downloaded the single header
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(parse_example main.cpp)

enable_testing()
add_test(NAME parse_assembly_demo COMMAND parse_example ${CMAKE_CURRENT_SOURCE_DIR}/../../examples/assembly_demo.oca)
add_test(NAME parse_bracket_demo COMMAND parse_example ${CMAKE_CURRENT_SOURCE_DIR}/../../examples/bracket_demo.ocp)
add_test(NAME parse_bracket_stress_result COMMAND parse_example ${CMAKE_CURRENT_SOURCE_DIR}/../../examples/bracket_stress_result.ocr)
add_test(NAME parse_bracket_stress_test COMMAND parse_example ${CMAKE_CURRENT_SOURCE_DIR}/../../examples/bracket_stress_test.ocs)
add_test(NAME parse_wiring_demo COMMAND parse_example ${CMAKE_CURRENT_SOURCE_DIR}/../../examples/wiring_demo.oce)
