local ninja = require "tools.ninja"

local config = ninja.init()

config:add_variable("compiler_flags", "-Wall -Wextra -O2 -std=c++2b")
config:add_variable("lib", "-lraylib -lluajit-5.1")
config:add_rule("clang", "clang++ $compiler_flags $lib $in -o $out")
config:add_build("build/main", "clang", "main.cc")

config:write_buildfile(config:generate())
