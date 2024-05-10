local M = {}

function M.cleanupWork(account)
  local archive = "Archive"
  local messages = account.INBOX:select_all()
  local trash = "Trash"
  local util = require("utilities")

  local bsf = messages:match_from("noreply@royell.org") * messages:match_subject("Spam Quarantine Summary")
  if #bsf > 0 then
    messages = messages - bsf
    util:filter_oldest(bsf, util.delete, account, trash)
  end
  bsf = nil

  local accountingEmail = require("work_accounting_email")
  local csrEmail = require("work_csr_email")
  local myEmail = require("work_my_email")
  local rheaEmail = require("work_rhea_email")
  local voipEmail = require("work_voip_email")

  messages = account.INBOX:select_all()
  local spam
  for k, v in pairs(voipEmail) do
    if k == 1 then
      spam = messages:match_from(v)
      goto continue_sip
    end
    spam = spam + messages:match_from(v)
    :: continue_sip ::
  end
  spam = spam * (messages:match_subject("SIP Attack Notification") +
          messages:match_subject("sipPROT Daily Report") +
          (messages:match_subject("Voicemail.*blocked")))
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:match_subject('\\[ServerPlus.*escalation') + messages:match_subject("AutoSSL certificate installed") + messages:match_subject("Teams Essentials invoice") + messages:match_subject("Port Status Change") + messages:match_subject("Port Status Update") + messages:match_subject("Port Note Reply") + messages:match_subject("Abuse Report") + messages:match_subject("Compromised host")
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = (messages:match_from(accountingEmail) * messages:match_subject("Pay Stub"))
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:match_from(csrEmail)
    * (messages:match_subject("BillMax Batch Processing") + messages:match_subject("IPPay.*processing"))
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:match_from(myEmail) * (messages:match_subject("WMT report") + messages:match_subject("Storage.*Healthy"))
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:match_subject("Updated.*Schedule") * (messages:match_from(rheaEmail) + messages:match_from(csrEmail))
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:match_from("report-bounces@barracudanetworks.com") * (messages:match_subject("Top Outbound") + messages:match_subject("Report"))
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:match_from("info@bulkvs.com") * messages:match_subject("Credit Card Event")
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:match_from("sales@bicomsystems.com") * messages:match_subject("invoice")
  util.sort(spam, account, archive)

  messages = account.INBOX:select_all()
  spam = messages:match_from("uptimerobot.com")
    * (messages:match_subject("uptime report") + messages:match_subject("payment"))
  util.sort(spam, account, archive)

  local eset_email = require("work_eset_email")
  local senders = {
      "adamscableequipment.com",
      "mail.adobe.com",
      "actelisnetworks.ccsend.com",
      "alliancecorporation.ca",
      "amcsgroup.com",
      "antimetal-aws.me",
      "arelion.com",
      "bekapublishing.com",
      "shared1.ccsend.com",
      "wispa.ccsend.com",
      "ceragon.com",
      "safe.eset.com",
      "campaign.eventbrite.com",
      "facebookmail.com",
      "fs.com",
      "gotrango.com",
      "connect.hpe.com",
      "hwfiber.com",
      "imperva.com",
      "isemag-email.com",
      "koscomcable.com",
      "mail.marketingqualified.co",
      "mpowerinnovations.com",
      "eventbrite@ori.net",
      "picstelecom.com",
      "registerform9.com",
      "samsara.com",
      "email.samsara.com",
      "taranawireless.com",
      "tufin.com",
      "verizonconnect.com",
      "walsun.com",
      "wav_marketing@wavonline.com",
      "advertisements@wispa.org",
  }
  senders = util.table_append(senders, require("work_cleanup_senders"))

  ---@diagnostic disable-next-line:undefined-global
  spam = Set {}
  for _, v in pairs(senders) do
    table.insert(spam, messages:match_from(v))
  end
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:match_subject("YoLink.*Device Alarm") + messages:match_subject("techs.*offsite") + messages:match_subject("Unconfigured DIDs") + messages:match_subject("Calix.*cron")
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:match_subject("WISPA ") * (messages:match_subject("Board Meeting") + messages:match_subject("Newsletter") + messages:match_subject("Webinar"))
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:match_from(eset_email) * messages:match_subject("Outdated ESET Software")
  util.delete(spam, account, trash)

  messages = account.INBOX:select_all()
  spam = messages:match_from("noreply-maps-timeline@google.com")
  ---@diagnostic disable-next-line:undefined-global
  local handle = Set {}
  for _, message in ipairs(spam) do
    local mailbox, uid = table.unpack(message)
    local subject = mailbox[uid]:fetch_field("subject")
    if util:hdr_decode(subject):lower():find("royell", 1, true) then
        table.insert(handle, account.INBOX:send_query("SEARCH " .. uid))
    end
  end
  if #handle > 0 then
    util.delete(handle, account, trash)
  end
end

setmetatable(M, {
  __call = function(_, account)
    return M.cleanupWork(account)
  end,
})

return M
