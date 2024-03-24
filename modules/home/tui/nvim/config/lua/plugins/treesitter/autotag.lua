local autotag_ok, autotag = pcall(require, "ts-autotag")
if not autotag_ok then
  return
end
autotag.setup()
