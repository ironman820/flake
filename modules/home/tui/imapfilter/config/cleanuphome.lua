local M = {}

function M.cleanupHome(account)
  local util = require("utilities")
  local messages = account.INBOX:select_all()
  local trash = "[Gmail]/Trash"

  local spam
  local github = messages:contain_from("notifications@github.com")
  if #github > 0 then
    messages = messages - github
    local subjects = {
      "jellyfin/jellyfin",
      "netbox-community/netbox",
      "ublue-os/bluefin",
      "ironman820/ironman-ubuntu",
      "traefik/traefik",
      "dani-garcia/vaultwarden",
      "Wandmalfarbe/pandoc-latex-template",
    }
    for _, v in pairs(subjects) do
      local found = github:contain_subject(v)
      if #found > 0 then
        github = github - found
        util:filter_oldest(found, util.delete, account, trash)
      end
    end
  end
  github = nil

  messages = account.INBOX:select_all()
  spam = messages:contain_subject("Home NAS.*Active Backup")
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("no-reply@twitch.tv")
  local handle
  local init = false
  for _, message in ipairs(spam) do
    local mailbox, uid = table.unpack(message)
    local subject = mailbox[uid]:fetch_field("subject")
    local new_subject = util:hdr_decode(subject)
    if subject ~= new_subject then
      io.write(new_subject .. "\n")
    end
    if new_subject:lower():find("is live", 1, true) then
      handle = account.INBOX:send_query(uid)
      util.delete(handle, account, trash)
    end
  end

  messages = account.INBOX:select_all()
  spam = messages:contain_from("newsletter@email.ticketmaster.com")
    + messages:contain_from("myqinfo@info.chamberlain.com")
    + messages:contain_from("reply@emailinfo.buffalowildwings.com")
  util.delete(spam, account, trash)

  -- io.write("\n>>>> Archive extreneous messages\n")
  -- messages = account.INBOX:has_flag("save")
  -- if #messages > 0 then
  --   messages:mark_seen()
  --   messages:move_messages(account.Archive)
  -- end
end

setmetatable(M, {
  __call = function(_, account)
    return M.cleanupHome(account)
  end,
})

return M
