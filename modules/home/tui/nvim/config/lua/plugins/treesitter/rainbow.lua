local rainbow_ok, rainbow = pcall(require, "rainbow-delimiters")
if not rainbow_ok then
  return
end

local rainbow_setup = require("rainbow-delimiters.setup")
rainbow_setup.setup({
  strategy = {
    [""] = rainbow.strategy["global"],
    vim = rainbow.strategy["local"],
  },
  query = {
    [""] = "rainbow-delimiters",
    lua = "rainbow-blocks",
  },
  -- priority = {
  --   [""] = 110,
  --   lua = 210,
  -- },
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
  },
})
