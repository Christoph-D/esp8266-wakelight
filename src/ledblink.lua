local function led_fill(r, g, b)
  ws2812.write(LED_PIN, string.rep(string.char(g, r, b), NUM_LEDS))
end

return function(r, g, b)
  tmr.alarm(TEMP_TIMER_ID, 1, tmr.ALARM_SINGLE, function()
    led_fill(r, g, b)
    tmr.alarm(TEMP_TIMER_ID, 100, tmr.ALARM_SINGLE, function()
      led_fill(0, 0, 0)
      -- Do it twice to be sure the LEDs are off
      tmr.alarm(TEMP_TIMER_ID, 1, tmr.ALARM_SINGLE, function() led_fill(0, 0, 0) end)
    end)
  end)
end
