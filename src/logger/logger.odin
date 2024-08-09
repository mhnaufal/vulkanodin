package logger

import "core:fmt"
import vk "vendor:vulkan"

LogLevel :: enum {
	ALL = 0,
	DEBUG,
	SUCCESS,
	WARNING,
	ERROR,
}

Logger :: struct {
	enabled: bool,
	level:   LogLevel,
}

init :: proc(mode: bool, log_level: LogLevel) -> Logger {
	l := Logger{true, log_level}
	return l
}

is_enabled :: proc(logger: ^Logger) -> bool {
	return logger.enabled
}

set_mode :: proc(logger: ^Logger, mode: bool, log_level: LogLevel) {
	logger.enabled = mode
	logger.level = log_level
}

print_str :: proc(logger: ^Logger, message: string) {
	if !logger.enabled {
		return
	}

	red :: "\033[0;31m"
	yellow :: "\033[1;33m"
	green :: "\033[0;32m"
	blue :: "\033[0;34m"
	gray :: "\033[1;30m"

	if logger.level == .ALL {
		fmt.printfln("%s %s", gray, message)
	} else if logger.level == .DEBUG {
		fmt.printfln("%s %s", blue, message)
	} else if logger.level == .SUCCESS {
		fmt.printfln("%s %s", green, message)
	} else if logger.level == .WARNING {
		fmt.printfln("%s %s", yellow, message)
	} else if logger.level == .ERROR {
		fmt.printfln("%s %s", red, message)
	} else {
		fmt.printfln("%s %s", gray, message)
	}
}

print_version :: proc(logger: ^Logger, version: uint) {
	if !logger.enabled {
		return
	}

	// fmt.printfln(
	//     "System can support Vulkan: %s", vk.version
	// );
}
