package engine

import window "../graphic"
import logger "../logger"
import "core:strings"
import glfw "vendor:glfw"
import vk "vendor:vulkan"

Instance :: struct {
	instance: vk.Instance,
	logger:   ^logger.Logger,
}

Engine :: struct {
	instance: ^Instance,
	window:   ^window.Window,
}

create_instance :: proc(instance: ^Instance, app_name: string) -> bool {
	logger.print_str(instance.logger, "Creating Vulkan instance...", logger.LogLevel.ALL)

	/*
	* App Info
	*/
	app_info: vk.ApplicationInfo
	app_info.sType = .APPLICATION_INFO
	app_info.pApplicationName = strings.clone_to_cstring(app_name)
	app_info.applicationVersion = vk.MAKE_VERSION(0, 0, 1)
	app_info.pEngineName = "VulkanOdin"
	app_info.engineVersion = vk.MAKE_VERSION(1, 0, 0)
	app_info.apiVersion = vk.API_VERSION_1_0
	app_info.pNext = nil

	/*
	* Extensions (for debugging and error checking)
	*/
	glfw_ext := glfw.GetRequiredInstanceExtensions()
	glfw_enabled_ext_count := cast(u32)len(glfw_ext)
	if logger.is_enabled(instance.logger) {
		glfw_enabled_ext_count += 1
	}

	glfw_enabled_ext_name := make([]cstring, glfw_enabled_ext_count)
	for i in 0 ..< glfw_enabled_ext_count - 1 {
		glfw_enabled_ext_name[i] = glfw_ext[i]
	}
	if logger.is_enabled(instance.logger) {
		glfw_enabled_ext_name[glfw_enabled_ext_count - 1] = vk.EXT_DEBUG_UTILS_EXTENSION_NAME
	}
	logger.print_array(instance.logger, glfw_enabled_ext_name, glfw_enabled_ext_count, .DEBUG)

	/*
	* Validation Layers
	*/


	/*
	* Instance Info
	*/
	instance_info: vk.InstanceCreateInfo
	instance_info.sType = .INSTANCE_CREATE_INFO
	instance_info.pApplicationInfo = &app_info
	instance_info.ppEnabledExtensionNames = raw_data(glfw_enabled_ext_name)
	instance_info.enabledExtensionCount = glfw_enabled_ext_count
	instance_info.enabledLayerCount = 0
	instance_info.pNext = nil

	context.user_ptr = instance
	get_proc_address :: proc(p: rawptr, name: cstring) {
		(cast(^rawptr)p)^ = glfw.GetInstanceProcAddress((^vk.Instance)(context.user_ptr)^, name)
	}
	vk.load_proc_addresses(get_proc_address)

	p := vk.CreateInstance(&instance_info, nil, &instance.instance)

	if p != .SUCCESS {
		logger.print_str(
			instance.logger,
			"Failed to create Vulkan Instance",
			logger.LogLevel.ERROR,
		)
		return false
	}

	logger.print_str(instance.logger, "Vulkan instance created", logger.LogLevel.SUCCESS)
	vk.load_proc_addresses(get_proc_address)

	return true
}

destroy_vulkan :: proc(engine: ^Engine) {
	vk.DestroyInstance(engine.instance.instance, nil)
}

create_engine :: proc(instance: ^Instance, window: ^window.Window) -> Engine {
	assert(create_instance(instance, "VulkanOdin") == true)

	e: Engine
	e.instance = instance
	e.window = window

	return e
}
