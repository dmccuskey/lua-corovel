#!/bin/sh

# this is just a simple shell script i used to run my project. it helps:
# * patch the LUA_PATH for library lookup
# * launch the project with my current command

# Note: you'll probably want to change: project libs, lua version, or command

# project specific dirs
project_libs="./libs/?.lua;./libs/dmc_corona/?.lua;./data_services/?.lua;"

# get default LUA_PATH
lua_path=$(lua5.1 -e "print(package.path)")

# add project dirs to LUA_PATH
LUA_PATH=$project_libs$lua_path

# run lua
export LUA_PATH ; lua5.1 corovel.lua commands.master
