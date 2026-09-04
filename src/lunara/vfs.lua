local VFS = {}

function VFS.exists(path)
    return fs.exists(path)
end

function VFS.isDir(path)
    return fs.isDir(path)
end

function VFS.list(path)
    return fs.list(path)
end

function VFS.makeDir(path)
    if not fs.exists(path) then
        fs.makeDir(path)
    end
end

function VFS.delete(path)
    if fs.exists(path) then
        fs.delete(path)
    end
end

function VFS.read(path)
    if not fs.exists(path) then
        return nil
    end

    local file = fs.open(path, "r")

    if not file then
        return nil
    end

    local data = file.readAll()
    file.close()

    return data
end

function VFS.write(path, data)
    local dir = fs.getDir(path)

    if dir ~= "" and not fs.exists(dir) then
        fs.makeDir(dir)
    end

    local file = fs.open(path, "w")

    if not file then
        return false
    end

    file.write(data)
    file.close()

    return true
end

return VFS
