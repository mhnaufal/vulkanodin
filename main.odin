package main

import app "src/controller"
import window "src/graphic"
import logger "src/logger"
import instance "src/renderer"

main :: proc() {

	l := logger.init(true, .DEBUG)

	logger.print_str(&l, "DEBUG")

	logger.set_mode(&l, true, .WARNING)
	logger.print_str(&l, "WARNING")

	logger.set_mode(&l, true, .ERROR)
	logger.print_str(&l, "ERROR")

    win := window.Window{nil, &l}
    window.build_window(1080, 720, "VulkanOdin", &win)

	main_app := app.App{&win, &l}

	app.main_loop(&main_app)

    ins := instance.Instance{nil, &l}
    ins.instance^ = instance.make_instance(&ins, "VulkanOdin").? or_else nil
}
