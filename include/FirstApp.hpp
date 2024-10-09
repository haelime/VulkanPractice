#pragma once

#include <memory>
#include <vector>

#include "VestaWindow.hpp"
#include "VestaPipeline.hpp"
#include "VestaDevice.hpp"
#include "VestaSwapChain.hpp"

namespace vesta {

class FirstApp {

    public:
        static constexpr int WIDTH = 800;
        static constexpr int HEIGHT = 600;

        FirstApp();
        ~FirstApp();

        FirstApp(const FirstApp &) = delete;
        FirstApp &operator= (const FirstApp &) = delete;

        
        void run();

    private:
        void createPipelineLayout();
        void createPipeline();
        void createCommandBuffers();
        void drawFrame();

        VestaWindow vestaWindow{ WIDTH, HEIGHT, "vesta" };
        VestaDevice vestaDevice{ vestaWindow };
        VestaSwapChain vestaSwapChain{ vestaDevice, vestaWindow.getExtent() };
        std::unique_ptr<VestaPipeline> vestaPipeline;
        VkPipelineLayout pipelineLayout;
        std::vector<VkCommandBuffer> commandBuffers;

};

} // namespace vesta
