fx_version 'adamant'

games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'Async for RedM, this is a completely rewritten resource by TigoDevelopment, will also work on FiveM'

server_script {
    'main.lua'
}

client_script {
    'main.lua'
}

exports {
    'getSharedObject'
}

server_exports {
    'getSharedObject'
}