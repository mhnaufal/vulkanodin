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

	app.logger.level = .ALL
	logger.print_str(app.logger, "Window CLosed")
}

destroy_window :: proc(app: ^App) {
    glfw.DestroyWindow(app.window.window)
    glfw.Terminate()
}
