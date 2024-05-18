local ninja = require "tools.ninja"

local config = ninja.init()

-- Add basic compile flags
config:add_variable("compiler_flags", "-Wall -Wextra -O2 -std=c++2b")
config:add_variable("lib", "-lraylib -lluajit-5.1")
config:add_rule("clang", "clang++ $compiler_flags $lib $in -o $out")

-- Lua modules
config:add_variable("module_flags", "-shared -fPIC")
config:add_rule("build_lua_module", "clang++ $compiler_flags $module_flags -lluajit-5.1 $in -o $out")

-- Build Lua modules
local modules = ninja.utils.files_with_prefix("lua_", "tools")

for _, file in ipairs(modules) do
    local filename = ninja.utils.filename(file)
    local out = string.sub(filename, 5, -4) -- files start with lua_ and end in .cc
    config:add_build("tools/" .. out .. ".so", "build_lua_module", file)
end

-- Build main.cc
config:add_build("build/main", "clang", "main.cc")

-- Generate build.ninja
config:write_buildfile(config:generate())
