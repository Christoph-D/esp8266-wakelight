local NUM_LEDS = 144
local LED_PIN = 1

local function single(i)
   return string.rep(string.char(0, 0, 0), i)
       .. string.char(10, 0, 0)
       .. string.char(0, 10, 0)
       .. string.rep(string.char(0, 0, 0), NUM_LEDS - i - 2)
end

local function run(i)
    ws2812.write(LED_PIN, single(i))
    local j = i + 1
    if j < NUM_LEDS then
      tmr.alarm(0, 10, tmr.ALARM_SINGLE, function() run(j) end)
    end
end

return function() run(0) end
