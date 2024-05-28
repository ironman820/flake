local M = {}

function M.cleanupWork(account)
  local archive = "Archive"
  local util = require("utilities")
  local messages, empty_set
  -- messages = account.INBOX:select_all()
  -- messages:unmark_seen()
  messages, empty_set = util:select_messages(account, 'INBOX', true)
  if empty_set then
    return
  end
  local bsf
  local trash = "Trash"
  local accountingEmail = require("work_accounting_email")
  local csrEmail = require("work_csr_email")
  local myEmail = require("work_my_email")
  local rheaEmail = require("work_rhea_email")
  local voipEmail = require("work_voip_email")
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
      "demandgeneration@calix.com",
      "events@calix.com",
      "webinars@calix.com",
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
  local handle
  local spam

  while #messages > 0 do
    bsf = messages:contain_from("noreply@royell.org") * messages:contain_subject("Spam Quarantine Summary")
    if #bsf > 0 then
      util:filter_oldest(bsf, util.delete, account, trash)
    end
    bsf = nil

    messages, empty_set = util:select_messages(account, 'INBOX', true)
    if empty_set then goto next_loop end

    for k, v in pairs(voipEmail) do
      if k == 1 then
        spam = messages:contain_from(v)
        goto continue_sip
      end
      spam = spam + messages:contain_from(v)
      :: continue_sip ::
    end
    spam = spam * (messages:contain_subject("SIP Attack Notification") +
            messages:contain_subject("sipPROT Daily Report") +
            (messages:match_subject("Voicemail.*blocked")))
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.sort(spam, account, archive)
    if empty_set then goto next_loop end

    spam = messages:match_subject('\\[ServerPlus.*escalation') + messages:match_subject("AutoSSL certificate installed") + messages:match_subject("Teams Essentials invoice") + messages:match_subject("Port Status Change") + messages:match_subject("Port Status Update") + messages:match_subject("Port Note Reply") + messages:match_subject("Abuse Report") + messages:match_subject("Compromised host")
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.sort(spam, account, archive)
    if empty_set then goto next_loop end

    spam = (messages:match_from(accountingEmail) * messages:match_subject("Pay Stub"))
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.sort(spam, account, archive)
    if empty_set then goto next_loop end

    spam = messages:match_from(csrEmail)
      * (messages:match_subject("BillMax Batch Processing") + messages:match_subject("IPPay.*processing"))
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.sort(spam, account, archive)
    if empty_set then goto next_loop end

    spam = messages:match_from(myEmail) * (messages:match_subject("WMT report") + messages:match_subject("Storage.*Healthy"))
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.sort(spam, account, archive)
    if empty_set then goto next_loop end

    spam = messages:match_subject("Updated.*Schedule") * (messages:match_from(rheaEmail) + messages:match_from(csrEmail))
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.sort(spam, account, archive)
    if empty_set then goto next_loop end

    spam = messages:match_from("report-bounces@barracudanetworks.com") * (messages:match_subject("Top Outbound") + messages:match_subject("Report"))
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.sort(spam, account, archive)
    if empty_set then goto next_loop end

    spam = messages:match_from("info@bulkvs.com") * messages:match_subject("Credit Card Event")
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.sort(spam, account, archive)
    if empty_set then goto next_loop end

    spam = messages:match_from("sales@bicomsystems.com") - messages:match_subject("invoice")
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.delete(spam, account, trash)
    if empty_set then goto next_loop end

    spam = messages:match_from("sales@bicomsystems.com")
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.sort(spam, account, archive)
    if empty_set then goto next_loop end

    spam = messages:match_from("uptimerobot.com")
      * (messages:match_subject("uptime report") + messages:match_subject("payment"))
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.sort(spam, account, archive)
    if empty_set then goto next_loop end

    ---@diagnostic disable-next-line:undefined-global
    spam = Set {}
    for _, v in pairs(senders) do
      util.table_append(spam, messages:match_from(v))
    end
    if #spam > 0 then
      messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
      util.delete(spam, account, trash)
    end
    if empty_set then goto next_loop end

    spam = messages:match_subject("YoLink.*Device Alarm") + messages:match_subject("techs.*offsite") + messages:match_subject("Unconfigured DIDs") + messages:match_subject("Calix.*cron")
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.delete(spam, account, trash)
    if empty_set then goto next_loop end

    spam = messages:match_subject("WISPA ") * (messages:match_subject("Board Meeting") + messages:match_subject("Newsletter") + messages:match_subject("Webinar"))
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.delete(spam, account, trash)
    if empty_set then goto next_loop end

    spam = messages:match_from(eset_email) * messages:match_subject("Outdated ESET Software")
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.delete(spam, account, trash)
    if empty_set then goto next_loop end

    spam = messages:match_from("noreply.*@google.com") * (messages:match_subject("Royell") + messages:match_subject("A_new_device_is_contributing_to_your_Location"))
    ---@diagnostic disable-next-line:undefined-global
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, false, spam)
    util.delete(spam, account, trash)
    if empty_set then goto next_loop end

    -- ::calix::
    -- spam = messages:match_from("calix.com")
    -- for _, message in ipairs(spam) do
    --   local mailbox, uid = table.unpack(message)
    --   local subject = mailbox[uid]:fetch_field("subject")
    --   local parsed_subject = util:hdr_decode(subject):lower():gsub("\r\n\t", "")
    --   io.write(parsed_subject .. "\n")
    -- end
    -- ---@diagnostic disable-next-line:undefined-global
    -- messages = Set {}
    -- empty_set = false
    messages, empty_set = util:select_messages(account, 'INBOX', false, messages, true)

    ::next_loop::
    if empty_set then
      messages, _ = util:select_messages(account, 'INBOX', true)
    end
  end
end

setmetatable(M, {
  __call = function(_, account)
    return M.cleanupWork(account)
  end,
})

return M
