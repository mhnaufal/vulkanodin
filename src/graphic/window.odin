package window

import logger "../logger"
import "core:strings"
import glfw "vendor:glfw"

Window :: struct {
	window: ^glfw.WindowHandle,
	logger: ^logger.Logger,
}

build_window :: proc(width: i32, height: i32, name: string, win: ^Window) -> glfw.WindowHandle {
	glfw.Init()

	glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
	glfw.WindowHint(glfw.RESIZABLE, glfw.FALSE)

	window: glfw.WindowHandle = glfw.CreateWindow(
		width,
		height,
		strings.clone_to_cstring(name),
		nil,
		nil,
	)

	temp_level := win.logger.level
	if window != nil {
		win.logger.level = .SUCCESS
		logger.print_str(win.logger, "Successfully create GLFW Window")
	} else {
		win.logger.level = .ERROR
		logger.print_str(win.logger, "Successfully create GLFW Window")
	}
	win.logger.level = temp_level

	win.window = &window

	return window
}
