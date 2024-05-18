#include "lua.hpp"
#include <filesystem>

typedef const char *string;

template <bool Filter, bool isPrefix>
int list_dir_base(lua_State *L, string dir, string filter = "") {
  lua_newtable(L);
  int index = 1;

  for (auto &entry : std::filesystem::directory_iterator(dir)) {
    std::string path = entry.path();

    if constexpr (Filter && isPrefix) {
      std::string filename = std::filesystem::path(path).filename();
      if (!filename.starts_with(filter))
        continue;
    }

    if constexpr (Filter && !isPrefix) {
      std::string filename = std::filesystem::path(path).filename();
      if (!filename.ends_with(filter))
        continue;
    }

    lua_pushnumber(L, index);
    lua_pushstring(L, path.c_str());
    lua_settable(L, -3);

    ++index;
  }

  return 1;
}

int list_dir(lua_State *L) {
  string dir = luaL_checkstring(L, 1);
  return list_dir_base<false, false>(L, dir);
}

int list_dir_with_prefix(lua_State *L) {
  string prefix = luaL_checkstring(L, 1);
  string dir = luaL_checkstring(L, 2);
  return list_dir_base<true, true>(L, dir, prefix);
}

int list_dir_with_suffix(lua_State *L) {
  string suffix = luaL_checkstring(L, 1);
  string dir = luaL_checkstring(L, 2);
  return list_dir_base<true, false>(L, dir, suffix);
}

static const struct luaL_Reg file_util[] = {
    {"list_dir", list_dir},
    {"list_dir_with_prefix", list_dir_with_prefix},
    {"list_dir_with_suffix", list_dir_with_suffix},
    {NULL, NULL},
};

extern "C" int luaopen_tools_file_util(lua_State *L) {
  luaL_newlib(L, file_util);
  return 1;
}