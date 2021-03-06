box.cfg
{
    pid_file = nil,
    background = false,
    log_level = 5,
    listen = 3301
}
local function create_spaces_and_indecies()
    space1 = box.schema.space.create('primary_only_index', { if_not_exists = true })
    space1:create_index('primary', {type='hash', parts={1, 'unsigned'}, if_not_exists = true})

    performanceSpace = box.schema.space.create('performance', { if_not_exists = true })
    performanceSpace:create_index('primary', {type='hash', parts={1, 'unsigned'}, if_not_exists = true})

    space2 = box.schema.space.create('primary_and_secondary_index', { if_not_exists = true })
    space2:create_index('hashIndex', {type='hash', parts={1, 'unsigned'}, if_not_exists = true })
    space2:create_index('treeIndex', {type='tree', parts={1, 'unsigned'}, if_not_exists = true })
end

local function init()
    create_spaces_and_indecies()

    box.schema.user.create('notSetPassword', { if_not_exists = true })
    box.schema.user.create('emptyPassword', { password = '', if_not_exists = true })

    box.schema.user.create('operator', {password = 'operator', if_not_exists = true })
    box.schema.user.grant('operator','read,write,execute','universe', { if_not_exists = true })
    box.schema.user.grant('guest','read,write,execute','universe', { if_not_exists = true })
    box.schema.user.passwd('admin', 'adminPassword')
end

local function space_TreeIndexMethods()
    space = box.schema.space.create('space_TreeIndexMethods', { if_not_exists = true })
    space:create_index('treeIndex', {type='tree', parts={1, 'unsigned'}, if_not_exists = true })

    space:auto_increment{'asdf', 10.1}
    space:auto_increment{'zcxv'}
    space:auto_increment{2, 3}
end

box.once('init', init)
box.once('space_TreeIndexMethods', space_TreeIndexMethods)

local log = require('log')

function log_connect ()
    local m = 'Connection. user=' .. box.session.user() .. ' id=' .. box.session.id()
    log.info(m)
end
function log_disconnect ()
    local m = 'Disconnection. user=' .. box.session.user() .. ' id=' .. box.session.id()
    log.info(m)
end

function log_auth ()
    local m = 'Authentication attempt'
    log.info(m)
end
function log_auth_ok (user_name)
    local m = 'Authenticated user ' .. user_name
    log.info(m)
end

box.session.on_connect(log_connect)
box.session.on_disconnect(log_disconnect)
box.session.on_auth(log_auth)
box.session.on_auth(log_auth_ok)

function return_null()
    log.info('return_null called')
    return require('msgpack').NULL
end

function return_tuple_with_null()
    log.info('return_tuple_with_null called')
    return { require('msgpack').NULL }
end

function return_tuple()
    log.info('return_tuple called')
    return { 1, 2 }
end


function return_array()
    log.info('return_array called')
    return {{ "abc", "def" }}
end

function return_scalar()
    log.info('return_scalar called')
    return 1
end

function return_nothing()
    log.info('return_nothing called')
end

local truncate_space = function(name)
	local space = box.space[name]
	if space then
		log.info("Truncating space %s...", name)
		space:truncate()
		log.info("Space %s trancated.", name)
	else
		log.warning("There is no space %s", name)
	end
end

function clear_data()
    log.info('clearing data...')

    truncate_space('primary_only_index')
    truncate_space('performance')
    truncate_space('primary_and_secondary_index')
    truncate_space('space_TreeIndexMethods')
end