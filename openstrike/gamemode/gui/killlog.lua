-- CSD is CS:S killicons font
local is_linux = system.IsLinux()

local notice_num = 0
local LINUX_OFFSET = (is_linux) and 12 or 0
local TERRORISTS_COLOR = Color(255, 222, 132)
local CTERRORISTS_COLOR = Color(81, 154, 218)
local color_notice = Color(0, 0, 0, 220)
local color_transparent = Color(0,0,0,0)

local DEATH_NOTICES = {}

function MakeDeathNotice(att, inf, vic, is_headshot)
    local attnick = (not (att:EntIndex() == 0 or att == vic)) and att:Nick() or nil
    local vicnick = vic:Nick()

    local NOTICE_PANEL = vgui.Create("DPanel")
    NOTICE_PANEL:SetTall(35)
    NOTICE_PANEL:DockPadding(10, 0, 10, 0)
    NOTICE_PANEL.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, color_notice)
    end

    if attnick then
        local nickwidth = GetTextSize(attnick, "KillText")
        local attlabel = vgui.Create("DLabel", NOTICE_PANEL)
        attlabel:SetFont("KillText")
        attlabel:SetColor((att:Team() == 0) and TERRORISTS_COLOR or CTERRORISTS_COLOR)
        attlabel:SetWide((nickwidth > 120) and 120 or nickwidth)
        attlabel:SetText(attnick)
        attlabel:Dock(LEFT)
        attlabel:DockMargin(0, 0, 10, 0)
    end
    
    local killlabel = vgui.Create("DLabel", NOTICE_PANEL)
    local letter
    killlabel:SetFont("CSSKillIcons")
    killlabel:Dock(LEFT)
    
    if not attnick then
        is_headshot = false
        letter = "C"
        killlabel:DockMargin(-13, 0, 10, -24 + LINUX_OFFSET)
    elseif string.find(inf, "knife") then
        is_headshot = false
        letter = "j"
        killlabel:DockMargin(0, 0, 10, -24 + LINUX_OFFSET)
    elseif string.find(inf, "explosion") then
        is_headshot = false
        letter = "O"
        killlabel:DockMargin(-5, 0, 0, -20 + LINUX_OFFSET)
    elseif string.find(inf, "deagle") then
        letter = "f"
        killlabel:DockMargin(0, 0, 10, -22 + LINUX_OFFSET)
    elseif string.find(inf, "glock") then
        letter = "c"
        killlabel:DockMargin(-10, 0, 2, -18 + LINUX_OFFSET)
    elseif string.find(inf, "pist") then
        letter = "a"
        killlabel:DockMargin(-10, 0, 0, -18 + LINUX_OFFSET)
    elseif string.find(inf, "shot") then
        letter = "B"
        killlabel:DockMargin(0, 0, 10, -32 + LINUX_OFFSET)
    elseif string.find(inf, "mach") then
        letter = "z"
        killlabel:DockMargin(0, 0, 10, -22 + LINUX_OFFSET)
    elseif string.find(inf, "mac10") then
        letter = "l"
        killlabel:DockMargin(-10, 0, 0, -12 + LINUX_OFFSET)
    elseif string.find(inf, "_mp") then
        letter = "x"
        killlabel:DockMargin(-5, 0, 5, -17 + LINUX_OFFSET)
    elseif string.find(inf, "p90") then
        letter = "m"
        killlabel:DockMargin(-5, 0, 5, -22 + LINUX_OFFSET)
    elseif string.find(inf, "smg") then
        letter = "q"
        killlabel:DockMargin(-3, 0, 7, -20 + LINUX_OFFSET)
    elseif string.find(inf, "ak47") then
        letter = "b"
        killlabel:DockMargin(-3, 0, 7, -25 + LINUX_OFFSET)
    elseif string.find(inf, "aug") then
        letter = "e"
        killlabel:DockMargin(-3, 0, 7, -22 + LINUX_OFFSET)
    elseif string.find(inf, "famas") then
        letter = "t"
        killlabel:DockMargin(-5, 0, 7, -25 + LINUX_OFFSET)
    elseif string.find(inf, "galil") then
        letter = "v"
        killlabel:DockMargin(-5, 0, 7, -25 + LINUX_OFFSET)
    elseif string.find(inf, "rif") then
        letter = "w"
        killlabel:DockMargin(-5, 0, 7, -25 + LINUX_OFFSET)
    elseif string.find(inf, "awp") then
        letter = "r"
        killlabel:DockMargin(0, 0, 10, -30 + LINUX_OFFSET)
    else
        letter = "n"
        killlabel:DockMargin(0, 0, 10, -30 + LINUX_OFFSET)
    end

    killlabel:SetText(letter)
    killlabel:SetWide(GetTextSize(letter, "CSSKillIcons"))

    if is_headshot then
        local headshotlabel = vgui.Create("DLabel", NOTICE_PANEL)
        headshotlabel:SetFont("CSSKillIcons")
        headshotlabel:SetText("D")
        headshotlabel:SetWide(GetTextSize("D", "CSSKillIcons"))
        headshotlabel:Dock(LEFT)
        headshotlabel:DockMargin(-20, 0, 5, -22 + LINUX_OFFSET)
    end

    nickwidth = GetTextSize(vicnick, "KillText")
    local viclabel = vgui.Create("DLabel", NOTICE_PANEL)
    viclabel:SetPos()
    viclabel:SetFont("KillText")
    viclabel:SetColor((vic:Team() == 0) and TERRORISTS_COLOR or CTERRORISTS_COLOR)
    viclabel:SetWide((nickwidth > 120) and 120 or nickwidth)
    viclabel:SetText(vicnick)
    viclabel:Dock(LEFT)

    NOTICE_PANEL:InvalidateLayout(true)
    NOTICE_PANEL:SizeToChildren(true, false)

    notice_num = notice_num + 1
    local this_notice_num = notice_num

    timer.Simple(5, function()
        local timer_name = "notice_" .. tostring(this_notice_num)
        local alpha = 255

        timer.Create(timer_name, 0.05, 0, function()
            if alpha <= 0 then timer.Remove(timer_name) end
            alpha = alpha - 10

            if IsValid(NOTICE_PANEL) then
                NOTICE_PANEL:SetAlpha(alpha)
            end
        end)
    end)

    NOTICE_PANEL:SetPos(ScrW() - NOTICE_PANEL:GetWide() - 20, 100 + 40 * #DEATH_NOTICES)
    table.insert(DEATH_NOTICES, NOTICE_PANEL)
end

hook.Add("CLPlayerDeath", "MakeDeathNotice", function(att, inf, vic, is_headshot)
    MakeDeathNotice(att, inf, vic, is_headshot)
end)

hook.Add("AddDeathNotice", "DisableDefaultDeathNotices", function()
    return true
end)

hook.Add("Think", "ManageDeathNotices", function()
    for i, notice in ipairs(DEATH_NOTICES) do
        if notice:GetAlpha() <= 0 then
            notice:Remove()
            table.remove(DEATH_NOTICES, i)

            for _, _notice in ipairs(DEATH_NOTICES) do
                _notice:SetY(_notice:GetY() - 40)
            end
        end
    end
end)