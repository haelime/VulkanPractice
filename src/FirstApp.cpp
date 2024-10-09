#include <stdexcept>
#include "FirstApp.hpp"

namespace vesta {

FirstApp::FirstApp() {
    createPipelineLayout();
    createPipeline();
    createCommandBuffers();
}

FirstApp::~FirstApp() {
    vkDestroyPipelineLayout(vestaDevice.device(), pipelineLayout, nullptr);
}

void FirstApp::run() {
    while (!vestaWindow.shouldClose()) {
        glfwPollEvents();
    }
}

void FirstApp::createPipelineLayout() {
    VkPipelineLayoutCreateInfo pipelineLayoutInfo{};
    pipelineLayoutInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
    pipelineLayoutInfo.setLayoutCount = 0;
    pipelineLayoutInfo.pSetLayouts = nullptr;
    pipelineLayoutInfo.pushConstantRangeCount = 0;
    pipelineLayoutInfo.pPushConstantRanges = nullptr;
    if (vkCreatePipelineLayout(vestaDevice.device(), &pipelineLayoutInfo, nullptr, &pipelineLayout) != VK_SUCCESS) {
        throw std::runtime_error("Failed to create pipeline layout!");

    }
}

void FirstApp::createPipeline() {
    auto pipelineConfig = VestaPipeline::defaultPipelineConfigInfo(vestaSwapChain.width(), vestaSwapChain.height());
    pipelineConfig.renderPass = vestaSwapChain.getRenderPass();
    pipelineConfig.pipelineLayout = pipelineLayout;
    vestaPipeline = std::make_unique<VestaPipeline>(vestaDevice, "shader/simple.vert.spv", "shader/simple.frag.spv", pipelineConfig);
}

void FirstApp::createCommandBuffers() {};
void FirstApp::drawFrame() {};


} // namespace vesta