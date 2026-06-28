local map
local spawn_w = 60

-- Create team spawns
--[[
    (in the parameter include position of 1)
    space between each spawn is 60 source units (spawn_w)

    1   2   3
    4   5   6
    7   8   9
--]]

local function CreateTeamSpawnPoints(pos, ang, _team)
    local layout_ang = Angle(0, ang.y, 0)

    for x = 0, spawn_w * 2, spawn_w do
        for y = 0, spawn_w * 2, spawn_w do
            local computed_pos = pos + layout_ang:Right() * x + layout_ang:Forward() * -y

            spawn = ents.Create("info_player_start_" .. ((_team == 0) and "t" or "cts"))
            spawn:SetPos(computed_pos)
            spawn:SetAngles(ang)
            spawn:Spawn()
            print("[SERVER] Created spawnpoint for " .. team.GetName(_team) .. " at position: " .. tostring(pos))
        end
    end
end

-- if "default" parameter is true, it will create "info_player_start"
-- if not, it will create "info_player_start_os_spawn"
-- it's useful when I want to use default spawnpoints and also add my own
local function CreateSpawnPoint(pos, ang, default)
    spawn = ents.Create("info_player_start_os_spawn")
    spawn:SetPos(pos)
    spawn:SetAngles(ang)
    spawn:Spawn()
    print("[SERVER] Created spawnpoint at position: " .. tostring(pos))
end

hook.Add("PlayerSelectSpawn", "SelectSpawn", function(ply)
    local game_state = GetGlobal2Var("game_state")
    local team = ply:Team()

    if game_state == 2 and ply:Team() ~= 1001 then
        local spawns = ents.FindByClass("info_player_start_" .. ((team == 0) and "t" or "cts"))

        for i = 1, 9, 1 do
            local spawn = spawns[i]
            local spawnpos = spawn:GetPos()
            
            local spawncheck = util.TraceHull({
                start = spawnpos,
                endpos = spawnpos,
                maxs = ply:OBBMaxs(),
                mins = ply:OBBMins(),
                mask = MASK_PLAYERSOLID
            })

            if not spawncheck.Hit then
                return spawn
            end
        end

    elseif game_state < 2 then
        local v1, v2 = ply:GetCollisionBounds()
        local ply_width = v2.x - v1.x
        local spawns = ents.FindByClass("info_player_start")
        local spawn = spawns[math.random(#spawns)]
        local forward_vec = spawn:GetAngles():Forward() * 16
        local spawnpos = spawn:GetPos() - forward_vec
        
        while true do
            spawnpos = spawnpos + forward_vec
            spawncheck = util.TraceHull({
                start = spawnpos,
                endpos = spawnpos,
                maxs = ply:OBBMaxs(),
                mins = ply:OBBMins(),
                mask = MASK_PLAYERSOLID
            })

            if not spawncheck.Hit then
                local newspawn = ents.Create("info_player_start")
                newspawn:SetPos(spawnpos)
                newspawn:SetAngles(spawn:GetAngles())
                newspawn:Spawn()
                ply.Spawnpoint = newspawn
                return newspawn
            end
        end

    else
        local use_default_spawns = table.HasValue(maps_use_default_spawns, map)
        local spawns = ents.FindByClass("info_player_start" .. ((use_default_spawns) and "" or "_os_spawn"))

        math.randomseed(os.time())
        local i_spawn = math.random(#spawns)

        for i = i_spawn, #spawns, 1 do
            local spawn = spawns[i]
            local spawnpos = spawn:GetPos()

            spawncheck = util.TraceHull({
                start = spawnpos,
                endpos = spawnpos,
                maxs = ply:OBBMaxs(),
                mins = ply:OBBMins(),
                mask = MASK_PLAYERSOLID
            })

            if not spawncheck.Hit then
                return spawn
            end

            if i == #spawns then
                i = 0
            end
        end
    end
end)

hook.Add("InitPostEntity", "InitMap", function()
    map = game.GetMap()

    if map == "gm_lobby" then return end

    -- Remove all default NPCs and spawns
    for _, ent in ents.Iterator() do
        if ent:IsNPC() then
            print("[SERVER] Removed NPC: " .. ent:GetClass())
            ent:Remove()
        end
    end
    
    -- Set team spawns and respawnpoints
    if map == "gm_firing_range" then
        CreateTeamSpawnPoints(Vector(2299.8771972656, -854.74822998047, 112.03125), Angle(2.7600073814392, -70.864013671875, 0), 0)
        CreateTeamSpawnPoints(Vector(1635.4187011719, -3428.2387695312, 112.03125), Angle(1.0000102519989, 87.439987182617, 0), 1)

    elseif map == "cs_office_preincident" then
        CreateTeamSpawnPoints(Vector(1276.7058105469, 94.98575592041, -159.96875), Angle(2.0560593605042, 178.72033691406, 0), 0)
        CreateTeamSpawnPoints(Vector(-446.29965209961, 150.69711303711, -159.96875), Angle(1.5280240774155, 0.51239550113678, 0), 1)

    elseif map == "gm_chateau_extended" then
        CreateTeamSpawnPoints(Vector(193.96051025391, 1251.0823974609, 0.03125), Angle(1.0000238418579, -0.079595565795898, 0), 0)
        CreateTeamSpawnPoints(Vector(2292.1052246094, 1153.064453125, 0.03125), Angle(0.82399463653564, -89.13606262207, 0), 1)

        CreateSpawnPoint(Vector(1001.2515258789, 1210.9768066406, 208.03125), Angle(4.0479564666748, 0.43187057971954, 0))
        CreateSpawnPoint(Vector(651.39459228516, 529.13134765625, 208.03125), Angle(3.6959185600281, 119.13585662842, 0))
        CreateSpawnPoint(Vector(-319.29846191406, 546.43981933594, 208.03125), Angle(2.1118903160095, 89.99991607666, 0))
        CreateSpawnPoint(Vector(-550.46752929688, 111.63116455078, 0.03125), Angle(3.5198383331299, 18.0159034729, 0))
        CreateSpawnPoint(Vector(126.49082946777, 939.03662109375, 0.03125), Angle(-0.00015163421630859, 89.903900146484, 0))
        CreateSpawnPoint(Vector(785.78900146484, 405.71664428711, 0.03125), Angle(1.2318507432938, 53.823909759521, 0))
        CreateSpawnPoint(Vector(785.78900146484, 405.71664428711, 0.03125), Angle(1.2318507432938, 53.823909759521, 0))
        CreateSpawnPoint(Vector(2235.4133300781, 896.03125, 0.03125), Angle(2.9918293952942, 91.071792602539, 0))
        CreateSpawnPoint(Vector(2517.9252929688, 1516.7767333984, 152.03125), Angle(1.23186647892, -117.74433898926, 0))
        CreateSpawnPoint(Vector(3068.4074707031, 1035.7127685547, -55.96875), Angle(-9.3281593322754, -177.16825866699, 0))
        CreateSpawnPoint(Vector(129.17922973633, -164.88163757324, -39.96875), Angle(-3.1681442260742, 90.09561920166, 0))
        CreateSpawnPoint(Vector(129.17922973633, -164.88163757324, -39.96875), Angle(-3.1681442260742, 90.09561920166, 0))
        CreateSpawnPoint(Vector(1093.7930908203, 1985.2556152344, 0.03125), Angle(3.1119656562805, 48.015956878662, 0))
        CreateSpawnPoint(Vector(1628.13671875, 1767.6528320312, 0.03125), Angle(1.7039487361908, -93.135887145996, 0))
        CreateSpawnPoint(Vector(1791.4002685547, 1204.8151855469, 0.03125), Angle(1.351936340332, 0.32019340991974, 0))
        CreateSpawnPoint(Vector(1791.4002685547, 1204.8151855469, 0.03125), Angle(1.351936340332, 0.32019340991974, 0))
        CreateSpawnPoint(Vector(-204.10067749023, 1829.5190429688, 0.03125), Angle(0.99980843067169, -90.49584197998, 0))
        CreateSpawnPoint(Vector(-322.95962524414, 908.68682861328, 208.03125), Angle(1.1758013963699, -89.183807373047, 0))

    elseif map == "gm_hl2_dust2" then
        CreateTeamSpawnPoints(Vector(-550.37939453125, -753.64880371094, 160.50518798828), Angle(1.7040247917175, 0.20341897010803, 0), 0)
        CreateTeamSpawnPoints(Vector(352.18005371094, 2257.9895019531, -101.60269165039), Angle(-0.76006412506104, -2.2762260437012, 0), 1)

        CreateSpawnPoint(Vector(577.80804443359, 624.93756103516, 1.9438400268555), Angle(-0.23206317424774, 60.012023925781, 0))
        CreateSpawnPoint(Vector(-1965.1123046875, -919.7548828125, 141.6953125), Angle(2.5838809013367, 86.140197753906, 0))
        CreateSpawnPoint(Vector(299.91516113281, -837.89068603516, 15.386787414551), Angle(0.47178661823273, 93.084136962891, 0))
        CreateSpawnPoint(Vector(1558.4543457031, 1819.9819335938, 11.99967956543), Angle(-0.58417892456055, 127.30824279785, 0))
        CreateSpawnPoint(Vector(365.95132446289, 2509.1772460938, 96.03125), Angle(0.11984717845917, 0.060551166534424, 0))
        CreateSpawnPoint(Vector(-125.48401641846, 1471.7750244141, 0.03125), Angle(0.11986494064331, -108.17959594727, 0))
        CreateSpawnPoint(Vector(-364.40231323242, 2226.0278320312, -126.72776794434), Angle(-1.816258430481, -95.523712158203, 0))
        CreateSpawnPoint(Vector(-1984.6732177734, 2786.8276367188, 32.03125), Angle(-0.40826344490051, -80.307540893555, 0))
        CreateSpawnPoint(Vector(-2084.4621582031, 1128.7105712891, 32.03125), Angle(-1.6402229070663, 1.004317522049, 0))
        CreateSpawnPoint(Vector(-429.08676147461, 135.36489868164, 2.0037155151367), Angle(-0.23224139213562, 89.020446777344, 0))
        CreateSpawnPoint(Vector(-1414.5753173828, 158.38864135742, 8.8443145751953), Angle(-1.1122930049896, 120.42855834961, 0))
        CreateSpawnPoint(Vector(1666.51953125, 694.42987060547, 64.03125), Angle(3.4637389183044, 116.18850708008, 0))
        CreateSpawnPoint(Vector(689.81805419922, 340.22012329102, 2.7775764465332), Angle(-0.93623650074005, -124.93117523193, 0))
        CreateSpawnPoint(Vector(-51.204830169678, 355.93862915039, 1.7190780639648), Angle(4.6958303451538, 120.74877166748, 0))
        CreateSpawnPoint(Vector(-629.25561523438, 1440.9207763672, -111.96875), Angle(-5.5121073722839, -22.083250045776, 0))
        CreateSpawnPoint(Vector(-427.40600585938, -307.07437133789, 9.5065460205078), Angle(-0.40790820121765, -73.651161193848, 0))
        CreateSpawnPoint(Vector(-2103.0063476562, 1850.6192626953, 0.74678039550781), Angle(-2.519947052002, 36.333068847656, 0))
        CreateSpawnPoint(Vector(389.47854614258, 2227.8337402344, -97.696258544922), Angle(-7.8000221252441, -0.96321558952332, 0))

    elseif map == "cs_cs16_assault" then
        CreateTeamSpawnPoints(Vector(688.91729736328, 893.63024902344, -767.96875), Angle(0.70382142066956, 179.99955749512, 0), 0)
        CreateTeamSpawnPoints(Vector(-502.96331787109, -769.61004638672, -767.96875), Angle(-0.88016545772552, 89.43953704834, 0), 1)
        
        CreateSpawnPoint(Vector(-153.09088134766, -943.53186035156, -767.96875), Angle(-1.3520007133484, 114.51196289062, 0))
        CreateSpawnPoint(Vector(787.63452148438, -1139.2712402344, -767.96875), Angle(-0.99999010562897, 144.95979309082, 0))
        CreateSpawnPoint(Vector(1297.3240966797, -113.72457885742, -767.96875), Angle(3.4640464782715, 134.5760345459, 0))
        CreateSpawnPoint(Vector(-1016.3681640625, -1360.1595458984, -767.96875), Angle(-2.3439297676086, 76.84782409668, 0))
        CreateSpawnPoint(Vector(-381.88171386719, 1074.5006103516, -767.96875), Angle(0.29602813720703, -13.440254211426, 0))
        CreateSpawnPoint(Vector(254.5749206543, 644.71032714844, -511.96875), Angle(18.247983932495, 21.311912536621, 0))
        CreateSpawnPoint(Vector(943.68359375, 1737, -431.96875), Angle(13.671993255615, -134.36769104004, 0))
        CreateSpawnPoint(Vector(1128.298828125, 564.29290771484, -463.96875), Angle(15.079992294312, 157.69619750977, 0))
        CreateSpawnPoint(Vector(285.00531005859, -82.85530090332, -767.96875), Angle(0.82394886016846, 142.36819458008, 0))
        CreateSpawnPoint(Vector(-774.91711425781, 590.85522460938, -511.96875), Angle(11.208064079285, -26.687564849854, 0))
        CreateSpawnPoint(Vector(-1274.9805908203, -846.05792236328, -751.96875), Angle(0.29605555534363, 8.4165554046631, 0))
        CreateSpawnPoint(Vector(-137.15852355957, 1371.2796630859, -431.96875), Angle(2.2320175170898, 34.816738128662, 0))
        CreateSpawnPoint(Vector(73.968208312988, 1356.0383300781, -431.96875), Angle(-2.5199704170227, 0.32079482078552, 0))
        CreateSpawnPoint(Vector(94.341087341309, 444.23950195312, -767.96875), Angle(0.12001383304596, -39.887218475342, 0))
        CreateSpawnPoint(Vector(961.25433349609, -500.76400756836, -767.96875), Angle(-0.05601978302002, -138.54295349121, 0))
        CreateSpawnPoint(Vector(1518.5981445312, 987.67938232422, -767.96875), Angle(-0.58419048786163, -94.81477355957, 0))
        CreateSpawnPoint(Vector(-387.21197509766, 42.104961395264, -767.96875), Angle(0.4717470407486, -19.583000183105, 0))
        CreateSpawnPoint(Vector(529.97863769531, 1870.771484375, -639.96875), Angle(0.29566121101379, -71.246925354004, 0))

    elseif map == "cs_jungle" then
        CreateTeamSpawnPoints(Vector(-1798.7628173828, -3788.1586914062, 158.2966003418), Angle(4.2240495681763, 88.642684936523, 0), 0)
        CreateTeamSpawnPoints(Vector(446.28939819336, 869.90966796875, -105.1849822998), Angle(1.0000383853912, -114.01341247559, 0), 1)

        CreateSpawnPoint(Vector(-1742.8662109375, -3984.1293945312, 122.14933776855), Angle(-0.17605769634247, 94.464080810547, 0))
        CreateSpawnPoint(Vector(-458.75244140625, -2370.7436523438, 105.68212890625), Angle(1.231919169426, -15.63187122345, 0))
        CreateSpawnPoint(Vector(1721.4693603516, 1483.5062255859, -131.96875), Angle(-2.1120767593384, -152.64012145996, 0))
        CreateSpawnPoint(Vector(126.70464324951, -856.42987060547, 76.986480712891), Angle(-1.760101556778, -161.69627380371, 0))
        CreateSpawnPoint(Vector(-2530.0490722656, -1936.2729492188, 278.54525756836), Angle(10.207895278931, 67.983795166016, 0))
        CreateSpawnPoint(Vector(-3607.7407226562, -1438.62890625, 576.03125), Angle(-1.1120316982269, 83.199699401855, 0))
        CreateSpawnPoint(Vector(-2436.0769042969, -4418.4331054688, 517.26141357422), Angle(-2.6960206031799, 98.239761352539, 0))
        CreateSpawnPoint(Vector(-2067.7985839844, -166.26113891602, 579.59155273438), Angle(3.8160266876221, 28.975896835327, 0))
        CreateSpawnPoint(Vector(-576.58905029297, 1134.4875488281, -115.02346801758), Angle(-1.9920154809952, -60.784099578857, 0))
        CreateSpawnPoint(Vector(1317.1303710938, -1061.6656494141, 114.07531738281), Angle(1.3519554138184, -118.33602905273, 0))
        CreateSpawnPoint(Vector(-1542.6984863281, -1555.0012207031, 99.700210571289), Angle(3.6399383544922, 42.879558563232, 0))
        CreateSpawnPoint(Vector(-2890.2116699219, -1069.06640625, 442.06018066406), Angle(10.504093170166, -44.256923675537, 0))
        CreateSpawnPoint(Vector(345.11227416992, 238.81866455078, -127.96875762939), Angle(-11.143977165222, -120.64098358154, 0))
        CreateSpawnPoint(Vector(-2845.6027832031, -2833.7241210938, 575.56823730469), Angle(1.3520550727844, -176.80097961426, 0))
        CreateSpawnPoint(Vector(1659.9645996094, 518.09387207031, -95.96875), Angle(3.8161268234253, -152.27305603027, 0))
        CreateSpawnPoint(Vector(595.20770263672, 508.17407226562, -127.96875), Angle(2.9361152648926, 57.166927337646, 0))
        CreateSpawnPoint(Vector(466.42276000977, -2045.3334960938, 100.40158081055), Angle(3.1121678352356, -116.28903198242, 0))
        CreateSpawnPoint(Vector(-1814.5118408203, -4331.3657226562, 338.00872802734), Angle(14.552158355713, 127.0230178833, 0))

    elseif map == "de_tuscan" then
        CreateTeamSpawnPoints(Vector(-225.14155578613, 2058.8032226562, -143.96875), Angle(-0.35200607776642, 0.33607411384583, 0), 0)
        CreateTeamSpawnPoints(Vector(-347.49749755859, -1950.5728759766, -37.012531280518), Angle(3.1680326461792, 90.176200866699, 0), 1)

        CreateSpawnPoint(Vector(-1188.7136230469, 1875.1510009766, -172.19305419922), Angle(1.2320280075073, -78.43189239502, 0))
        CreateSpawnPoint(Vector(205.6057434082, 1178.4052734375, -84.983329772949), Angle(7.0400094985962, 45.824035644531, 0))
        CreateSpawnPoint(Vector(-1158.2924804688, 380.16915893555, -191.70477294922), Angle(-4.5759620666504, -86.080093383789, 0))
        CreateSpawnPoint(Vector(-1641.6661376953, -506.58670043945, -39.96875), Angle(1.2320427894592, -136.59187316895, 0))
        CreateSpawnPoint(Vector(-605.26672363281, -1004.2153930664, -67.895957946777), Angle(-0.35194945335388, -6.1760263442993, 0))
        CreateSpawnPoint(Vector(1309.0949707031, 144.98223876953, -181.61291503906), Angle(0.52803444862366, -122.76808929443, 0))
        CreateSpawnPoint(Vector(-1736.2769775391, -1268.0329589844, 120.03125), Angle(3.8720405101776, 89.727836608887, 0))
        CreateSpawnPoint(Vector(-551.859375, -184.97039794922, -79.96875), Angle(-7.0399532318115, -111.0880279541, 0))
        CreateSpawnPoint(Vector(-1531.0108642578, -1249.9460449219, -32.268867492676), Angle(2.1120100021362, -15.967864990234, 0))
        CreateSpawnPoint(Vector(-85.221687316895, 503.36859130859, -182.70318603516), Angle(0.70404815673828, -94.111877441406, 0))
        CreateSpawnPoint(Vector(-7.9810919761658, 1096.5550537109, -218.29850769043), Angle(-1.2319532632828, 177.36010742188, 0))
        CreateSpawnPoint(Vector(-616.14813232422, 269.5686340332, -199.96875), Angle(1.408079624176, 92.15998840332, 0))
        CreateSpawnPoint(Vector(-339.63027954102, 1777.9642333984, -143.96875), Angle(-2.8158869743347, 26.75193977356, 0))
        CreateSpawnPoint(Vector(427.7080078125, -638.74304199219, -75.896110534668), Angle(-1.9358869791031, -100.49602508545, 0))
        CreateSpawnPoint(Vector(999.31439208984, -1729.8049316406, -245.48362731934), Angle(6.5121088027954, 127.85578155518, 0))
        CreateSpawnPoint(Vector(999.31439208984, -1729.8049316406, -245.48362731934), Angle(6.5121088027954, 127.85578155518, 0))
        CreateSpawnPoint(Vector(1322.2629394531, 480.16412353516, -368.70077514648), Angle(2.8160862922668, 145.27983093262, 0))
        CreateSpawnPoint(Vector(-145.90968322754, -1844.7716064453, -29.443309783936), Angle(6.8079895973206, 114.39992523193, 0))

    elseif map == "cs_downed_css_b2" then
        CreateTeamSpawnPoints(Vector(-828.47998046875, 625.05450439453, 218.19683837891), Angle(10.855997085571, 179.29656982422, 0), 0)
        CreateTeamSpawnPoints(Vector(1705.4552001953, 6.879403591156, 74.248481750488), Angle(-1.2880629301071, -178.23950195312, 0), 1)

        CreateSpawnPoint(Vector(1037.2674560547, 70.698883056641, 128.74981689453), Angle(-8.6800889968872, 104.4164276123, 0))
        CreateSpawnPoint(Vector(330.64956665039, 353.58926391602, 192.03125), Angle(-0.58407342433929, 120.60846710205, 0))
        CreateSpawnPoint(Vector(-426.84301757812, 253.82513427734, 191.29588317871), Angle(2.4079322814941, 175.87237548828, 0))
        CreateSpawnPoint(Vector(-857.35821533203, -708.74377441406, -1.1276340484619), Angle(4.1679558753967, -143.82371520996, 0))
        CreateSpawnPoint(Vector(-2034.0137939453, 217.7103729248, 34.03125), Angle(3.4639735221863, 90.528259277344, 0))
        CreateSpawnPoint(Vector(-2112.03515625, -122.46720123291, -29.96875), Angle(2.055995464325, -31.183809280396, 0))
        CreateSpawnPoint(Vector(900.35491943359, 1122.0014648438, 197.92678833008), Angle(1.3169022798538, -120.67877960205, 0))
        CreateSpawnPoint(Vector(908.02484130859, -468.66387939453, -40.385917663574), Angle(-3.2591061592102, -97.814727783203, 0))
        CreateSpawnPoint(Vector(62.483325958252, -1323.9232177734, -4.2598171234131), Angle(1.8449083566666, -6.6469769477844, 0))
        CreateSpawnPoint(Vector(-640.29779052734, -375.70864868164, -207.03016662598), Angle(10.116927146912, -98.503227233887, 0))
        CreateSpawnPoint(Vector(-2272.7124023438, -433.79769897461, -147.96875), Angle(-13.643049240112, 84.792724609375, 0))
        CreateSpawnPoint(Vector(126.22972106934, -791.79986572266, 64.03125), Angle(-3.082989692688, 45.720741271973, 0))
        CreateSpawnPoint(Vector(-1441.6281738281, -252.27145385742, -29.968751907349), Angle(1.4930747747421, -92.695350646973, 0))
        CreateSpawnPoint(Vector(-1002.5416870117, -1331.6336669922, -24.888586044312), Angle(0.26109957695007, 136.71267700195, 0))
        CreateSpawnPoint(Vector(705.84515380859, 1447.8498535156, 356.03125), Angle(2.0210752487183, -149.81546020508, 0))
        CreateSpawnPoint(Vector(746.99084472656, 571.02154541016, 356.03125), Angle(5.576099395752, 42.104598999023, 0))
        CreateSpawnPoint(Vector(-254.5567779541, 541.4384765625, 356.03125), Angle(1.7041392326355, 113.20864868164, 0))
        CreateSpawnPoint(Vector(-1627.0108642578, 725.70159912109, 98.03125), Angle(-0.23186194896698, -67.079627990723, 0))

    elseif map == "de_mirage_css" then
        CreateTeamSpawnPoints(Vector(-1657.4077148438, -1898.5446777344, -267.07104492188), Angle(0.70401096343994, -1.408295750618, 0), 0)
        CreateTeamSpawnPoints(Vector(1295.7404785156, -315.8005065918, -167.81126403809), Angle(-0.35197377204895, -90.720283508301, 0), 1)

        CreateSpawnPoint(Vector(-11.389558792114, -2160.0634765625, -162.07783508301), Angle(0.88009572029114, 139.91952514648, 0))
        CreateSpawnPoint(Vector(-1675.7757568359, -2236.7521972656, -264.19671630859), Angle(-7.0399103164673, -15.488446235657, 0))
        CreateSpawnPoint(Vector(-2341.7807617188, -556.60583496094, -167.96875), Angle(0.17606675624847, 87.119514465332, 0))
        CreateSpawnPoint(Vector(-2591.2436523438, 486.86465454102, -163.96537780762), Angle(0.35205340385437, -14.608558654785, 0))
        CreateSpawnPoint(Vector(-2591.2436523438, 486.86465454102, -163.96537780762), Angle(0.35205340385437, -14.608558654785, 0))
        CreateSpawnPoint(Vector(432.12432861328, -818.017578125, -167.96875), Angle(6.6881256103516, 136.12750244141, 0))
        CreateSpawnPoint(Vector(-1012.2700805664, 450.7155456543, -367.96875), Angle(-21.823883056641, -3.2646427154541, 0))
        CreateSpawnPoint(Vector(-1102.9760742188, 424.11822509766, -79.96875), Angle(2.4641263484955, 88.959350585938, 0))
        CreateSpawnPoint(Vector(1145.4165039062, 528.20373535156, -261.40209960938), Angle(1.2320322990417, -177.40866088867, 0))
        CreateSpawnPoint(Vector(1307.4514160156, -1438.666015625, -167.96875), Angle(1.4080386161804, 178.7191619873, 0))
        CreateSpawnPoint(Vector(364.38375854492, -2070.1896972656, -39.96875), Angle(3.3440527915955, -23.936975479126, 0))
        CreateSpawnPoint(Vector(-1697.7316894531, 758.20324707031, -39.96875), Angle(3.1680469512939, -89.409156799316, 0))
        CreateSpawnPoint(Vector(318.37228393555, 622.01574707031, -239.65802001953), Angle(-5.27991771698, -92.145126342773, 0))
        CreateSpawnPoint(Vector(-495.31097412109, -2311.841796875, -167.96740722656), Angle(-1.759920835495, 95.550903320312, 0))
        CreateSpawnPoint(Vector(-1029.2943115234, -613.46643066406, -263.96875), Angle(-6.3359189033508, -28.624992370605, 0))
        CreateSpawnPoint(Vector(-1255.7926025391, -1397.2947998047, -166.38827514648), Angle(-1.2319370508194, 78.639060974121, 0))
        CreateSpawnPoint(Vector(729.52264404297, -1057.5616455078, -261.26507568359), Angle(0.88009297847748, -93.232978820801, 0))
        CreateSpawnPoint(Vector(260.34991455078, -1471.3012695312, -167.96875), Angle(-0.70390212535858, -149.2809753418, 0))

    elseif map == "de_airstrip_css" then
        CreateTeamSpawnPoints(Vector(5882.78515625, -5525.2358398438, -128.82252502441), Angle(2.8159508705139, -179.47155761719, 0), 0)
        CreateTeamSpawnPoints(Vector(673.72875976562, -4420.85546875, -169.78981018066), Angle(0.1759649515152, 0.68798279762268, 0), 1)

        CreateSpawnPoint(Vector(5091.8188476562, -4486.5830078125, -129.85618591309), Angle(-1.4079991579056, -94.592010498047, 0))
        CreateSpawnPoint(Vector(4483.611328125, -4449.587890625, -137.28308105469), Angle(-1.7600036859512, -179.24795532227, 0))
        CreateSpawnPoint(Vector(3096.4731445312, -4051.7041015625, -119.96875), Angle(-1.4080072641373, 78.320182800293, 0))
        CreateSpawnPoint(Vector(3197.15625, -1692.4572753906, -137.58378601074), Angle(-1.7599711418152, -112.01608276367, 0))
        CreateSpawnPoint(Vector(1220.7514648438, -2003.8063964844, -139.35035705566), Angle(0.17601096630096, -68.623985290527, 0))
        CreateSpawnPoint(Vector(2219.7565917969, -2821.9528808594, -127.96875762939), Angle(-0.88006579875946, -3.4083709716797, 0))
        CreateSpawnPoint(Vector(5889.1430664062, -5872.3359375, -130.29721069336), Angle(-0.17611253261566, 179.53544616699, 0))
        CreateSpawnPoint(Vector(3664.9916992188, -5396.5434570312, -303.96875), Angle(0.3520290851593, 159.11949157715, 0))
        CreateSpawnPoint(Vector(2227.2255859375, -5617.5385742188, -154.0671081543), Angle(-0.70399761199951, 91.007431030273, 0))
        CreateSpawnPoint(Vector(717.84887695312, -4532.7514648438, -174.49269104004), Angle(-1.7600042819977, 9.8712787628174, 0))
        CreateSpawnPoint(Vector(4373.0141601562, -6056.2368164062, -119.96875), Angle(0.12006461620331, 107.71103668213, 0))
        CreateSpawnPoint(Vector(4171.923828125, -3891.9970703125, -297.64993286133), Angle(-3.7519445419312, -3.7770903110504, 0))
        CreateSpawnPoint(Vector(2120.8168945312, -1284.6348876953, -119.96875), Angle(-1.9921156167984, -171.34455871582, 0))
        CreateSpawnPoint(Vector(3839.9599609375, -2891.779296875, -131.37245178223), Angle(-4.4561266899109, 145.8715057373, 0))
        CreateSpawnPoint(Vector(6135.96875, -4739.0502929688, -119.96875), Angle(-3.2242126464844, -117.3286819458, 0))
        CreateSpawnPoint(Vector(2908.0666503906, -4766.2377929688, -327.18716430664), Angle(-9.0320053100586, -95.424819946289, 0))
        CreateSpawnPoint(Vector(2147.5864257812, -3792.2224121094, -175.09648132324), Angle(-0.93614554405212, -88.912910461426, 0))
        CreateSpawnPoint(Vector(4761.3168945312, -6204.228515625, -119.96875), Angle(-0.76011228561401, 90.143295288086, 0))
    end
end)