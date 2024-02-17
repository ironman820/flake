local conceal = require("conceal")

conceal.setup({
  ["lua"] = {
    enabled = true,
    keywords = {
      ["and"] = {
        conceal = "󰪍",
      },
      ["end"] = {
        conceal = "",
      },
      ["function"] = {
        conceal = "󰊕",
      },
      ["if"] = {
        conceal = "",
      },
      ["local"] = {
        conceal = "󰼈",
      },
      ["not"] = {
        conceal = "󰈅",
      },
      ["require"] = {
        conceal = "",
      },
      ["return"] = {
        conceal = "󱞴",
      },
    },
  },
  ["python"] = {
    enabled = true,
    keywords = {
      ["break"] = {
        conceal = "",
      },
      ["class"] = {
        conceal = "",
      },
      ["continue"] = {
        conceal = "󰈑",
      },
      ["def"] = {
        conceal = "󰊕",
      },
      ["del"] = {
        conceal = "󰊁",
      },
      ["else"] = {
        conceal = "󰦼",
      },
      ["for"] = {
        conceal = "󰆙",
      },
      ["from_import"] = {
        conceal = "󰝰",
      },
      ["if"] = {
        conceal = "",
      },
      ["import"] = {
        conceal = "󰶮",
      },
      ["not"] = {
        conceal = "󰈅",
      },
      ["or"] = {
        conceal = "󰃻",
      },
      ["return"] = {
        conceal = "󱞴",
      },
      ["print"] = {
        conceal = "󰐪",
      },
      ["while"] = {
        conceal = "󰖉",
      },
      ["yield"] = {
        conceal = "",
      },
    },
  },
})

conceal.generate_conceals()

local map = require("user-util").map
map("<leader>uc", conceal.toggle_conceal, { desc = "Toggle Conceal", mode = "n", silent = true })
