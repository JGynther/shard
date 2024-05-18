#include "lua.hpp"

namespace Lua {
typedef lua_State *state;
typedef const char *string;

state init();
void load_bindings(state L);
void start(state L, string file = "src/main.lua");

} // namespace Lua
