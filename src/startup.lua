if not fs.exists("/lunara/boot.lua") then
    term.clear()
    term.setCursorPos(1, 1)

    print("LUNARA BOOT ERROR")
    print()
    print("Bootloader not found.")
    print("Please reinstall Lunara.")

    return
end

dofile("/lunara/boot.lua")
