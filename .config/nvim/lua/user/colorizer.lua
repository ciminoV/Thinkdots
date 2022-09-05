local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
  return
end

colorizer.setup({ '*' }, { -- Highlight all files
  -- Don't highlight "Name" codes like Blue or blue
  names = false,
  -- Available modes: foreground, background, virtualtext
  mode = "background", -- Set the display mode.)
})
