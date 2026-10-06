fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
games { 'rdr3' }

version '1.0.0'
author 'Your Name'
description 'Location-based Notifications using bln_notify'

lua54 'yes'

client_scripts {
    'config.lua',
    'client/hologram.lua'
}

dependencies {
    'bln_notify'
}
