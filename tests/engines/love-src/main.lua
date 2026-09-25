-- Colour comes from a file inside the .love; a counter is saved with love.filesystem
-- (Emscripten IDBFS under love.js). Left half: package colour. Right half: red on the first
-- run, green once a save from an earlier run was found.
local color, runs = {1, 0, 0}, 0
function love.load()
  local hex = love.filesystem.read("color.txt"):gsub("%s", "")
  color = { tonumber(hex:sub(2, 3), 16) / 255, tonumber(hex:sub(4, 5), 16) / 255, tonumber(hex:sub(6, 7), 16) / 255 }
  local prev = love.filesystem.getInfo("save.txt") and love.filesystem.read("save.txt")
  runs = (tonumber(prev or "0") or 0) + 1
  local ok, err = love.filesystem.write("save.txt", tostring(runs))
  print("QVDBG write", tostring(ok), tostring(err), love.filesystem.getSaveDirectory(), love.filesystem.getIdentity())
  love.window.setTitle("love runs " .. runs)
end
function love.draw()
  local w, h = love.graphics.getDimensions()
  love.graphics.setColor(color); love.graphics.rectangle("fill", 0, 0, w / 2, h)
  if runs > 1 then love.graphics.setColor(0, 1, 0) else love.graphics.setColor(1, 0, 0) end
  love.graphics.rectangle("fill", w / 2, 0, w / 2, h)
end
