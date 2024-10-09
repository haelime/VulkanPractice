cmake_minimum_required(VERSION 3.10)

project(VestaEngine VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Vulkan 라이브러리 찾기
find_package(Vulkan REQUIRED)

# GLFW 라이브러리 찾기
find_package(glfw3 CONFIG REQUIRED)

# include 디렉토리 추가
include_directories(include)

# 소스 파일 목록
set(SOURCES
    src/FirstApp.cpp
    src/HelloTriangleApplication.cpp
    src/main.cpp
    src/VestaDevice.cpp
    src/VestaPipeline.cpp
    src/VestaWindow.cpp
    src/VestaSwapChain.cpp
)

# 쉐이더 파일 목록
set(SHADERS
    shader/shader.vert
    shader/shader.frag
    shader/simple.vert
    shader/simple.frag
)

# 쉐이더 SPIR-V 파일 생성
set(SPV_SHADERS)
foreach(SHADER IN LISTS SHADERS)
    get_filename_component(FILE_NAME ${SHADER} NAME)
    set(SPV_FILE ${CMAKE_CURRENT_BINARY_DIR}/${FILE_NAME}.spv)
    add_custom_command(
        OUTPUT ${SPV_FILE}
        COMMAND ${Vulkan_GLSLANG_VALIDATOR_EXECUTABLE} -V ${CMAKE_CURRENT_SOURCE_DIR}/${SHADER} -o ${SPV_FILE}
        DEPENDS ${SHADER}
        COMMENT "Compiling shader ${SHADER} to SPIR-V"
    )
    list(APPEND SPV_SHADERS ${SPV_FILE})
endforeach()

# SPIR-V 쉐이더 파일을 생성에 포함
add_custom_target(Shaders DEPENDS ${SPV_SHADERS})

# 실행 파일 생성
add_executable(VestaEngine ${SOURCES})

# Vulkan 및 GLFW 라이브러리와 링크
target_link_libraries(VestaEngine PRIVATE Vulkan::Vulkan glfw)

# SPIR-V 쉐이더 파일을 실행 파일에 의존하게 설정
add_dependencies(VestaEngine Shaders)

# 컴파일 옵션 추가 (경고와 관련된 옵션)
# if(MSVC)
#     target_compile_options(VestaEngine PRIVATE /W4 /WX)
# else()
#     target_compile_options(VestaEngine PRIVATE -Wall -Wextra -pedantic -Werror)
# endif()
