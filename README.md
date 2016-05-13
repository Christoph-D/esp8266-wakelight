esp8266-wakelight
=================

An alarm clock with light instead of sound, with NTP time
synchronization, and with programmable alarm times for each day of the
week.

This code works on the esp8266 wifi module with the nodemcu firmware.
It was successfully tested on an ESP-01 and an ESP-12E.

Web Interface
-------------

Click on this image to the web interface in action:

[![screenshot](https://raw.github.com/Christoph-D/esp8266-wakelight/master/webinterface.png)](https://raw.github.com/Christoph-D/esp8266-wakelight/master/webinterface.mp4)

For no good reason, the interface is partly in Japanese (月曜日 is
"Monday", etc.).

The "Toggle" button toggles the time zone between CET and CEST.
Setting different time zones amounts to changing the offsets in
`src/time.lua`.

Eventually daylight saving time (DST) should toggle automatically
based on the time zone, but this would require keeping track of the
date, which is not implemented yet.  The wakelight remembers the
status of daylight saving time after power loss, as well as the alarm
times.

Hardware
--------

Any esp8266 module will do, even the cheap ESP-01 ($1-$2 on
aliexpress).  First you need to flash it with a recent nodemcu
firmware.  Don't use prebuilt firmwares, those are far too old and
won't work.  Either
[compile your own](https://hub.docker.com/r/marcelstoer/nodemcu-build/)
or use http://nodemcu-build.com/ to get a recent firmware.

The LEDs must be WS2812 modules.  You can change the number of LEDs in
`globals.lua`.  The default for `NUM_LEDS` is 144, which is the number
of LEDs on a common high density 1m strip.  For increased brightness,
you can connect multiple strips in parallel without changing
`NUM_LEDS`, or concatenate them and increase `NUM_LEDS` (I would
recommend the former because the timing of these LEDs strains the ESP
chip).  I would say that two 1m strips (144 LED/m), a total of 288
LEDs, are the minimum for adequate brightness.  Unfortunately the
WS2812 LEDs are not very efficient compared to modern LED bulbs.

Please be aware that driving the LEDs requires quite a lot of power
(>25W for 144 LEDs).  A 5V cellphone charger or a computer USB port
will not work.

The LEDs must be connected to pin 4 of the ESP chip.  The ws2812
module in nodemcu only works on the serial transmitter pin, which
happens to be pin 4.

You may also need a level shifter between the LEDs and the ESP because
the ESP is 3.3V but the WS2812 LEDs are 5V.  In my case it also worked
without a level shifter, but adding one reduced glitches on the LED
strips.

OTA Upload
----------

The wakelight accepts over-the-air updates of lua files from the
script `ota_upload.sh`.  There is currently no authentication.
