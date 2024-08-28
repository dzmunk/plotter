cmake_minimum_required(VERSION 3.22)

project(application LANGUAGES C CXX)

set(FILES
  main.cpp
)

add_executable(${PROJECT_NAME} ${FILES})

target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(${PROJECT_NAME} PRIVATE 
    volk 
    glfw 
    imgui 
    implot
)

#target_compile_definitions(${PROJECT_NAME})


