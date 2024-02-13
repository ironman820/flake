local mini_ai_ok, mini_ai = pcall(require, "mini.ai")
if mini_ai_ok then
  mini_ai.setup({
    n_lines = 500,
    custom_textobjects = {
      o = mini_ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }, {}),
      f = mini_ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
      c = mini_ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    },
  })
  -- register all text objects with which-key
  ---@type table<string, string|table>
  local i = {
    [" "] = "Whitespace",
    ['"'] = 'Balanced "',
    ["'"] = "Balanced '",
    ["`"] = "Balanced `",
    ["("] = "Balanced (",
    [")"] = "Balanced ) including white-space",
    [">"] = "Balanced > including white-space",
    ["<lt>"] = "Balanced <",
    ["]"] = "Balanced ] including white-space",
    ["["] = "Balanced [",
    ["}"] = "Balanced } including white-space",
    ["{"] = "Balanced {",
    ["?"] = "User Prompt",
    _ = "Underscore",
    a = "Argument",
    b = "Balanced ), ], }",
    c = "Class",
    f = "Function",
    o = "Block, conditional, loop",
    q = "Quote `, \", '",
    t = "Tag",
  }
  local a = vim.deepcopy(i)
  for k, v in pairs(a) do
    a[k] = v:gsub(" including.*", "")
  end

  local ic = vim.deepcopy(i)
  local ac = vim.deepcopy(a)
  for key, name in pairs({ n = "Next", l = "Last" }) do
    i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
    a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
  end
  local which_key_ok, which_key = pcall(require, "which-key")
  if which_key_ok then
    which_key.register({
      mode = { "o", "x" },
      i = i,
      a = a,
    })
  end
end
local mini_comment_ok, mini_comment = pcall(require, "mini.comment")
if mini_comment_ok then
  mini_comment.setup({
    options = {
      custom_commentstring = function()
        return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
      end,
    },
  })
end
local mini_pairs_ok, mini_pairs = pcall(require, "mini.pairs")
-- local map = vim.keymap.set
if mini_pairs_ok then
  mini_pairs.setup()
  -- map("<leader>up", function()
  --   local Util = require("lazy.core.util")
  --   vim.g.minipairs_disable = not vim.g.minipairs_disable
  --   if vim.g.minipairs_disable then
  --     Util.warn("Disabled auto pairs", { title = "Option" })
  --   else
  --     Util.info("Enabled auto pairs", { title = "Option" })
  --   end
  -- end, { desc = "Toggle auto pairs" })
end
local mini_surround_ok, mini_surround = pcall(require, "mini.surround")
if mini_surround_ok then
  -- Populate the keys based on the user's options
  local opts = {
    mappings = {
      add = "sa", -- Add surrounding in Normal and Visual modes
      delete = "sd", -- Delete surrounding
      find = "sf", -- Find surrounding (to the right)
      find_left = "sF", -- Find surrounding (to the left)
      highlight = "sh", -- Highlight surrounding
      replace = "sr", -- Replace surrounding
      update_n_lines = "sn", -- Update `n_lines`
    },
  }
  mini_surround.setup(opts)
end
