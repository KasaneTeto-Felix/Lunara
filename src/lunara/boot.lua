term.clear()
term.setCursorPos(1, 1)

print("================================")
print("        LUNARA REBORN")
print("          Version 1.0.0")
print("================================")
print()

local function load(name, path)
    write("[BOOT] " .. name .. " ... ")

    if not fs.exists(path) then
        print("FAILED")
        error("Missing: " .. path)
    end

    print("OK")

    return dofile(path)
end

load("VFS", "/lunara/vfs.lua")
load("Kernel", "/lunara/kernel.lua")
