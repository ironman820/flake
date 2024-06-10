local obsidian_ok, obsidian = pcall(require, "obsidian")
if not obsidian_ok then
  return
end

local opts = {
  workspaces = {
    {
      name = "personal",
      path = "~/Notes/My Notes",
    },
  },
}

---@diagnostic disable-next-line: missing-fields
obsidian.setup(opts)
