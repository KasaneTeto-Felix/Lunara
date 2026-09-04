local Kernel = LUNARA.Kernel
local ENV = LUNARA.ENV

local cwd = ENV.HOME
local running = true

local function normalize(path)
    if not path or path == "" then
        return cwd
    end

    if path == "~" then
        return ENV.HOME
    end

    if path:sub(1, 2) == "~/" then
        path = ENV.HOME .. path:sub(2)
    end

    if path:sub(1, 1) ~= "/" then
        path = fs.combine(cwd, path)
    end

    return fs.combine("/", path)
end

local function displayPath()
    if cwd == ENV.HOME then
        return "~"
    end

    if cwd:sub(1, #ENV.HOME) == ENV.HOME then
        return "~" .. cwd:sub(#ENV.HOME + 1)
    end

    return cwd
end

local function prompt()
    return ENV.USER ..
        "@" ..
        ENV.HOSTNAME ..
        ":" ..
        displayPath() ..
        "$ "
end

local function split(input)
    local args = {}

    for word in input:gmatch("%S+") do
        table.insert(args, word)
    end

    return args
end

local function execute(command, args)
    if command == "exit" then
        running = false
        return
    end

    if command == "clear" then
        term.clear()
        term.setCursorPos(1, 1)
        return
    end

    if command == "pwd" then
        print(cwd)
        return
    end

    if command == "whoami" then
        print(ENV.USER)
        return
    end

    if command == "hostname" then
        print(ENV.HOSTNAME)
        return
    end

    if command == "uname" then
        if args[2] == "-a" then
            print(
                Kernel.name ..
                " " ..
                Kernel.release ..
                " " ..
                Kernel.version ..
                " ComputerCraft"
            )
        else
            print(Kernel.name)
        end

        return
    end

    if command == "uptime" then
        print(
            "up " ..
            math.floor(Kernel.uptime()) ..
            " seconds"
        )

        return
    end

    if command == "ls" then
        local path = normalize(args[2])

        if not fs.exists(path) then
            print("ls: " .. args[2] .. ": No such file")
            return
        end

        for _, item in ipairs(fs.list(path)) do
            local full = fs.combine(path, item)

            if fs.isDir(full) then
                print(item .. "/")
            else
                print(item)
            end
        end

        return
    end

    if command == "cd" then
        local path = normalize(args[2] or "~")

        if not fs.exists(path) then
            print("cd: " .. (args[2] or "~") .. ": No such file or directory")
            return
        end

        if not fs.isDir(path) then
            print("cd: not a directory")
            return
        end

        cwd = path
        return
    end

    if command == "mkdir" then
        if not args[2] then
            print("mkdir: missing operand")
            return
        end

        local path = normalize(args[2])

        if fs.exists(path) then
            print("mkdir: File exists")
            return
        end

        fs.makeDir(path)
        return
    end

    if command == "touch" then
        if not args[2] then
            print("touch: missing operand")
            return
        end

        local path = normalize(args[2])

        if not fs.exists(path) then
            local file = fs.open(path, "w")

            if file then
                file.close()
            end
        end

        return
    end

    if command == "cat" then
        if not args[2] then
            print("cat: missing operand")
            return
        end

        local path = normalize(args[2])

        if not fs.exists(path) then
            print("cat: No such file")
            return
        end

        if fs.isDir(path) then
            print("cat: Is a directory")
            return
        end

        local file = fs.open(path, "r")

        if file then
            print(file.readAll())
            file.close()
        end

        return
    end

    if command == "echo" then
        local output = {}

        for i = 2, #args do
            table.insert(output, args[i])
        end

        print(table.concat(output, " "))
        return
    end

    if command == "rm" then
        if not args[2] then
            print("rm: missing operand")
            return
        end

        local path = normalize(args[2])

        if fs.exists(path) then
            fs.delete(path)
        else
            print("rm: No such file")
        end

        return
    end

    if command == "env" then
        for key, value in pairs(ENV) do
            print(key .. "=" .. value)
        end

        return
    end

    if command == "reboot" then
        print("Rebooting...")
        sleep(1)
        os.reboot()
        return
    end

    if command == "shutdown" then
        print("Shutting down...")
        sleep(1)
        os.shutdown()
        return
    end

    if command == "help" then
        print("Lunara Reborn commands:")
        print()
        print("  ls")
        print("  cd")
        print("  pwd")
        print("  mkdir")
        print("  touch")
        print("  cat")
        print("  echo")
        print("  rm")
        print("  clear")
        print("  whoami")
        print("  hostname")
        print("  uname")
        print("  uptime")
        print("  env")
        print("  reboot")
        print("  shutdown")
        print("  exit")
        print()

        return
    end

    print(command .. ": command not found")
end

while running do
    write(prompt())

    local input = read()

    if input and input ~= "" then
        local args = split(input)
        execute(args[1], args)
    end
end
