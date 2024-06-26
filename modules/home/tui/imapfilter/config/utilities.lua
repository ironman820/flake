local M = {}

function M.delete(messages, account, trash)
  local todo = messages:select_all()
  todo:move_messages(account[trash])
end

local months = {
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
}

--- Returns the date 30 days ago
---@return string date_minus_30 The date formatted in an imapfilter friendly string
function M.date_minus_30()
  local now = os.date("*t", os.time())
  now.day = now.day - 30
  return os.date("%d-%b-%Y", os.time(now))
end

--- Returns a table of strings split on the provided separator
---@param text string String to split
---@param separator string String to separate the text on
---@return table t
function M.date_split(text, separator)
  if separator == nil then
    separator = "%s"
  end
  local t = {}
  for str in string.gmatch(text, "([^" .. separator .. "]+)") do
    for k, v in pairs(months) do
      if str == v then
        str = "" .. k
      end
    end
    table.insert(t, str)
  end
  return t
end

--- Filter all messages older than the last on received
---@param messages table List of messages to parse
---@param filter_method function Function to use on the filtered messages
---@param account any the message is in
---@param folder string Folder to pass to the filter method
function M:filter_oldest(messages, filter_method, account, folder)
  if #messages <= 1 then
    return
  end
  local mailbox, uid = table.unpack(messages[1])
  local new_messages = messages
  local changed = true
  local keep = mailbox[uid]
  while changed do
    changed = false
    local date = mailbox[uid]:fetch_date()
    local lastDate = self.date_split(string.sub(date, 1, string.find(date, " ")), "-")
    for _, message in ipairs(messages) do
      local _, current_uid = table.unpack(message)
      if current_uid == uid or changed then
        goto next_message
      end
      date = mailbox[current_uid]:fetch_date()
      local this_date = self.date_split(string.sub(date, 1, string.find(date, " ")), "-")
      local date_diff = os.difftime(
        os.time({ day = this_date[1], month = this_date[2], year = this_date[3] }),
        os.time({ day = lastDate[1], month = lastDate[2], year = lastDate[3] })
      )
      if date_diff > 0 then
        uid = current_uid
        changed = true
      end
      ::next_message::
    end
    date = mailbox[uid]:fetch_date()
    keep = messages:arrived_on(string.sub(date, 1, string.find(date, " ")))
  end
  io.write(#messages .. "\n")
  new_messages = messages - keep
  io.write(#messages .. "\n")
  filter_method(new_messages, account, folder)
end

--- Finds the newest message id from the list of messages
---@param messages table List of messages to parse
---@return table|nil
function M:findNewest(messages)
  if #messages == 0 then
    return nil
  end
  local mailbox, uid = table.unpack(messages[1])
  if #messages == 1 then
    return messages[1]
  end
  local date = mailbox[uid]:fetch_date()
  local lastDate = self.date_split(string.sub(date, 1, string.find(date, " ")), "-")
  local newest_uid = uid
  local last_diff = 0
  for _, message in ipairs(messages) do
    local _, current_uid = table.unpack(message)
    if current_uid == uid then
      goto next_message
    end
    date = mailbox[current_uid]:fetch_date()
    local this_date = self.date_split(string.sub(date, 1, string.find(date, " ")), "-")
    local date_diff = os.difftime(
      os.time({ day = this_date[1], month = this_date[2], year = this_date[3] }),
      os.time({ day = lastDate[1], month = lastDate[2], year = lastDate[3] })
    )
    if date_diff > last_diff then
      last_diff = date_diff
      newest_uid = current_uid
    end
    ::next_message::
  end

  for k, v in ipairs(messages) do
    local _, current_uid = table.unpack(v)
    if current_uid == newest_uid then
      return messages[k]
    end
  end
  return nil
end

function M:hdr_decode(s)
  local i, j = s:lower():find("=?utf-8?q?", 1, true)
  if i then
    local k, l = s:find("?=", j + 1, true)
    local s_ = s:sub(j + 1, k - 1):gsub("_", " "):gsub("=([a-fA-F0-9][a-fA-F0-9])", function(c)
      return string.char(tonumber(c, 16)):gsub("\r\n\t", "")
    end)
    return self:hdr_decode(s:sub(1, i - 1) .. s_ .. s:sub(l + 1)):gsub("\r\n\t", "")
  end

  i, j = s:lower():find("=?utf-8?b?", 1, true)
  if i then
    local k, l = s:find("?=", j, true)
    local s_ = s:sub(j + 1, k - 1):gsub("[%w%+/][%w%+/][%w%+/=][%w%+/=]", function(w)
      local digits = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
      local a = digits:find(w:sub(1, 1), 1, true)
      local b = digits:find(w:sub(2, 2), 1, true)
      local c = digits:find(w:sub(3, 3), 1, true)
      local d = digits:find(w:sub(4, 4), 1, true)
      return string
        .char(
          (a - 1) * 4 + math.floor((b - 1) / 16),
          (b - 1) % 16 * 16 + math.floor(((c or 1) - 1) / 4),
          ((c or 1) - 1) % 4 * 64 + ((d or 1) - 1)
        )
        :sub(1, d and 3 or c and 2 or 1)
        :gsub("\r\n\t", "")
    end)
    return self:hdr_decode(s:sub(1, i - 1) .. s_ .. s:sub(l + 1)):gsub("\r\n\t", "")
  end

  return s:gsub("\r\n\t", "")
end

function M:print_subject(messages)
  for _, message in ipairs(messages) do
    local mailbox, uid = table.unpack(message)
    local subject = mailbox[uid]:fetch_field("subject")
    local subject_ = subject:sub(subject:find(":") + 1, -1)
    io.write(subject_ .. "\n")
  end
end

function M.select_25(messages)
  local counter = 1
  ---@diagnostic disable-next-line:undefined-global
  local t = Set({})
  for _, message in ipairs(messages) do
    if counter < 26 then
      table.insert(t, message)
    end
    counter = counter + 1
  end
  return t
end

--- Processes messages from the selected account and returns a
--- list of new messages to be processed, maintaining a list of
--- at most 25 messages. Optionally marking messages as read.
---@param account IMAP The account to check for messages
---@param folder string The folder to check
---@param start_new boolean Whether to start a new listing or not
---@param[opt={}] old_messages Set a table of the currently selected messages (default {})
---@param[opt=false] mark_read boolean Whether to mark messages in the old_messages list as read (default false)
---@param[opt={}] spam_messages Set a table of spam messages to remove from old_messages before processing (default {})
---@return table # List of new messages
---@return boolean # Whether or not to start a new loop
function M:select_messages(account, folder, start_new, old_messages, mark_read, spam_messages)
  ---@diagnostic disable:undefined-global
  if (account == nil) or (folder == nil) or (folder == "") then
    return Set({}), true
  end
  local messages = old_messages or Set({})
  mark_read = mark_read or false
  spam_messages = spam_messages or Set({})
  if not start_new then
    messages = messages - spam_messages
    if #messages == 0 then
      return Set({}), true
    end
  end
  if mark_read and #messages > 0 then
    messages:mark_seen()
    messages = Set({})
  end
  if start_new then
    messages = self.select_25(account[folder]:is_unseen())
  end
  local new_needed = #messages == 0
  return messages, new_needed
end

function M.sort(messages, account, folder)
  local todo = messages:select_all()
  todo:mark_seen()
  todo:move_messages(account[folder])
end

function M.table_append(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

return M
