local last_sync_time = 0

local function resync_needed()
  local t = rtctime.get()
  return t == 0 or t > last_sync_time + NTP_SYNC_INTERVAL_IN_HOURS * 60 * 60
end

local function sync()
  if resync_needed() then
    sntp.sync(NTP_SERVER, function(t)
        last_sync_time = t
        tmr.alarm(NTP_TIMER_ID, 60000, tmr.ALARM_SINGLE, sync)
      end,
      function()
        tmr.alarm(NTP_TIMER_ID, 1000, tmr.ALARM_SINGLE, sync)
      end)
  else
    tmr.alarm(NTP_TIMER_ID, 60000, tmr.ALARM_SINGLE, sync)
  end
end

return sync
