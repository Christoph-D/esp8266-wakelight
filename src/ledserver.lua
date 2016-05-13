dofile("timesync.lc")()

srv = net.createServer(net.TCP)
srv:listen(
  80, function(conn)
    conn:on("receive", function(conn, payload)
      if dofile("uploadserver.lc")(conn, payload) then
        return
      end
      if dofile("mood.lc")(conn, payload) then
        return
      end
      if dofile("configserver.lc")(conn, payload) then
        return
      end
      conn:close()
    end)
end)

-- Start the sunrise functions with a delay in order to allow uploads
-- of new files even if something is wrong in the sunrise code.
tmr.alarm(
  MAIN_TIMER_ID, 10000, tmr.ALARM_SINGLE, function ()
    dofile("wakelighttimer.lc")()
  end)

print("LED-Server started")

--dofile("ledblink.lc")(0, 0, 255)
--tmr.alarm(5, 1000, tmr.ALARM_AUTO, function() print(node.heap()) end)
