-- path to the adb executable
adb = "~/Android/adb"

-- path to save photos to
outdir = "~/Desktop/Android\\ Photos/"

-- directories on android to pull photos from
tocopy = {
    "/sdcard/DCIM/Camera";
    "/sdcard/viber/media/Viber Images";
    "/sdcard/viber/media/Viber Videos";
}

love.window.setMode(400, 300, {resizable = false})
font = love.graphics.newFont("SourceCodePro/SourceCodePro-Medium.otf",12)
love.graphics.setFont(font)

output = "loading.."

connected = false
copied = false
copying = 0

function shell(command)
    local handle = io.popen(command.." 2>&1")
    local result = handle:read("*a")
    handle:close()
    return result
end

function love.load()
   arrow = love.graphics.newImage("icons-Custom/arrow.png")
   checkmark = love.graphics.newImage("icons-Custom/checkmark.png")
   computer = love.graphics.newImage("icons-Numix/gnome-computer.png")
   phone = love.graphics.newImage("icons-Numix/phone.png")
   phonegrey = love.graphics.newImage("icons-Numix/phonegrey.png")
end

function love.draw()
    if connected then
	    love.graphics.draw(phone, 20, 20, 0, 0.2, 0.2)
    else
	    love.graphics.draw(phonegrey, 20, 20, 0, 0.2, 0.2)
	end
	love.graphics.draw(computer, 400-20-102, 20, 0, 0.2, 0.2)
	if not copied then
        if copying > 0 then
        	love.graphics.draw(arrow, 400/2-51, 20, 0, 0.2, 0.2)
	    end
    else
    	love.graphics.draw(checkmark, 400/2-51, 20, 0, 0.2, 0.2)
    end
	love.graphics.print(output,20,102+40)
end

function love.update()
    shell("sleep 0.5")
    if not copied then
        adbls = shell(adb.." shell ls")
        if not string.find(adbls,"conf") then
            output = "please connect your phone."
            copying = 0
            connected = false
        else
            connected = true
            if copying == 0 then
                output = output.."\ncopying files..."
                shell("mkdir -p "..outdir)
                copying = 1
                output = output.."\n-> copying "..tocopy[1]
            elseif copying < #tocopy+1 then
                shell("cd "..outdir.."; "..adb.." pull \""..tocopy[copying].."\"")
                if copying > 1 then
                    output = output.."\n-> copying "..tocopy[copying]
                end
                copying = copying + 1
            else
                copied = true
            end
        end
    elseif not finished then
        finished = true
        output = output.."\nfinished copying photos.\nyou can now close this window."
    end
end