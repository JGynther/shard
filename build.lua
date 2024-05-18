local ninja = require "tools.ninja"

local config = ninja.init()

-- Add basic compile flags
config:add_variable("compiler_flags", "-Wall -Wextra -O2 -std=c++2b")
config:add_rule("clang", "clang++ $compiler_flags -c $in -o $out")

-- Lua modules
config:add_variable("module_flags", "-shared -fPIC")
config:add_rule("build_lua_module", "clang++ $compiler_flags $module_flags -lluajit-5.1 $in -o $out")

-- Build Lua modules
local modules = ninja.utils.files_with_prefix("lua_", "tools")

for _, file in ipairs(modules) do
    local filename = ninja.utils.filename(file)
    local out = string.sub(filename, 5, -4) .. ".so" -- files start with lua_ and end in .cc
    config:add_build("tools/" .. out, "build_lua_module", file)
end

-- Build source files
local sources = ninja.utils.files_with_suffix(".cc", "src")

local targets = {}

for _, file in ipairs(sources) do
    local filename = ninja.utils.filename(file)
    local out = "build/" .. string.sub(filename, 0, -4) .. ".o"

    table.insert(targets, out)

    config:add_build(out, "clang", file)
end

-- Link object files
config:add_variable("lib", "-lraylib -lluajit-5.1")
config:add_rule("link", "clang++ $lib $in -o $out")
config:add_build("shard", "link", table.concat(targets, " "))

-- Build main.cc
-- config:add_build("build/main", "clang", "main.cc")

-- Generate build.ninja
config:write_buildfile(config:generate())
