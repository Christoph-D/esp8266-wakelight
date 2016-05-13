local alarms = require "alarms"

local function update_buffer(buffer, c)
  if not c.r_frac then c.r_frac = 0 end
  if not c.g_frac then c.g_frac = 0 end
  if not c.b_frac then c.b_frac = 0 end
  local r2 = c.r_frac >= 0 and c.r + 1 or c.r - 1
  local g2 = c.g_frac >= 0 and c.g + 1 or c.g - 1
  local b2 = c.b_frac >= 0 and c.b + 1 or c.b - 1
  local r3, g3, b3
  local set = buffer.set
  for i = 1, NUM_LEDS do
    if i > c.r_frac then r3 = c.r else r3 = r2 end
    if i > c.g_frac then g3 = c.g else g3 = g2 end
    if i > c.b_frac then b3 = c.b else b3 = b2 end
    set(buffer, i - 1, g3, r3, b3)
  end
end

return function()
  local color = nil
  local buffer = ws2812.newBuffer(NUM_LEDS)
  tmr.alarm(
    MAIN_TIMER_ID, 500, tmr.ALARM_AUTO, function ()
      if color then
        buffer:write(LED_PIN)
        --ws2812.write(LED_PIN, buffer)
        --ws2812.write(LED_PIN, string.rep(string.char(200,255,170), 144))
        color = nil
        return
      end
      node.setcpufreq(node.CPU160MHZ)
      local a = alarms.get_seconds_to_next()
      if a then
        color = dofile("sunrise_color.lc")(a)
      else
        color = { r = 0, g = 0, b = 0 }
      end
      update_buffer(buffer, color)
      --print("(" .. color.r .. "," .. color.g .. "," .. color.b .. ")")
  end)
end
