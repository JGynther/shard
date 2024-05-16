#include "lua.hpp"
#include "raylib.h"
#include <lua.h>

#define NO_RETURN_VALUES 0
#define ONE_RETURN_VALUE 1

typedef lua_State *state;
typedef const char *string; // Lua string

#define REGISTER_FUNCTION(name)                                                \
  lua_register(L, "CC_RAYLIB_" #name, Bindings::name)

#define RAYLIB_EMPTY_CALL(name)                                                \
  int name([[maybe_unused]] lua_State *L) {                                    \
    ::name();                                                                  \
    return NO_RETURN_VALUES;                                                   \
  }

namespace Bindings {

int InitWindow(state L) {
  int width = luaL_checknumber(L, 1);
  int height = luaL_checknumber(L, 2);
  string title = luaL_checkstring(L, 3);

  ::InitWindow(width, height, title);
  SetTargetFPS(60);

  return NO_RETURN_VALUES;
}

int WindowShouldClose(state L) {
  bool should_close = ::WindowShouldClose();
  lua_pushboolean(L, should_close);

  return ONE_RETURN_VALUE;
}

RAYLIB_EMPTY_CALL(CloseWindow)
RAYLIB_EMPTY_CALL(BeginDrawing)
RAYLIB_EMPTY_CALL(EndDrawing)

} // namespace Bindings

namespace Lua {

// Make state available through Lua::
typedef state state;

state init() {
  state L = luaL_newstate();
  luaL_openlibs(L);
  return L;
}

void load_bindings(state L) {
  REGISTER_FUNCTION(InitWindow);
  REGISTER_FUNCTION(WindowShouldClose);
  REGISTER_FUNCTION(CloseWindow);
  REGISTER_FUNCTION(BeginDrawing);
  REGISTER_FUNCTION(EndDrawing);
}

void start(state L, const char *file = "src/main.lua") {
  bool test = luaL_dofile(L, file);
}

} // namespace Lua