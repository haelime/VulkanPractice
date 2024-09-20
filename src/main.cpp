#include <iostream>
#include <cstdlib>
#include <stdexcept>

#include "FirstApp.hpp"

int main() {
  
  vesta::FirstApp app{};
  
  try {
    app.run();
  } catch (const std::exception& e) {
    std::cerr << e.what() << std::endl;
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}