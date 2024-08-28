cmake_minimum_required(VERSION 3.22)

project(test LANGUAGES C CXX)

set(FILES
  imgui_impl_dx12.cpp
  imgui_impl_win32.cpp
  main.cpp
)

add_executable(${PROJECT_NAME} ${FILES})

target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(${PROJECT_NAME} PRIVATE 
    imgui
    implot
    d3d12
    dxgi
    d3dcompiler   
    dwmapi
)

if(WIN32)
  	set_target_properties(${PROJECT_NAME} PROPERTIES WIN32_EXECUTABLE ON)
endif()
#target_compile_definitions(${PROJECT_NAME})


