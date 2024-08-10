package main

import app "src/controller"
import window "src/graphic"
import logger "src/logger"
import instance "src/renderer"
import glfw "vendor:glfw"

main :: proc() {

	l := logger.init(true, .DEBUG)

	logger.print_str(&l, "DEBUG")

	logger.set_mode(&l, true, .WARNING)
	logger.print_str(&l, "WARNING")

	logger.set_mode(&l, true, .ERROR)
	logger.print_str(&l, "ERROR")

    win := window.Window{nil, &l}
    window.build_window(800, 600, "VulkanOdin", &win)

    ins := instance.Instance{nil, &l}
    instance.make_instance(&ins, "VulkanOdin")

	main_app := app.App{&win, &l}
	app.main_loop(&main_app)

    app.destroy_window(&main_app)

    return
}
