local time = require "time"
local alarms = require "alarms"

local function header()
  return table.concat({
      '<!DOCTYPE html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width">',
      '<title>Christoph\'s Wakelight</title>',
      '<script src="', CLOCKPICKER_URL, '/jquery-1.12.0.min.js"></script>',
      '<script src="', CLOCKPICKER_URL, '/clockpicker.js"></script>',
      '<link rel="stylesheet" type="text/css" href="', CLOCKPICKER_URL, '/clockpicker.css">',
      '<link rel="stylesheet" type="text/css" href="', CLOCKPICKER_URL, '/wakelight.css">',
      '</head><body><div id="tf"><form method="post"><table>'
  })
end

local function day_input(day, name)
  local a = alarms.get(day)
  local checked = ""
  if a.enabled then
    checked = "checked "
  end
  return table.concat({
    '<tr><td>', name, ':</td><td>',
    '<input name="d', day, 't" type="text" value="',
    string.format("%02d:%02d", a.hours, a.minutes), '" size="5" readonly />',
    '<input name="d', day, '" type="checkbox" value="e" ', checked, '/>',
    '</td></tr>'
  })
end

local function daylight_saving_form()
  local dst
  if time.is_daylight_saving_time() then
    dst = "enabled"
  else
    dst = "disabled"
  end
  local t = time.from_unix_time(time.local_time())
  return table.concat({
    '<div id="dst"><form method="post">DST is ', dst, ' (it is now ',
    string.format("%02d:%02d:%02d", t.hours, t.minutes, t.seconds),
    '):<br><button type="submit" name="dst">Toggle</button></form></div>'})
end

local function footer()
  return '<script>$(\'input[type="text"]\').clockpicker({autoclose:true,placement:"auto"});</script></body></html>\n'
end

local FORM_PARTS = 2
local function form(part)
  node.setcpufreq(node.CPU160MHZ)
  if part == 1 then
    return table.concat({
        'HTTP/1.1 200 OK\r\n\r\n',
        header(),
        day_input(time.MONDAY, "月曜日"),
        day_input(time.TUESDAY, "火曜日"),
        day_input(time.WEDNESDAY, "水曜日")
    })
  else
    return table.concat({
        day_input(time.THURSDAY, "木曜日"),
        day_input(time.FRIDAY, "金曜日"),
        day_input(time.SATURDAY, "土曜日"),
        day_input(time.SUNDAY, "日曜日"),
        '</table><button type="submit">Save</button></form></div>',
        '<div><a href="mood">Mood</a></div>',
        daylight_saving_form(),
        footer()
    })
  end
end

-- Send the form in multiple chunks because it is too large for a
-- single conn:send call.
local function send_form(conn)
  local part = 1
  conn:on("sent", function(conn)
    if part == FORM_PARTS then
      conn:close()
    else
      part = part + 1
      conn:send(form(part))
    end
  end)
  conn:send(form(part))
end

local function send_error(conn)
  conn:on("sent", function(conn) conn:close() end)
  conn:send("HTTP/1.1 404 Not Found\r\n\r\n404: Page not found.")
end

local function parse_alarm_changes(raw)
  local error = false
  for day = 0,6 do
    local hours, minutes = raw:match("d" .. day .. "%t=(%d+)%%3A(%d+)")
    local enabled = raw:match("d" .. day .. "%=e")
    if hours and minutes then
      minutes = tonumber(minutes)
      hours = tonumber(hours)
      if hours and 0 <= hours and hours <= 23
      and minutes and 0 <= minutes and minutes <= 59 then
        alarms.set(day, hours, minutes, enabled)
      else
        error = true
      end
    end
  end
  return error
end

local function parse_form_data(conn, raw)
  node.setcpufreq(node.CPU160MHZ)
  local error = false
  if raw:find("dst=") then
    -- toggle DST
    time.daylight_saving_time(not time.is_daylight_saving_time())
  else
    error = parse_alarm_changes(raw)
  end

  if error then
    dofile("ledblink.lc")(50, 0, 0) -- flash red
  else
    dofile("ledblink.lc")(0, 50, 0) -- flash green
  end
  send_form(conn)
end

local function parse_form()
  return function(conn, payload)
    local length = tonumber(payload:match("\r\nContent%-Length: (%d+)\r\n"))
    local raw = payload:match("\r\n\r\n(.*)")
    if not length or #raw >= length then
      parse_form_data(conn, raw)
    else
      -- Data is incomplete, wait for the next chunks.
      conn:on("receive", function(conn, payload)
        raw = raw .. payload
        if #raw >= length then
          parse_form_data(conn, raw)
          raw = nil
        end
      end)
    end
  end
end

return function(conn, payload)
  local path_get = payload:match("^GET ([^ ]+) HTTP")
  local path_post = payload:match("^POST ([^ ]+) HTTP")
  if not (path_get or path_post) then
    return nil
  end

  if path_post == "/" then
    parse_form()(conn, payload)
  elseif path_get == "/" then
    send_form(conn)
  else
    send_error(conn)
  end

  return true
end
