require("io")
require("os")
-- According to the IMAP specification, when trying to write a message
-- to a non-existent mailbox, the server must send a hint to the client,
-- whether it should create the mailbox and try again or not. However
-- some IMAP servers don't follow the specification and don't send the
-- correct response code to the client. By enabling this option the
-- client tries to create the mailbox, despite of the server's response.
-- This variable takes a boolean as a value.  Default is “false”.
---@diagnostic disable-next-line:undefined-global
options.create = true
-- By enabling this option new mailboxes that were automatically created,
-- get auto subscribed
---@diagnostic disable-next-line:undefined-global
options.subscribe = true
-- How long to wait for servers response.
---@diagnostic disable-next-line:undefined-global
options.timeout = 120

-- Update the include path with the local directory to allow imports appropriately
package.path = package.path .. ";" .. os.getenv("XDG_CONFIG_HOME") .. "/imapfilter/?.lua"

require("work")
require("home")
