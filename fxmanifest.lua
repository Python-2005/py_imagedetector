fx_version "adamant"
game "gta5"
use_fxv2_oal "yes"
lua54 "yes"

name "py_imagedetector"
author "Python"
version "1.0.1"

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua"
}

server_scripts {
    "modules/*.lua"
}

dependency 'ox_lib'