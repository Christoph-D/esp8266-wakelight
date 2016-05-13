dofile("globals.lc")

wifi.setmode(wifi.STATION)
wifi.sta.config(WIFI_SSID, WIFI_PASSWORD)
wifi.sta.sethostname(MY_HOSTNAME)
if WIFI_STATIC_IP then
  wifi.sta.setip({ip = WIFI_STATIC_IP, netmask = WIFI_NETMASK, gateway = WIFI_GATEWAY})
end
wifi.sta.connect()

-- Initialize the LED_PIN to the reset state.
gpio.mode(LED_PIN, gpio.OUTPUT)
gpio.write(LED_PIN, gpio.LOW)

tmr.alarm(
  MAIN_TIMER_ID, 2000, tmr.ALARM_AUTO, function ()
    if wifi.sta.getip() then
      tmr.unregister(MAIN_TIMER_ID)
      print("Config done, IP is " .. wifi.sta.getip())
      dofile("ledserver.lc")
    end
  end)
