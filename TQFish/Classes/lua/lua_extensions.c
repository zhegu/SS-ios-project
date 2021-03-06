
#include "lua_extensions.h"

#if __cplusplus
extern "C" {
#endif

// cjson
#include "cjson/lua_cjson.h"

// socket
#include "socket/luasocket.h"
#include "socket/mime.h"

// filesystem
#include "filesystem/lfs.h"

static luaL_Reg luax_exts[] = {
    {"cjson", luaopen_cjson},
    {"socket.core", luaopen_socket_core},
    {"mime.core", luaopen_mime_core},
	{"lfs", luaopen_lfs},
    {NULL, NULL}
};

#include "tolua_fix.h"

void luaopen_lua_extensions(lua_State *L)
{
    luaL_Reg* lib = luax_exts;
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "preload");
    for (; lib->func; lib++)
    {
        lua_pushcfunction(L, lib->func);
        lua_setfield(L, -2, lib->name);
    }
    lua_pop(L, 2);
}

#if __cplusplus
} // extern "C"
#endif
