local barbecue_ok, barbecue = pcall(require, "barbecue")
if not barbecue_ok then
  return
end

barbecue.setup({
  attach_navic = false,
})
