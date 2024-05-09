require("io")
require("os")
-- According to the IMAP specification, when trying to write a message
-- to a non-existent mailbox, the server must send a hint to the client,
-- whether it should create the mailbox and try again or not. However
-- some IMAP servers don't follow the specification and don't send the
-- correct response code to the client. By enabling this option the
-- client tries to create the mailbox, despite of the server's response.
-- This variable takes a boolean as a value.  Default is “false”.
options.create = true
-- By enabling this option new mailboxes that were automatically created,
-- get auto subscribed
options.subscribe = true
-- How long to wait for servers response.
options.timeout = 120

-- Update the include path with the local directory to allow imports appropriately
package.path = package.path .. ";" .. os.getenv("XDG_CONFIG_HOME") .. "/imapfilter/?.lua"

local clock = os.clock
local function sleep(n) -- seconds
  local t0 = clock()
  while clock() - t0 <= n do
  end
end

local function cleanupWork(account)
  sleep(1)
  io.write(">>>> Setting up flags\n")

  local messages = account.INBOX:select_all()

  io.write(">>>> Processing Barracuda Emails\n")
  local bsf = messages:contain_from("noreply@royell.org") * messages:contain_subject("Spam Quarantine Summary")
  if #bsf > 0 then
    local findNewest = require("findnewest")
    local tempdate = findNewest(bsf, 1)
    local barracuda = bsf:sent_before(tempdate)
    if #barracuda > 0 then
      barracuda:add_flags({ "del" })
      messages = messages - barracuda
    end
  end
  bsf = nil

  local accountingEmail = require("work_accounting_email")
  local csrEmail = require("work_csr_email")
  local myEmail = require("work_my_email")
  local rheaEmail = require("work_rhea_email")
  local voipEmail = require("work_voip_email")

  io.write(">>>> Processing SIP attack notifications")
  local spam
  for k, v in pairs(voipEmail) do
    io.write(".")
    if k == 1 then
      spam = messages:contain_from(v)
      goto continue_sip
    end
    spam = spam + messages:contain_from(v)
    :: continue_sip ::
  end
  spam = spam * (messages:contain_subject("SIP Attack Notification") +
          messages:contain_subject("sipPROT Daily Report") +
          (messages:contain_subject("Voicemail") * messages:contain_subject("blocked")))
  io.write("\n>>>> Processing other spam")
  spam = spam + (messages:contain_subject("ServerPlus") * messages:contain_subject("escalation"))
  io.write(".")
  spam = spam + messages:contain_subject("AutoSSL certificate installed")
  io.write(".")
  spam = spam + messages:contain_subject("Teams Essentials invoice")
  io.write(".")
  spam = spam + messages:contain_subject("Port Status Change")
  io.write(".")
  spam = spam + messages:contain_subject("Port Status Update")
  io.write(".")
  spam = spam + messages:contain_subject("Port Note Reply")
  io.write(".")
  spam = spam + messages:contain_subject("Abuse Report")
  io.write(".")
  spam = spam + messages:contain_subject("Compromised host")
  io.write(".")
  spam = spam + (messages:contain_from(accountingEmail) * messages:contain_subject("Pay Stub"))
  io.write(".")
  spam = spam + (messages:contain_from(csrEmail) *
          (messages:contain_subject("Billmax Batch Processing") +
          (messages:contain_subject("IPPay") * messages:contain_subject("processing"))))
  io.write(".")
  spam = spam + (messages:contain_from(myEmail) *
          (messages:contain_subject("WMT report") +
          (messages:contain_subject("Storage") * messages:contain_subject("Healthy"))))
  io.write(".")
  spam = spam + (messages:contain_subject("Updated") * messages:contain_subject("Schedule") *
                (messages:contain_from(rheaEmail) + messages:contain_from(csrEmail)))
  io.write(".")
  spam = spam + messages:contain_from("report-bounces@barracudanetworks.com") *
                (messages:contain_subject("Top Outbound") + messages:contain_subject("Report"))
  io.write(".")
  spam = spam + (messages:contain_from("info@bulkvs.com") * messages:contain_subject("Credit Card Event"))
  io.write(".")
  spam = spam + (messages:contain_from("sales@bicomsystems.com") * messages:contain_subject("invoice"))
  io.write(".")
  spam = spam + (messages:contain_from("info@uptimerobot.com") * messages:contain_subject("uptime report"))
  if #spam > 0 then
    spam:add_flags({ "save" })
    messages = messages - spam
  end

  local esetEmail = require("work_eset_email")
  local senders = require("work_cleanup_senders")

  spam = nil
  io.write("\n>>>> Processing senders list\n")
  for k, v in pairs(senders) do
    io.write(">>>>>> " .. v .. "\n")
    if k == 1 then
      spam = messages:contain_from(v)
      goto continue_spam
    end
    spam = spam + messages:contain_from(v)
    :: continue_spam ::
  end
  spam = spam + (messages:contain_subject("YoLink") * messages:contain_subject("Device Alarm"))
  io.write(".")
  spam = spam + (messages:contain_subject("techs") * messages:contain_subject("offsite"))
  io.write(".")
  spam = spam + messages:contain_subject("Unconfigured DIDs")
  io.write(".")
  spam = spam + (messages:contain_subject("WISPA ") *
            (messages:contain_subject("Board Meeting") +
            messages:contain_subject("Newsletter") +
            messages:contain_subject("Webinar")))
  io.write(".")
  spam = spam + (messages:contain_subject("Calix") * messages:contain_subject("cron"))
  io.write(".")
  spam = spam + (messages:contain_from(esetEmail) * messages:contain_subject("Outdated ESET software"))
  io.write(".\n")
  spam = spam + (messages:contain_from("noreply-maps-timeline@google.com") * messages:contain_subject("Royell"))
  if #spam > 0 then
    spam:add_flags({ "del" })
    messages = messages - spam
  end
  spam = nil

  io.write("\n>>>> Archive extreneous messages\n")
  messages = account.INBOX:has_flag("save")
  if #messages > 0 then
    messages:mark_seen()
    messages:move_messages(account.Archive)
  end

  io.write(">>>> Deleting trash messages\n")
  messages = account.INBOX:has_flag("del")
  if #messages > 0 then
    messages:move_messages(account.Trash)
  end

  sleep(1)
end

local function cleanupHome(account)
end

local accounts = {}
accounts.work = require("work")
accounts.home = require("home")

for k, v in pairs(accounts) do
  if k == "work" and v ~= nil then
    io.write(">> Processing work emails\n")
    cleanupWork(v)
  end
  if k == "home" and v ~= nil then
    io.write(">> Processing home emails\n")
    cleanupHome(v)
  end
end
