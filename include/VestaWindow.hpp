#pragma once

#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>

#include <string>

namespace vesta {

class VestaWindow {

public:
    VestaWindow(int w, int h, std::string name);
    ~VestaWindow();

    VestaWindow(const VestaWindow &) = delete;
    VestaWindow &operator=(const VestaWindow &) = delete;

    bool shouldClose() { return glfwWindowShouldClose(window); }

    // what the hell is KHR
    void createWindowSurface( VkInstance instance, VkSurfaceKHR *surface );


private:

    void initWindow();

    const int   width;
    const int   height;

    std::string windowName;
    GLFWwindow  *window;

};
} // namespace vesta