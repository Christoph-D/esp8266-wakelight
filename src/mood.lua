local function led_fill(r, g, b)
  ws2812.write(LED_PIN, string.rep(string.char(g, r, b), NUM_LEDS))
end

-- Generated in bash with:
-- for i in {0..255}; do printf '%d,' $(python -c "x=$i/255.0;print(int(0.5+100*x*x*x*(x*(x*6 - 15) + 10)))"); done; echo
smooth = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,7,7,7,8,8,8,9,9,10,10,10,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,18,19,19,20,20,21,22,22,23,23,24,25,25,26,26,27,28,28,29,30,30,31,32,32,33,34,34,35,36,37,37,38,39,39,40,41,42,42,43,44,44,45,46,47,47,48,49,50,50,51,52,53,53,54,55,56,56,57,58,58,59,60,61,61,62,63,63,64,65,66,66,67,68,68,69,70,70,71,72,72,73,74,74,75,75,76,77,77,78,78,79,80,80,81,81,82,82,83,83,84,84,85,85,86,86,87,87,88,88,89,89,90,90,90,91,91,92,92,92,93,93,93,94,94,94,95,95,95,95,96,96,96,96,97,97,97,97,97,98,98,98,98,98,98,99,99,99,99,99,99,99,99,99,99,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100 }

local function moodcolor_red(step)
  return 60 + smooth[step], 0, 0
end

local function moodcolor_green(step)
  return 0, 255, 0
end

local function moodcolor_white(step)
  return 255, 150, 60
end

local function moodlight(moodcolor)
  local i = 1
  local up = true
  tmr.alarm(
    MAIN_TIMER_ID, 300, tmr.ALARM_AUTO, function ()
      if up then
        i = i + 1
        if i >= 256 then
          up = false
        end
      else
        i = i - 1
        if i <= 1 then
          up = true
        end
      end
      led_fill(moodcolor(i))
  end)
end

local function send_OK(conn, moodcolor)
  conn:send("HTTP/1.1 200 OK\r\n\r\n<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width\"></head><body><a href=\"/mood/off\">Back to normal</a><br><a href=\"/mood/red\">Red</a><br><a href=\"/mood/green\">Green</a><br><a href=\"/mood/white\">White</a></body></html>")
  if moodcolor then
    moodlight(moodcolor)
  end
end

return function(conn, payload)
  local path_get = payload:match("^GET /mood([^ ]*) HTTP")
  if not path_get then
    return nil
  end

  conn:on("sent", function(conn) conn:close() end)
  if path_get == "" or path_get == "/" then
    send_OK(conn, nil)
  elseif path_get == "/red" then
    send_OK(conn, moodcolor_red)
  elseif path_get == "/green" then
    send_OK(conn, moodcolor_green)
  elseif path_get == "/white" then
    send_OK(conn, moodcolor_white)
  elseif path_get == "/off" then
    conn:send("HTTP/1.1 200 OK\r\n\r\n<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width\"></head><body><a href=\"/mood\">Back to mood light.</a></body></html>")
    dofile("wakelighttimer.lc")()
  else
    conn:send("HTTP/1.1 404 Not Found\r\n\r\n404: Mood not found.")
  end

  return true
end
