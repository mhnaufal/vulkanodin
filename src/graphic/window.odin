package window

import logger "../logger"
import "core:strings"
import glfw "vendor:glfw"

Window :: struct {
	window: glfw.WindowHandle,
	logger: ^logger.Logger,
}

create_window :: proc(width: i32, height: i32, name: string, win: ^Window) -> bool {
	glfw.Init()

	glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
	glfw.WindowHint(glfw.RESIZABLE, glfw.FALSE)

	created_window: glfw.WindowHandle = glfw.CreateWindow(
		width,
		height,
		strings.clone_to_cstring(name),
		nil,
		nil,
	)

	if created_window != nil {
		logger.print_str(win.logger, "Successfully create GLFW Window", logger.LogLevel.SUCCESS)
        glfw.MakeContextCurrent(created_window)
	} else {
		logger.print_str(win.logger, "Failed to create GLFW Window", logger.LogLevel.ERROR)
        glfw.Terminate()
        return false
	}

	win.window = created_window

	return true
}
