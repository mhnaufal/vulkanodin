package instance

import logger "../logger"
import "core:fmt"
import "core:strings"
import glfw "vendor:glfw"
import vk "vendor:vulkan"

Instance :: struct {
	instance: vk.Instance,
	logger:   ^logger.Logger,
}

make_instance :: proc(instance: ^Instance, app_name: string) {
	instance.logger.level = .ALL
	logger.print_str(instance.logger, "Creating Vulkan instance...")

	app_info: vk.ApplicationInfo
	app_info.sType = .APPLICATION_INFO
	app_info.pApplicationName = strings.clone_to_cstring(app_name)
	app_info.applicationVersion = vk.MAKE_VERSION(0, 0, 1)
	app_info.pEngineName = "VulkanOdin"
	app_info.engineVersion = vk.MAKE_VERSION(1, 0, 0)
	app_info.apiVersion = vk.API_VERSION_1_0
	app_info.pNext = nil

	instance_info: vk.InstanceCreateInfo
	instance_info.sType = .INSTANCE_CREATE_INFO
	instance_info.pApplicationInfo = &app_info
	glfw_ext := glfw.GetRequiredInstanceExtensions()
	instance_info.ppEnabledExtensionNames = raw_data(glfw_ext)
	instance_info.enabledExtensionCount = cast(u32)len(glfw_ext)
	instance_info.enabledLayerCount = 0
	instance_info.pNext = nil

	context.user_ptr = instance
	get_proc_address :: proc(p: rawptr, name: cstring) {
		(cast(^rawptr)p)^ = glfw.GetInstanceProcAddress((^vk.Instance)(context.user_ptr)^, name)
	}
	vk.load_proc_addresses(get_proc_address)

	p := vk.CreateInstance(&instance_info, nil, &instance.instance)

	if p != .SUCCESS {
		instance.logger.level = .ERROR
		logger.print_str(instance.logger, "Failed to create Vulkan Instance")
		return
	}

	instance.logger.level = .SUCCESS
	logger.print_str(instance.logger, "Vulkan instance created")
	vk.load_proc_addresses(get_proc_address)
}
