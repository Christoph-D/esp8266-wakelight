local function CRGB(r, g, b) return { r = r, g = g, b = b } end
local sunrise_steps = {
  { 0, CRGB(0, 0, 0) },
  { 60, CRGB(1, 1, 1) },
  { 120, CRGB(2, 2, 2) },
  { 180, CRGB(3, 3, 2) },
  { 360, CRGB(20, 10, 5) },
  { 600, CRGB(30, 20, 10) },
  { 1800, CRGB(255, 200, 170) },
  { 3600, CRGB(255, 200, 170) },
  { 3720, CRGB(0, 0, 0) } }

-- Fraction is given by num/denom.
-- Returns the blended value and the percentage how close we are to
-- the next integer value.  E.g.,
-- blend_int(0, 10, 10, 20) == 5, 0
-- blend_int(0, 10, 11, 20) == 5, 50
-- blend_int(0, 10, 12, 20) == 6, 0
-- blend_int(10, 0, 2, 2000) == 10, -1
-- blend_int(0, 10, 2, 2000) == 10, -1
-- The above examples are for a percentage of 100.  Currently this
-- function uses 144 because this is the number of LEDs I have.
local function blend_int(a, b, num, denom)
  local x = b * num + a * (denom - num)
  if a < b then
    return x / denom, (x % denom) * 144 / denom
  else
    local c = -(-x % denom) * 144 / denom
    if c ~= 0 then
      return x / denom + 1, c
    else
      return x / denom, 0
    end
  end
end

local function blend_color(c1, c2, num, denom)
  local c = {}
  c.r, c.r_frac = blend_int(c1.r, c2.r, num, denom)
  c.g, c.g_frac = blend_int(c1.g, c2.g, num, denom)
  c.b, c.b_frac = blend_int(c1.b, c2.b, num, denom)
  return c
end

-- time: seconds since beginning of sunrise
return function(time)
  if time < 0 then
    return CRGB(0, 0, 0)
  end
  for i = 1, #sunrise_steps - 1 do
    if time < sunrise_steps[i+1][1] then
      local t1 = sunrise_steps[i][1]
      local t2 = sunrise_steps[i+1][1]
      local c1 = sunrise_steps[i][2]
      local c2 = sunrise_steps[i+1][2]
      --print("Blending at " .. time)
      return blend_color(c1, c2, time - t1, t2 - t1)
    end
  end
  return CRGB(0, 0, 0)
end
