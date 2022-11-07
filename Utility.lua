local utility = {RobloxPosition, RobloxSize , instance = {} , drag};

local UserInput = game:GetService("UserInputService")

local cc = game.Workspace.CurrentCamera
local currentccx = cc.ViewportSize.x
local currentccy = cc.ViewportSize.y

function utility:MouseOver(obj)
    local mousePos = UserInput:GetMouseLocation()
    local x1 = obj.Position.X
    local y1 = obj.Position.Y
    local x2 = x1 + obj.Size.X
    local y2 = y1 + obj.Size.Y -- hi
    return (mousePos.X >= x1 and mousePos.Y >= y1 and mousePos.X <= x2 and mousePos.Y <= y2)
end


--
utility.RobloxSize = function(xscale, xoffset, yscale, yoffset, instance)
    local x
    local y
    local vx, vy = cc.ViewportSize.x, cc.ViewportSize.y
    if instance then
        x = xscale * instance.Size.x + xoffset
        y = yscale * instance.Size.y + yoffset
    else
        x = xscale * vx + xoffset
        y = yscale * vy + yoffset
    end
    return Vector2.new(x, y)
end
--
utility.RobloxPosition = function(xscale, xoffset, yscale, yoffset, instance)
    local x
    local y
    local vx, vy = cc.ViewportSize.x, cc.ViewportSize.y
    if instance then
        x = instance.Position.x + xscale * instance.Size.x + xoffset
        y = instance.Position.y + yscale * instance.Size.y + yoffset
    else
        x = xscale * vx + xoffset
        y = yscale * vy + yoffset
    end
    return Vector2.new(x, y)
end
--
function utility:dragify(Frame , EnabledValue)
    EnabledValue = EnabledValue or True
    dragToggle = nil
    dragInput = nil
    dragStart = nil
    local dragPos = nil
    function updateInput(input)
        local Delta = input.Position - dragStart
        local Position = utility.RobloxPosition(0, startPos.X + Delta.X, 0, startPos.Y + Delta.Y)
        Frame.Position = Position
    end
    UserInput.InputBegan:Connect(
        function(input)
            if
                (input.UserInputType == Enum.UserInputType.MouseButton1 or
                    input.UserInputType == Enum.UserInputType.Touch) and
                    utility:MouseOver(Frame) and EnabledValue
             then
                dragToggle = true
                dragStart = input.Position
                startPos = Frame.Position
                --library.Dragging = true
                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragToggle = false
                        end
                    end
                )
            else
                --library.Dragging = false
            end
        end
    )
    UserInput.InputChanged:Connect(
        function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
             then
                dragInput = input
            end
        end
    )
    game:GetService("UserInputService").InputChanged:Connect(
        function(input)
            if input == dragInput and dragToggle then
                updateInput(input)
            end
        end
    )
end
--
utility.instance.new = function(type)
    if type == "Frame" or type == "frame" then
        local frame = Drawing.new("Square")
        frame.Visible = true
        frame.Filled = true
        frame.Thickness = 0
        frame.Color = Color3.fromRGB(255, 255, 255)
        frame.Size = Vector2.new(100, 100)
        frame.Position = Vector2.new(0, 0)
        frame.ZIndex = 2
        return frame
    elseif type == "TextButton" then
        local Drawings = {}
        Drawings["Background"] = Drawing.new("Square")
        Drawings["TextFrame"] = Drawing.new("Text")
        Drawings["Background"].Visible = true
        Drawings["Background"].Filled = true
        Drawings["Background"].Thickness = 0
        Drawings["Background"].Color = Color3.fromRGB(255, 255, 255)
        Drawings["Background"].Size = Vector2.new(100, 100)
        Drawings["Background"].Position = Vector2.new(0, 0)
        Drawings["TextFrame"].Font = 3
        Drawings["TextFrame"].Visible = true
        Drawings["TextFrame"].Outline = true
        Drawings["TextFrame"].Center = false
        Drawings["TextFrame"].Color = Color3.fromRGB(255, 255, 255)
        Drawings["TextFrame"].ZIndex = 2
        Drawings["Background"].ZIndex = 2
        return Drawings
    elseif type == "TextLabel" or "textlabel" then
        local text = Drawing.new("Text")
        text.Font = 3
        text.Visible = true
        text.Outline = true
        text.Center = false
        text.Color = Color3.fromRGB(255, 255, 255)
        text.ZIndex = 2
        return text
    elseif type == "Image" or "image" then
        local image = Drawing.new("Image")
        image.Position = Vector2.new(0, 0)
        image.Visible = true
        return image
    end
end

return utility
