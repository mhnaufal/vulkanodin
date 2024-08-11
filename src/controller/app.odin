package app

import window "../graphic"
import logger "../logger"
import glfw "vendor:glfw"

App :: struct {
	window: ^window.Window,
	logger: ^logger.Logger,
}

main_loop :: proc(app: ^App) {
	for !glfw.WindowShouldClose(app.window.window) {
		glfw.SwapBuffers(app.window.window)
		glfw.PollEvents()
	}

	logger.print_str(app.logger, "Window CLosed", logger.LogLevel.ALL)
}

destroy_window :: proc(app: ^App) {
	glfw.DestroyWindow(app.window.window)
	glfw.Terminate()
}
