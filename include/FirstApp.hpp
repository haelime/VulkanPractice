#pragma once

#include "VestaWindow.hpp"
#include "VestaPipeline.hpp"
#include "VestaDevice.hpp"
#include "VestaSwapChain.hpp"

namespace vesta {

class FirstApp {

    public:
        static constexpr int WIDTH = 800;
        static constexpr int HEIGHT = 600;

        void run();

    private:
        VestaWindow vestaWindow{ WIDTH, HEIGHT, "vesta" };
        VestaDevice vestaDevice{ vestaWindow };
        VestaPipeline vestaPipeline{ vestaDevice, "shader/simple.vert.spv", "shader/simple.frag.spv", VestaPipeline::defaultPipelineConfigInfo(WIDTH, HEIGHT) };

};

} // namespace vesta
