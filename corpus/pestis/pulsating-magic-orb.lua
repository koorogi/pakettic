debug.sethook()

d = {
  0, 0, 0, 0, -- cumulative syncs
  1, 2, 2, 2, 1, 2, 2, 0, --chn 0 bass
  0, 1, 3, 3, 3, 3, 3, 0, --chn 1 mid
  5, 5, 5, 5, 0, 5, 5, 5, --chn 2 snare
  7, 7, 7, 7, 1, 7, 7, 7, --chn 3 kick
  1, 0, 0, 1, 0, 0, 3, 0, --pat 2
  1, 0, 1, 0, 2, 0, 3, 0, --pat 3
  1, 0, 4, 0, 5, 0, 4, 0, --pat 4
  0, 0, 0, 0, 1, 0, 0, 0, --pat 5
  0, 0, 0, 0, 1, 0, 1, 0, --pat 6
  1, 1, 0, 1, 0, 0, 0, 0, --pat 7
  1, 1, 0, 1, 1, 1, 1, 1 } --pat 8

t = 0

function TIC()
  for k = 0, 3 do
    p = t // 1024
    poke(65896, 48)
    x = t * (2 - k // 2)
    y = d[8 * k + p + 5] + t // 128 % 8 // 7
    z = d[8 * y + x // 16 % 8 + 21]
    d[-k] = -x % 16 % (y // 2 * 16 * z + 1)
    d[k + 1] = d[k + 1] + d[-k]
    sfx(
      k % 3,
      3
      + k * 12
      + p // 4 * (1 - t // 128 % 8 // 4)
      - z * z + 10 * z
      - k // 3 * x % 16 * 8
      ~ 0,
      2,
      k,
      d[-k]
    )
  end
  cls(d[3] % 9 * 4) -- black, white, blue
  for k = 0, 1 do
    for i = 0, 2400 do
      z = 1 - i / 1200
      r = (1 - z * z) ^ .5
      z = z - (3 - p % 3) // 3 * z
      r = p * p // 3 % 2 * (.8 - r) + r
      x = r * s(2.4 * i + 11)
      y = r * s(2.4 * i)
      y = p // 2 % 2 * ((y - d[4] / 200) // .6 * .6 + d[4] / 200 - y) + y
      r = s(s(x * 5 + d[3] / 7 + d[2] / 40)
        + s(y * 5 + d[3] / 8)
        + s(z * 5 + d[3] / 9)
        + t / 300
      ) * s(d[3] * (71 + p)) ^ 4 / 2.5 + 1
      z = z * r + 2.1
      h = 12 / z - p // 5 * d[-3] / 2
      rect(
        120 + x * r * 99 / z - h / 2,
        68 + (y * r * k + 1 - k) * 99 / z - h / 2,
        h,
        h,
        k * (-d[-3]
            + s(x * 5 - t * .05) ^ 4 * d[-1]
        ) * 4 * (.5 - p % 2) / (.1 + z) / 4
      )
    end
  end
  t = t + 1, t < 8192 or exit(), p < 7 or print("pestis@lovebyte2022", 64, 64, d[3] % 9 * 4)
end

s = math.sin
