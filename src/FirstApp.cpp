#include "FirstApp.hpp"

namespace vesta {

void FirstApp::run() {
    while (!vestaWindow.shouldClose()) {
        glfwPollEvents();
    }
}
}