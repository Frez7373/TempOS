if not fs.exists("/boot/boot.lua") then
  term.setTextColor(colors.red); print("TempOS bootloader is missing.")
  return
end
shell.run("/boot/boot.lua")
