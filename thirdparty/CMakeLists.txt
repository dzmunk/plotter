cmake_minimum_required(VERSION 3.22)

project(thirdparty LANGUAGES C CXX)

# Vulkan Library Setup
add_library(vulkan INTERFACE)
set(VULKAN_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/vulkan/include)
target_include_directories(vulkan INTERFACE ${VULKAN_INCLUDE_DIR})

# Exclude Vulkan prototypes since we're using Volk
target_compile_definitions(vulkan INTERFACE VK_NO_PROTOTYPES)

# Platform-specific Vulkan definitions
if(WIN32 AND VULKAN_PLATFORM_DEPENDENT)
    target_compile_definitions(vulkan INTERFACE VK_USE_PLATFORM_WIN32_KHR)
elseif(APPLE AND VULKAN_PLATFORM_DEPENDENT)
    target_compile_definitions(vulkan INTERFACE VK_USE_PLATFORM_METAL_EXT)
elseif(UNIX)
    if (WSI_SELECTION STREQUAL XCB)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(XCB xcb REQUIRED)
        if (XCB_FOUND AND VULKAN_PLATFORM_DEPENDENT)
            target_compile_definitions(vulkan INTERFACE VK_USE_PLATFORM_XCB_KHR)
            target_include_directories(vulkan INTERFACE ${XCB_INCLUDE_DIRS})
        endif()
    elseif (WSI_SELECTION STREQUAL XLIB)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(X11 x11 REQUIRED)
        if (X11_FOUND AND VULKAN_PLATFORM_DEPENDENT)
            target_compile_definitions(vulkan INTERFACE VK_USE_PLATFORM_XLIB_KHR)
            target_include_directories(vulkan INTERFACE ${X11_INCLUDE_DIRS})
        endif()
    elseif (WSI_SELECTION STREQUAL WAYLAND)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(WAYLAND wayland-client REQUIRED)
        if (WAYLAND_FOUND AND VULKAN_PLATFORM_DEPENDENT)
            target_compile_definitions(vulkan INTERFACE VK_USE_PLATFORM_WAYLAND_KHR)
            target_include_directories(vulkan INTERFACE ${WAYLAND_INCLUDE_DIRS})
        endif()
    elseif (WSI_SELECTION STREQUAL D2D)
        set(DIRECT_TO_DISPLAY TRUE)
        set(DIRECT_TO_DISPLAY TRUE PARENT_SCOPE)
        if (VULKAN_PLATFORM_DEPENDENT)
            target_compile_definitions(vulkan INTERFACE VK_USE_PLATFORM_DISPLAY_KHR)
        endif()
    else()
        message(FATAL_ERROR "Unknown WSI")
    endif()
endif()

# Volk Setup
set(VOLK_DIR "${CMAKE_CURRENT_SOURCE_DIR}/volk")
set(VOLK_FILES "${VOLK_DIR}/volk.c" "${VOLK_DIR}/volk.h")

add_library(volk STATIC ${VOLK_FILES})
target_include_directories(volk PUBLIC ${VOLK_DIR})
target_link_libraries(volk PUBLIC vulkan)

# GLFW Setup
option(GLFW_BUILD_DOCS OFF)
option(GLFW_BUILD_TESTS OFF)
option(GLFW_BUILD_EXAMPLES OFF)
option(GLFW_INSTALL OFF)

# Enable Wayland if selected
if (WSI_SELECTION STREQUAL WAYLAND)
    set(GLFW_USE_WAYLAND ON)
endif()

add_subdirectory(glfw)

# ImGui Setup
set(IMGUI_DIR "${CMAKE_CURRENT_SOURCE_DIR}/imgui")
set(IMGUI_FILES
    "${IMGUI_DIR}/imgui.cpp"
    "${IMGUI_DIR}/imgui_demo.cpp"
    "${IMGUI_DIR}/imgui_draw.cpp"
    "${IMGUI_DIR}/imgui_widgets.cpp"
    "${IMGUI_DIR}/imgui_tables.cpp"
    "${IMGUI_DIR}/backends/imgui_impl_glfw.cpp"
    "${IMGUI_DIR}/backends/imgui_impl_vulkan.cpp"
)

add_library(imgui STATIC ${IMGUI_FILES})
target_include_directories(imgui PUBLIC 
    ${IMGUI_DIR}
    ${IMGUI_DIR}/backends
)

target_compile_definitions(imgui PUBLIC 
    IMGUI_IMPL_VULKAN_USE_VOLK      
    ImTextureID=ImU64               
)

target_link_libraries(imgui PUBLIC glfw volk)

# ImPlot Setup
set(IMPLOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/implot")
set(IMPLOT_FILES
    "${IMPLOT_DIR}/implot.cpp"
    "${IMPLOT_DIR}/implot_demo.cpp"
    "${IMPLOT_DIR}/implot_items.cpp"
)

add_library(implot STATIC ${IMPLOT_FILES})
target_include_directories(implot PUBLIC ${IMPLOT_DIR})
target_link_libraries(implot PUBLIC imgui)
