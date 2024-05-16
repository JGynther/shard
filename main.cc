
#include "src/lua_bridge.cc"
#include <cstdlib>

int main() {
  Lua::state L = Lua::init();
  Lua::load_bindings(L);

  // Start Gameplay loop
  Lua::start(L);

  return EXIT_SUCCESS;
}