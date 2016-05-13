local function receive_next_chunk(filename)
  return function (conn, payload)
    conn:hold()
    conn:send("Receiving " .. string.len(payload) .. " more bytes of " .. filename .. "...\n")
    print("Receiving " .. string.len(payload) .. " more bytes of " .. filename .. "...\n")
    file.open(filename .. ".tmp", "a")
    file.write(payload)
    file.close()
  end
end

local function finish_upload(filename)
  return function (conn)
    print("Received \"" .. filename .. "\".")
    file.remove(filename)
    file.rename(filename .. ".tmp", filename)
    if filename ~= "init.lua" then
      node.compile(filename)
      file.remove(filename)
    end
  end
end

return function(conn, payload)
  if string.find(payload, "^ESP8266RESET") then
    print("Received reset command.")
    conn:on("disconnection", function(conn) node.restart() end)
    conn:close()
    return true
  end

  local i, j, filename = string.find(payload, "^ESP8266UPLOAD ([^ ]+) ")
  if i then
    for i = 0, 6 do
      tmr.stop(i) -- Stop all timers, whatever they are doing
    end
    conn:hold()
    conn:on("sent", function(conn) conn:unhold() end)
    conn:on("receive", receive_next_chunk(filename))
    conn:on("disconnection", finish_upload(filename))
    conn:send("Receiving the first " .. (string.len(payload) - j + 1)
                .. " bytes of \"" .. filename .. "\"...\n")
    print("Receiving the first " .. (string.len(payload) - j + 1)
            .. " bytes of \"" .. filename .. "\"...")
    file.open(filename .. ".tmp", "w+")
    file.write(string.sub(payload, j + 1))
    file.close()
    return true
  end

  return nil
end
