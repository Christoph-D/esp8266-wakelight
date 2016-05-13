local alarms = {}

function alarms.set(day_of_week, hours, minutes, enabled)
  file.open("alarm" .. day_of_week, "w+")
  file.writeline(hours)
  file.writeline(minutes)
  if enabled then
    file.writeline("1")
  else
    file.writeline("0")
  end
  file.close()
end

function alarms.get(day_of_week)
  if not file.open("alarm" .. day_of_week) then
    return { hours=8, minutes=10, seconds=0, enabled=false }
  end
  local hours = file.readline()
  local minutes = file.readline()
  local enabled = file.readline()
  file.close()
  if not enabled or tonumber(enabled) == 0 then
    enabled = false
  end
  return { hours=hours, minutes=minutes, seconds=0, enabled=enabled }
end

-- Returns the time difference in seconds to the alarm on the current
-- day.  Negative if the alarm time has not been reached yet.
function alarms.get_seconds_to_next()
  local time = require "time"
  local t = time.local_time()
  if t == 0 then
    return nil
  end
  t = time.from_unix_time(t)
  local a = alarms.get(t.day_of_week)
  if not a.enabled then
    return nil
  end
  return time.diff(t, a)
end

return alarms
