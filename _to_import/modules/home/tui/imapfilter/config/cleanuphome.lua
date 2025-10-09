local M = {}

function M.cleanupHome(account)
  local util = require("utilities")
  local messages = account.INBOX:select_all()
  local trash = "[Gmail]/Trash"
  local archive = "[Gmail]/All Mail"

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
    + (messages:contain_subject("installed on") * messages:contain_subject("device"))
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("no-reply@twitch.tv")

  ---@diagnostic disable-next-line:undefined-global
  local handle = Set({})
  for _, message in ipairs(spam) do
    local mailbox, uid = table.unpack(message)
    local subject = mailbox[uid]:fetch_field("subject")
    local new_subject = util:hdr_decode(subject)
    if new_subject:lower():find("is live", 1, true) then
      table.insert(handle, message)
    end
  end
  util.delete(handle, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("newsletter@email.ticketmaster.com")
    + messages:contain_from("myqinfo@info.chamberlain.com")
    + messages:contain_from("reply@emailinfo.buffalowildwings.com")
    + messages:contain_from("redrobin.com")
    + messages:contain_from("doctorondemand.com")
    + messages:contain_from("adguard.com")
    + messages:contain_from("likewise.com")
    + messages:contain_from("walmart.com")
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("chase.com")
    * messages:contain_subject("debit card transaction of")
    * messages:is_older(7)
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("microsoft.com") * messages:contain_subject("have more screen time")
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("citi.com")
    * messages:contain_subject("increased")
    * messages:contain_subject("credit limit")
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("paypal.com")
    - messages:contain_subject("receipt")
    - messages:contain_subject("account statement")
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("paypal.com") * messages:is_older(7)
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("google.com")
    * (messages:contain_subject("receipt") + messages:contain_subject("statement"))
    * messages:is_older(7)
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("google.com") * messages:contain_subject("Nest Renew monthly impact")
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("google.com")
    * (
      messages:contain_subject("Weekly summary")
      + messages:contain_subject("Invitation")
      + messages:contain_subject("Canceled")
      + messages:contain_subject("has access to Lily")
      + messages:contain_subject("finish setting up your")
    )
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("google.com") * messages:contain_subject("Security alert") * messages:is_older(7)
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("google.com") * messages:contain_from("maps") * messages:contain_subject("update")
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("creditkarma.com")
    * (
      messages:contain_subject("new credit card")
      + messages:contain_subject("Refinancing")
      + messages:contain_subject("Approval Odds")
      + messages:contain_subject("sweepstakes")
      + messages:contain_subject("estimated value")
      + messages:contain_subject("refund")
      + messages:contain_subject("credit card options")
      + messages:contain_subject("loan")
      + messages:contain_subject("equity")
      + (messages:contain_subject("tax") * messages:contain_subject("file"))
      + (messages:contain_subject("score") * messages:is_older(7))
    )
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("creditkarma.com") - (messages:contain_subject("score") * messages:is_newer(7))
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("linkedin.com") * messages:is_older(7)
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:contain_from("goodreads.com")
    - (messages:is_newer(7) * messages:contain_subject("Giveaway"))
    - messages:contain_subject("is now available")
  util.delete(spam, account, trash)

  -- messages = account.INBOX:select_all()
  -- spam = messages:contain_from("goodreads.com")
  -- util:print_subject(spam)

  messages = account[trash]:select_all()
  local delete = messages:is_older(7)
  delete:delete_messages()
end

setmetatable(M, {
  __call = function(_, account)
    return M.cleanupHome(account)
  end,
})

return M
