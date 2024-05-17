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
    local k, l = s:find("?=", j, true)
    local s_ = s:sub(j + 1, k - 1):gsub("_", " "):gsub("=([a-fA-F0-9][a-fA-F0-9])", function(c)
      return string.char(tonumber(c, 16))
    end)
    return self:hdr_decode(s:sub(1, i - 1) .. s_ .. s:sub(l + 1))
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
    end)
    return self:hdr_decode(s:sub(1, i - 1) .. s_ .. s:sub(l + 1))
  end

  return s
end

function M:print_subject(messages)
  for _, message in ipairs(messages) do
    local mailbox, uid = table.unpack(message)
    local subject = mailbox[uid]:fetch_field("subject")
    local subject_ = subject:sub(subject:find(":") + 1, -1)
    io.write(subject_ .. "\n")
  end
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
