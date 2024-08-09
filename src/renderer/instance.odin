package instance

import logger "../logger"
import "core:strings"
import glfw "vendor:glfw"
import vk "vendor:vulkan"

Instance :: struct {
    instance: ^vk.Instance,
	logger: ^logger.Logger,
}

make_instance :: proc(instance: ^Instance, app_name: string) -> Maybe(vk.Instance) {
	logger.print_str(instance.logger, "Creating Vulkan instance...")

	// version := vk.EnumerateInstanceVersion()

	app_info: vk.ApplicationInfo
	app_info.apiVersion = vk.API_VERSION_1_0
	app_info.engineVersion = vk.MAKE_VERSION(1, 0, 0)
	app_info.applicationVersion = vk.MAKE_VERSION(0, 0, 1)
	app_info.sType = .APPLICATION_INFO
	app_info.pApplicationName = strings.clone_to_cstring(app_name)
	app_info.pEngineName = "VulkanOdin"

	instance_info: vk.InstanceCreateInfo
	instance_info.pApplicationInfo = &app_info
	instance_info.sType = .INSTANCE_CREATE_INFO
	glfw_ext := glfw.GetRequiredInstanceExtensions()
	instance_info.enabledLayerCount = cast(u32)len(glfw_ext)
	instance_info.ppEnabledExtensionNames = raw_data(glfw_ext)

	ins: vk.Instance
	is_instance_success := vk.CreateInstance(&instance_info, nil, &ins)
    if is_instance_success != .SUCCESS {
        logger.print_str(instance.logger, "Failed to create Vulkan Instance")
        return nil
    }

    instance.instance = &ins

	return ins
}
