local time = {}

time.SUNDAY = 0
time.MONDAY = 1
time.TUESDAY = 2
time.WEDNESDAY = 3
time.THURSDAY = 4
time.FRIDAY = 5
time.SATURDAY = 6

function time.daylight_saving_time(dst)
  file.open("daylightsaving", "w+")
  if dst then
    file.write("1")
  end
  file.close()
end

function time.is_daylight_saving_time()
  if not file.open("daylightsaving") then
    return false
  end
  local r = file.read() == "1"
  file.close()
  return r
end

function time.local_time()
  local t = rtctime.get()
  if t == 0 then return 0 end
  if time.is_daylight_saving_time() then
    return t + 2 * 60 * 60 -- CEST
  else
    return t + 60 * 60 -- CET
  end
end

function time.from_unix_time(time)
  local result = {}
  result.seconds = time % 60
  local time = time / 60
  result.minutes = time % 60
  time = time / 60
  result.hours = time % 24
  time = time / 24
  result.day_of_week = (time + 4) % 7
  return result
end

function time.current_day_of_week()
  local t = time.local_time()
  if t then
    return time.from_unix_time(t).day_of_week
  end
  return -1
end

-- Difference in seconds.  Only uses hours/minutes/seconds, ignores
-- the date.
function time.diff(t1, t2)
  return 3600 * (t1.hours - t2.hours) + 60 * (t1.minutes - t2.minutes) + t1.seconds - t2.seconds
end

return time
