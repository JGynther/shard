local templates = {
    build = "build %s: %s %s\n",
    variable = "%s = %s\n",
    rule = [[
rule %s
    command = %s
]],
    base = [[
# Generated by tools/ninja.lua

ninja_required_version = 1.11.0

root = .
builddir = build
]]
}

local function add_from_template(table, template, key, ...)
    local formatted = string.format(templates[template], key, ...)
    table._count = table._count + 1
    table[template][key] = { value = formatted, order = table._count }
end

local function merge_tables(...)
    local result = {}

    for _, table in ipairs({ ... }) do
        for _, value in pairs(table) do
            -- This also ends up sorting the table
            result[value.order] = value.value
        end
    end

    return result
end

local function init()
    local _ninja = {
        _count = 1,
        rule = {},
        build = {},
        variable = {}
    }

    function _ninja:add_rule(name, value)
        add_from_template(self, "rule", name, value)
    end

    function _ninja:add_build(target, rule, source)
        add_from_template(self, "build", target, rule, source)
    end

    function _ninja:add_variable(name, value)
        add_from_template(self, "variable", name, value)
    end

    -- Generate buildfile based on added attributes
    function _ninja:generate()
        local base = { { order = 1, value = templates["base"] } }
        local merged = merge_tables(base, self.rule, self.build, self.variable)
        return table.concat(merged, "\n")
    end

    function _ninja:write_buildfile(config, filename)
        filename = filename or "build.ninja"
        local buildfile = io.open(filename, "w")
        if not buildfile then error("Could not load file: " .. filename) end
        buildfile:write(config)
    end

    return _ninja
end

local file_util = require "tools.file_util"

local utils = {
    files_with_prefix = function(prefix, dir)
        return file_util.list_dir_with_prefix(prefix, dir)
    end,

    files_with_suffix = function(suffix, dir)
        return file_util.list_dir_with_suffix(suffix, dir)
    end,

    filename = function(path)
        return file_util.filename(path)
    end
}

local ninja = {
    init = init,
    utils = utils
}

return ninja
