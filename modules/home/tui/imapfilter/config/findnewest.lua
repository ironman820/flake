local M = {}

function M.findNewest(messages, loopCount)
  io.write("Loop: " .. loopCount .. "\n")
  io.write("Messages: " .. #messages .. "\n")
  local mailbox, uid = table.unpack(messages[1])
  local lastDate = mailbox[uid]:fetch_date()
  if #messages == 1 then
    return lastDate
  end
  local lastCount = #messages
  local newMessages = messages:sent_since(lastDate)
  io.write("New Messages: " .. #newMessages .. "\n")
  if #newMessages < 1 then
    return lastDate
  end
  mailbox, uid = table.unpack(newMessages[1])
  lastDate = mailbox[uid]:fetch_date()
  -- if #newMessages == lastCount and loopCount > 1 then
  --   return newMessages[1]:fetch_date()
  -- end
  if #newMessages > 1 then
    local found = M.findNewest(newMessages, loopCount + 1)
    if found == nil then
      return lastDate
    end
    return found
  end
  return lastDate
end

setmetatable(M, {
  __call = function(_, messages, loopcount)
    return M.findNewest(messages, loopcount)
  end,
})

return M
