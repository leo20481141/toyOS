f = 0
for i in range(65536):
  if i == 0: i = 1
  d = i % 3496
  b = 76
  d += b * 2
  a = 0
  c = int(d / b)
  a += c * 1280
  d -= c * b
  d += 2
  d *= 4
  a += d
  #a += d << 16
  #a = (a & 0xFFFFFF00) | ((a + 2) & 0xFF)
  #a = (a & 0x00FFFFFF) | ((a + (1 << 16)) & 0xFF000000)
  a = (a + 1) & 0xFFFF
  if a == 0: a += 1
  d1 = i % 3496
  d2 = a % 3496
  if d1 == d2:
    f += 1
    print(i)

print(f"Found: {f}")
