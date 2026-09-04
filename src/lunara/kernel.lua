local Kernel = {}

Kernel.name = "Lunara"
Kernel.release = "Reborn"
Kernel.version = "1.0.0"

Kernel.hostname = "localhost"
Kernel.bootTime = os.clock()

local function mkdir(path)
    if not fs.exists(path) then
        fs.makeDir(path)
    end
end

local directories = {
    "/home",
    "/home/lunara",
    "/home/lunara/Desktop",
    "/home/lunara/Documents",
    "/home/lunara/Downloads",
    "/etc",
    "/var",
    "/var/log",
    "/tmp",
    "/bin",
    "/usr",
    "/usr/bin"
}

for _, path in ipairs(directories) do
    mkdir(path)
end

local env = {
    USER = "lunara",
    HOME = "/home/lunara",
    HOSTNAME = "localhost",
    SHELL = "/lunara/shell.lua",
    PATH = "/bin:/usr/bin"
}

_G.LUNARA = {
    Kernel = Kernel,
    ENV = env
}

function Kernel.uptime()
    return os.clock() - Kernel.bootTime
end

function Kernel.uname()
    return Kernel.name ..
        " " ..
        Kernel.release ..
        " " ..
        Kernel.version
end

print("[KERNEL] Lunara kernel " .. Kernel.version)
print("[KERNEL] Architecture: ComputerCraft")
print("[KERNEL] Hostname: " .. Kernel.hostname)
print("[KERNEL] Filesystem: mounted")
print("[KERNEL] Initialization complete")
print()

if fs.exists("/lunara/shell.lua") then
    dofile("/lunara/shell.lua")
else
    error("Shell not found.")
end
