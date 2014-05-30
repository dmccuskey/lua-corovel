#!/bin/sh

# project specific dirs
project_libs="./libs/?.lua;./libs/dmc_lua/?.lua;./data_services/?.lua;"

# get default LUA_PATH
lua_path=$(lua5.1 -e "print(package.path)")

# add project dirs to LUA_PATH
LUA_PATH=$project_libs$lua_path

# run lua
export LUA_PATH ; lua5.1 corovel.lua commands.master
