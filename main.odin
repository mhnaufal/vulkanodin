package main

import "core:fmt"
import "core:thread"
import app "src/controller"
import window "src/graphic"
import logger "src/logger"
import engine "src/renderer"
import glfw "vendor:glfw"

main :: proc() {
	spawn_render_thread :: proc(l: ^logger.Logger, win: ^window.Window) {
		ins := engine.Instance{nil, l}
		eng := engine.create_engine(&ins, win)

		engine.destroy_vulkan(&eng)
	}

	l := logger.create_logger(true, .DEBUG)

	logger.print_str(&l, "DEBUG")

	logger.set_mode(&l, true, .WARNING)
	logger.print_str(&l, "WARNING")

	logger.set_mode(&l, true, .ERROR)
	logger.print_str(&l, "ERROR")

	win := window.Window{nil, &l}
	window.create_window(800, 600, "VulkanOdin", &win)

	num_threads := 2
	threads := make([]thread.Thread, num_threads)

	for i in 0 ..< num_threads {
		threads[i] = thread.create_and_start_with_poly_data2(&l, &win, spawn_render_thread)^
	}

	main_app := app.App{&win, &l}
	app.main_loop(&main_app)

	for &t in threads {
		thread.join(&t)
	}

	defer app.destroy_window(&main_app)
}
