#pragma once

#include <vector>
#include <string>

#include "VestaDevice.hpp"

namespace vesta {

struct PipelineConfigInfo {
    VkViewport                              viewport;
    VkRect2D                                scissor;
    VkPipelineViewportStateCreateInfo       viewPortInfo;
    VkPipelineInputAssemblyStateCreateInfo  inputAssemblyInfo;
    VkPipelineRasterizationStateCreateInfo  rasterizationInfo;
    VkPipelineMultisampleStateCreateInfo    multisampleInfo;
    VkPipelineColorBlendAttachmentState     colorBlendAttachment;
    VkPipelineColorBlendStateCreateInfo     colorBlendInfo;
    VkPipelineDepthStencilStateCreateInfo   depthStencilInfo;
    VkPipelineLayout                        pipelineLayout = nullptr;
    VkRenderPass                            renderPass = nullptr;
    uint32_t                                subpass = 0;
};
class VestaPipeline{
  
public:
    VestaPipeline(VestaDevice &device, const std::string& vertFilePath, const std::string& fragFilePath, const PipelineConfigInfo& configInfo);

    ~VestaPipeline();
    
    VestaPipeline(const VestaPipeline &) = delete;
    void operator=(const VestaPipeline &) = delete;

    static PipelineConfigInfo defaultPipelineConfigInfo(uint32_t width, uint32_t height);


private:

    static std::vector<char> readFile(const std::string& filePath);

    void createGraphicsPipeline(const std::string& vertFilePath, const std::string& fragFilePath, const PipelineConfigInfo& configInfo);

    void createShaderModule(const std::vector<char>& code, VkShaderModule* shaderModule);

    VestaDevice&    vestaDevice;
    VkPipeline      graphicsPipeline;
    VkShaderModule  vertShaderModule;
    VkShaderModule  fragShaderModule;
    
};
}