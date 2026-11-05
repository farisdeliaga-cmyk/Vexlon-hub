--[[ Vexlon Hub: TSB + Doors (Ultimate Edition) ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
if not LP then repeat task.wait(0.1) until Players.LocalPlayer; LP = Players.LocalPlayer end

local PlaceId = game.PlaceId
local C = {bg=Color3.fromRGB(14,14,18), panel=Color3.fromRGB(20,20,26), side=Color3.fromRGB(16,16,21), accent=Color3.fromRGB(145,100,255), text=Color3.fromRGB(235,235,245), dim=Color3.fromRGB(125,125,145), on=Color3.fromRGB(0,215,150)}

-- ==========================================
-- UI KÜTÜPHANESİ
-- ==========================================
local function createGUI()
    local gui=Instance.new("ScreenGui") gui.Name="VexlonHub" gui.ResetOnSpawn=false gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    local parent = (gethui and gethui()) or LP:WaitForChild("PlayerGui")
    gui.Parent = parent
    
    local main=Instance.new("Frame") main.Size=UDim2.fromOffset(720,480) main.Position=UDim2.new(0.5,-360,0.5,-240) main.BackgroundColor3=C.bg main.BorderSizePixel=0 main.Active=true main.Parent=gui
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,12)
    local stroke=Instance.new("UIStroke",main) stroke.Color=C.accent stroke.Thickness=1 stroke.Transparency=0.5
    
    local ds,sp 
    main.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then ds=i.Position sp=main.Position i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then ds=nil end end) end end) 
    main.InputChanged:Connect(function(i) if ds and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-ds main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y) end end)
    
    local top=Instance.new("Frame") top.Size=UDim2.new(1,0,0,50) top.BackgroundTransparency=1 top.Parent=main
    local title=Instance.new("TextLabel") title.Position=UDim2.fromOffset(20,0) title.Size=UDim2.new(0,200,1,0) title.BackgroundTransparency=1 title.Font=Enum.Font.GothamBold title.TextSize=18 title.TextXAlignment=Enum.TextXAlignment.Left title.TextColor3=C.text title.Text="Vexlon Hub" title.Parent=top
    
    local search=Instance.new("TextBox") search.Size=UDim2.new(0,200,0,30) search.Position=UDim2.new(0.5,-100,0,10) search.BackgroundColor3=C.panel search.BorderSizePixel=0 search.Font=Enum.Font.Gotham search.TextSize=13 search.TextColor3=C.text search.PlaceholderText="Search..." search.PlaceholderColor3=C.dim search.Text="" search.ClearTextOnFocus=false search.Parent=top
    Instance.new("UICorner",search).CornerRadius=UDim.new(0,6)
    
    local close=Instance.new("TextButton") close.Size=UDim2.fromOffset(30,30) close.Position=UDim2.new(1,-45,0,10) close.BackgroundColor3=Color3.fromRGB(35,35,45) close.Text="×" close.Font=Enum.Font.GothamBold close.TextSize=20 close.TextColor3=C.text close.BorderSizePixel=0 close.Parent=top
    Instance.new("UICorner",close).CornerRadius=UDim.new(0,6) 
    close.MouseButton1Click:Connect(function() gui.Enabled=not gui.Enabled end)
    
    local sidebar=Instance.new("ScrollingFrame") sidebar.Position=UDim2.fromOffset(0,50) sidebar.Size=UDim2.new(0,180,1,-50) sidebar.BackgroundColor3=C.side sidebar.BorderSizePixel=0 sidebar.ScrollBarThickness=0 sidebar.Parent=main
    local sList=Instance.new("UIListLayout",sidebar) sList.Padding=UDim.new(0,4) sList.SortOrder=Enum.SortOrder.LayoutOrder
    local sPad=Instance.new("UIPadding",sidebar) sPad.PaddingTop=UDim.new(0,10) sPad.PaddingLeft=UDim.new(0,10) sPad.PaddingRight=UDim.new(0,10)
    
    local content=Instance.new("Frame") content.Position=UDim2.fromOffset(190,60) content.Size=UDim2.new(1,-200,1,-70) content.BackgroundTransparency=1 content.Parent=main
    
    local tabs, allElements = {}, {}
    
    local function makeTab(name, order)
        local btn=Instance.new("TextButton") btn.Size=UDim2.new(1,0,0,36) btn.BackgroundColor3=C.panel btn.BackgroundTransparency=0.6 btn.Text="  "..name btn.TextXAlignment=Enum.TextXAlignment.Left btn.Font=Enum.Font.GothamMedium btn.TextSize=14 btn.TextColor3=C.dim btn.BorderSizePixel=0 btn.LayoutOrder=order btn.Parent=sidebar
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
        
        local page=Instance.new("ScrollingFrame") page.Size=UDim2.fromScale(1,1) page.BackgroundTransparency=1 page.BorderSizePixel=0 page.ScrollBarThickness=2 page.ScrollBarImageColor3=C.accent page.CanvasSize=UDim2.new() page.AutomaticCanvasSize=Enum.AutomaticSize.Y page.Visible=false page.Parent=content
        local pList=Instance.new("UIListLayout",page) pList.Padding=UDim.new(0,6)
        local pPad=Instance.new("UIPadding",page) pPad.PaddingRight=UDim.new(0,10)
        
        tabs[name]=page
        
        local function selectTab()
            for n,p in pairs(tabs) do p.Visible=(n==name) end
            for _,b in ipairs(sidebar:GetChildren()) do 
                if b:IsA("TextButton") then 
                    b.TextColor3=(b==btn) and C.text or C.dim 
                    b.BackgroundTransparency=(b==btn) and 0 or 0.6 
                end 
            end
        end
        
        btn.MouseButton1Click:Connect(selectTab)
        if order == 1 then task.defer(selectTab) end
        return page
    end
    
    local function makeColumns(page)
        local frame=Instance.new("Frame") frame.Size=UDim2.new(1,0,0,0) frame.AutomaticSize=Enum.AutomaticSize.Y frame.BackgroundTransparency=1 frame.Parent=page
        local layout=Instance.new("UIListLayout",frame) layout.FillDirection=Enum.FillDirection.Horizontal layout.Padding=UDim.new(0,10)
        local col1=Instance.new("Frame") col1.Size=UDim2.new(0.5,-5,0,0) col1.AutomaticSize=Enum.AutomaticSize.Y col1.BackgroundTransparency=1 col1.Parent=frame
        local l1=Instance.new("UIListLayout",col1) l1.Padding=UDim.new(0,6)
        local col2=Instance.new("Frame") col2.Size=UDim2.new(0.5,-5,0,0) col2.AutomaticSize=Enum.AutomaticSize.Y col2.BackgroundTransparency=1 col2.Parent=frame
        local l2=Instance.new("UIListLayout",col2) l2.Padding=UDim.new(0,6)
        return col1, col2
    end

    local function section(par, text)
        local l=Instance.new("TextLabel") l.Size=UDim2.new(1,0,0,24) l.BackgroundTransparency=1 l.Font=Enum.Font.GothamBold l.TextSize=12 l.TextXAlignment=Enum.TextXAlignment.Left l.TextColor3=C.accent l.Text=string.upper(text) l.Parent=par
        table.insert(allElements, l)
    end

    local function toggle(par, text, default, cb)
        local f=Instance.new("Frame") f.Size=UDim2.new(1,0,0,34) f.BackgroundColor3=C.panel f.BorderSizePixel=0 f.Parent=par
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local t=Instance.new("TextLabel") t.Size=UDim2.new(1,-60,1,0) t.Position=UDim2.fromOffset(10,0) t.BackgroundTransparency=1 t.Font=Enum.Font.GothamMedium t.TextSize=13 t.TextXAlignment=Enum.TextXAlignment.Left t.TextColor3=C.text t.Text=text t.Parent=f
        local state=default or false
        local b=Instance.new("TextButton") b.Size=UDim2.fromOffset(36,18) b.Position=UDim2.new(1,-46,0.5,-9) b.BackgroundColor3=state and C.on or Color3.fromRGB(40,40,50) b.Text="" b.BorderSizePixel=0 b.Parent=f
        Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
        local k=Instance.new("Frame") k.Size=UDim2.fromOffset(14,14) k.Position=state and UDim2.new(1,-16,0.5,-7) or UDim2.fromOffset(2,2) k.BackgroundColor3=Color3.fromRGB(255,255,255) k.Parent=b
        Instance.new("UICorner",k).CornerRadius=UDim.new(1,0)
        b.MouseButton1Click:Connect(function() state=not state b.BackgroundColor3=state and C.on or Color3.fromRGB(40,40,50) TweenService:Create(k,TweenInfo.new(0.15),{Position=state and UDim2.new(1,-16,0.5,-7) or UDim2.fromOffset(2,2)}):Play() if cb then cb(state) end end)
        f.Name=text table.insert(allElements, f)
    end

    local function slider(par, text, min, max, default, cb)
        local f=Instance.new("Frame") f.Size=UDim2.new(1,0,0,46) f.BackgroundColor3=C.panel f.BorderSizePixel=0 f.Parent=par
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local val=default or min
        local t=Instance.new("TextLabel") t.Size=UDim2.new(1,-20,0,20) t.Position=UDim2.fromOffset(10,4) t.BackgroundTransparency=1 t.Font=Enum.Font.Gotham t.TextSize=12 t.TextXAlignment=Enum.TextXAlignment.Left t.TextColor3=C.dim t.Text=text..": "..tostring(val) t.Parent=f
        local bar=Instance.new("Frame") bar.Size=UDim2.new(1,-20,0,5) bar.Position=UDim2.fromOffset(10,28) bar.BackgroundColor3=Color3.fromRGB(40,40,50) bar.BorderSizePixel=0 bar.Parent=f
        Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
        local fill=Instance.new("Frame") fill.Size=UDim2.fromScale((val-min)/(max-min),1) fill.BackgroundColor3=C.accent fill.BorderSizePixel=0 fill.Parent=bar
        Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
        local function set(x) local a=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1) local v=math.floor(min+(max-min)*a+0.5) val=v fill.Size=UDim2.fromScale(a,1) t.Text=text..": "..tostring(v) if cb then cb(v) end end
        bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then set(i.Position.X) end end)
        UIS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and bar.AbsoluteSize.X>0 then set(i.Position.X) end end end)
        f.Name=text table.insert(allElements, f)
    end

    local function button(par, text, cb)
        local b=Instance.new("TextButton") b.Size=UDim2.new(1,0,0,32) b.BackgroundColor3=C.accent b.BorderSizePixel=0 b.Font=Enum.Font.GothamBold b.TextSize=12 b.TextColor3=Color3.fromRGB(255,255,255) b.Text=text b.Parent=par
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
        b.MouseButton1Click:Connect(function() pcall(cb) end)
        b.Name=text table.insert(allElements, b)
    end

    local function textbox(par, text, ph, cb)
        local f=Instance.new("Frame") f.Size=UDim2.new(1,0,0,50) f.BackgroundColor3=C.panel f.BorderSizePixel=0 f.Parent=par
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local t=Instance.new("TextLabel") t.Size=UDim2.new(1,-20,0,20) t.Position=UDim2.fromOffset(10,4) t.BackgroundTransparency=1 t.Font=Enum.Font.Gotham t.TextSize=12 t.TextXAlignment=Enum.TextXAlignment.Left t.TextColor3=C.dim t.Text=text t.Parent=f
        local e=Instance.new("TextBox") e.Size=UDim2.new(1,-20,0,22) e.Position=UDim2.fromOffset(10,24) e.BackgroundColor3=C.bg e.BorderSizePixel=0 e.Font=Enum.Font.Gotham e.TextSize=12 e.TextColor3=C.text e.PlaceholderText=ph e.PlaceholderColor3=C.dim e.Text="" e.ClearTextOnFocus=false e.Parent=f
        Instance.new("UICorner",e).CornerRadius=UDim.new(0,4)
        e:GetPropertyChangedSignal("Text"):Connect(function() if cb then cb(e.Text) end end)
        f.Name=text table.insert(allElements, f)
    end

    search:GetPropertyChangedSignal("Text"):Connect(function()
        local txt=search.Text:lower()
        for _,el in ipairs(allElements) do el.Visible=(txt=="" or el.Name:lower():find(txt)~=nil) end
    end)

    return makeTab, makeColumns, section, toggle, slider, button, textbox
end

-- ==========================================
-- OYUN MANTIĞI
-- ==========================================
if PlaceId == 10449761463 then
    local makeTab, makeCols, sec, tog, sld, btn, txt = createGUI()
    
    local function getChar() local c=LP.Character if c and c:FindFirstChildOfClass("Humanoid") then return c end end
    local function getHRP() local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end
    local function findP(s) s=tostring(s or ""):gsub("%s+","") if s=="" then return nil end local l=s:lower() for _,p in ipairs(Players:GetPlayers()) do if p~=LP and (p.Name:lower()==l or p.DisplayName:lower()==l) then return p end end end

    local lastSafe=nil
    task.spawn(function() while task.wait(0.8) do local h=getHRP() if h and h.Position.Y>-70 then lastSafe=h.CFrame end end end)
    local function void() local h=getHRP() if not h then return end if h.Position.Y>-70 then lastSafe=h.CFrame end h.CFrame=CFrame.new(h.Position.X,-3000,h.Position.Z) task.wait(0.35) if lastSafe then h.CFrame=lastSafe+Vector3.new(0,3,0) end end
    local function fling(t) local c=t.Character if not c then return end local h=c:FindFirstChild("HumanoidRootPart") if not h then return end local hum=c:FindFirstChildOfClass("Humanoid") if hum then hum.PlatformStand=true end local bv=Instance.new("BodyAngularVelocity") bv.AngularVelocity=Vector3.new(9e7,9e7,9e7) bv.MaxTorque=Vector3.new(9e9,9e9,9e9) bv.Parent=h h.AssemblyAngularVelocity=Vector3.new(9e7,9e7,9e7) h.AssemblyLinearVelocity=Vector3.new(9e7,9e7*2,9e7) task.delay(0.7,function() bv:Destroy() if h then h.AssemblyAngularVelocity=Vector3.zero h.AssemblyLinearVelocity=Vector3.zero end if hum then hum.PlatformStand=false end end) end
    
    local flyBV, flyBG, flyConn, fk = nil,nil,nil,{W=false,A=false,S=false,D=false,Sp=false,Ct=false}
    local function startFly() local h=getHRP() if not h then return end local hum=h.Parent:FindFirstChildOfClass("Humanoid") if hum then hum.PlatformStand=true end flyBV=Instance.new("BodyVelocity") flyBV.MaxForce=Vector3.new(1e6,1e6,1e6) flyBV.Velocity=Vector3.zero flyBV.Parent=h flyBG=Instance.new("BodyGyro") flyBG.MaxTorque=Vector3.new(1e6,1e6,1e6) flyBG.P=1e4 flyBG.Parent=h flyConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera local m=Vector3.zero if fk.W then m=m+cam.CFrame.LookVector end if fk.S then m=m-cam.CFrame.LookVector end if fk.A then m=m-cam.CFrame.RightVector end if fk.D then m=m+cam.CFrame.RightVector end if fk.Sp then m=m+Vector3.new(0,1,0) end if fk.Ct then m=m-Vector3.new(0,1,0) end flyBV.Velocity=m*60 flyBG.CFrame=cam.CFrame end) end
    local function stopFly() if flyConn then flyConn:Disconnect() flyConn=nil end if flyBV then flyBV:Destroy() flyBV=nil end if flyBG then flyBG:Destroy() flyBG=nil end local h=getHRP() local hum=h and h.Parent:FindFirstChildOfClass("Humanoid") if hum then hum.PlatformStand=false end end
    UIS.InputBegan:Connect(function(i,g) if g then return end if i.KeyCode==Enum.KeyCode.W then fk.W=true elseif i.KeyCode==Enum.KeyCode.A then fk.A=true elseif i.KeyCode==Enum.KeyCode.S then fk.S=true elseif i.KeyCode==Enum.KeyCode.D then fk.D=true elseif i.KeyCode==Enum.KeyCode.Space then fk.Sp=true elseif i.KeyCode==Enum.KeyCode.LeftControl then fk.Ct=true end end)
    UIS.InputEnded:Connect(function(i) if i.KeyCode==Enum.KeyCode.W then fk.W=false elseif i.KeyCode==Enum.KeyCode.A then fk.A=false elseif i.KeyCode==Enum.KeyCode.S then fk.S=false elseif i.KeyCode==Enum.KeyCode.D then fk.D=false elseif i.KeyCode==Enum.KeyCode.Space then fk.Sp=false elseif i.KeyCode==Enum.KeyCode.LeftControl then fk.Ct=false end end)

    local ncConn 
    local function noclip(on) if ncConn then ncConn:Disconnect() ncConn=nil end if on then ncConn=RunService.Stepped:Connect(function() local c=getChar() if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end) else local c=getChar() if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end end end

    local S = {antiVoid=false, antiHit=false, invis=false, infiniteDash=false, antiSkill=false, flingLoop=false, flingAll=false, loopTP=false, destroyer=false, orbitOn=false, wallCombo=false}
    local T = {target="", destTarget="", tpTarget="", orbTarget=""}

    -- 1. LOCAL PLAYER
    local lp=makeTab("Local Player",1)
    local lpC1, lpC2 = makeCols(lp)
    sec(lpC1,"Movement") 
    sld(lpC1,"Walk Speed",16,250,16,function(v) local c=getChar() local h=c and c:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=v end end)
    tog(lpC1,"Fly",false,function(on) if on then startFly() else stopFly() end end)
    sld(lpC1,"Fly Speed",20,300,60)
    tog(lpC1,"Noclip",false,noclip)
    sec(lpC2,"Dashes")
    tog(lpC2,"Infinite Dashes",false,function(on) S.infiniteDash = on end)
    
    -- 2. EXPLOITS
    local ex=makeTab("Exploits",2)
    local exC1, exC2 = makeCols(ex)
    sec(exC1,"Anti's")
    tog(exC1,"Anti Void",false,function(on) S.antiVoid = on end)
    tog(exC1,"Anti Hit",false,function(on) S.antiHit = on end)
    sec(exC1,"Skill Anti's")
    tog(exC1,"Anti Skill (Tümü)",false,function(on) S.antiSkill = on end)
    tog(exC1,"Anti Monster Garou",false)
    
    sec(exC2,"Fling")
    txt(exC2,"Fling Target","kullanıcı adı",function(v) T.target=v end)
    btn(exC2,"FLING (Tek)",function() local p=findP(T.target) if p then fling(p) end end)
    tog(exC2,"Loop Fling Target",false,function(on) S.flingLoop = on end)
    tog(exC2,"Loop Fling All",false,function(on) S.flingAll = on end)
    sec(exC2,"Wall Combo")
    tog(exC2,"Wall Combo Anywhere",false,function(on) S.wallCombo = on end)
    
    sec(exC2,"Misc")
    tog(exC2,"Invisibility",false,function(on) S.invis = on end)
    tog(exC2,"Player Destroyer",false,function(on) S.destroyer = on end)
    txt(exC2,"Destroyer Target","kullanıcı adı",function(v) T.destTarget=v end)

    -- 3. TELEPORT
    local mp=makeTab("Teleport",3)
    local mpC1, mpC2 = makeCols(mp)
    sec(mpC1,"Map Teleports")
    btn(mpC1,"Arena",function() local h=getHRP() if h then h.CFrame=CFrame.new(0,10,0) end end)
    btn(mpC1,"Baseplate",function() local h=getHRP() if h then h.CFrame=CFrame.new(0,5,0) end end)
    sec(mpC2,"Player Teleports")
    txt(mpC2,"Target Player","kullanıcı adı",function(v) T.tpTarget=v end)
    btn(mpC2,"Teleport",function() local p=findP(T.tpTarget) if p and p.Character then local h=getHRP() if h then h.CFrame=p.Character.HumanoidRootPart.CFrame end end end)
    tog(mpC2,"Loop TP (Arkasına)",false,function(on) S.loopTP = on end)

    -- 4. ORBIT
    local or=makeTab("Orbit",4)
    local orC1, orC2 = makeCols(or)
    sec(orC1,"Orbit Settings")
    txt(orC1,"Orbit Target","kullanıcı adı",function(v) T.orbTarget=v end)
    tog(orC1,"Orbit Aç/Kapa",false,function(on) S.orbitOn = on end)
    sec(orC2,"Orbit Ayar")
    local orbR = 14 local orbSpd = 4
    sld(orC2,"Range",4,50,14,function(v) orbR = v end)
    sld(orC2,"Speed",1,20,4,function(v) orbSpd = v end)

    -- 5. MISC
    local ms=makeTab("Misc",5)
    local msC1, msC2 = makeCols(ms)
    sec(msC1,"Performans")
    tog(msC1,"Anti Lag",false,function(on) if on then pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end) Lighting.GlobalShadows=false Lighting.FogEnd=1e6 for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") then v.Enabled=false elseif v:IsA("BasePart") then local n=v.Name:lower() if n:find("tree") or n:find("grass") then v.Transparency=1 end end end end end)

    -- LOOPS (Arka plan işleri)
    RunService.RenderStepped:Connect(function()
        local h=getHRP() if not h then return end
        
        if S.antiVoid and h.Position.Y < -70 and lastSafe then h.CFrame = lastSafe + Vector3.new(0,5,0) end
        
        if S.destroyer and T.destTarget ~= "" then 
            local p=findP(T.destTarget) 
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then h.CFrame=p.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,4.2) end 
        end
        
        if S.orbitOn and T.orbTarget ~= "" then 
            local p=findP(T.orbTarget) 
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
                local t=p.Character.HumanoidRootPart 
                local ang=tick()*orbSpd 
                          local pos=t.Position+Vector3.new(math.cos(ang)*orbR,3,math.sin(ang)*orbR) 
                h.CFrame=CFrame.new(pos,t.Position) 
            end 
        end
        
        if S.loopTP and T.tpTarget ~= "" then
            local p = findP(T.tpTarget)
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then h.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,2,4) end
        end
    end)
    
    -- ALT DÖNGÜLER
    task.spawn(function() while task.wait(0.5) do if S.flingLoop and T.target ~= "" then local p=findP(T.target) if p then fling(p) end end end end)
    task.spawn(function() local i=0 while task.wait(0.7) do if S.flingAll then local t={} for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then table.insert(t,p) end end if #t>0 then i=i%#t+1 fling(t[i]) end end end end)
    task.spawn(function() while task.wait(0.2) do local c=getChar() if c then for _,v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") or v:IsA("Decal") then if S.invis then v.Transparency=1 if v.Name=="HumanoidRootPart" then v.Transparency=0 end else if v.Name~="HumanoidRootPart" then v.Transparency=0 end end end end end end)
    task.spawn(function() while task.wait(0.1) do if S.infiniteDash then local c=getChar() if c then for _,v in ipairs(c:GetDescendants()) do if v:IsA("NumberValue") then local n=v.Name:lower() if n:find("dash") or n:find("cooldown") then v.Value=0 end end end end end end end)
    task.spawn(function() while task.wait(0.5) do if S.wallCombo then local c=getChar() if c then for _,v in ipairs(c:GetDescendants()) do if v:IsA("BoolValue") then local n=v.Name:lower() if n:find("wall") or n:find("combo") then v.Value=true end end end end end end end)
    
    -- Anti Hit
    local lastHit=0 local function bindAH() local c=getChar() if not c then return end local hum=c:FindFirstChildOfClass("Humanoid") if not hum then return end hum.HealthChanged:Connect(function(h) if S.antiHit and h<hum.MaxHealth and tick()-lastHit>0.6 then lastHit=tick() void() end end) end LP.CharacterAdded:Connect(function() task.wait(1) bindAH() end) bindAH()
    
    -- Anti Skill
    local antiConns={} local function setupAnti(plr) if plr==LP then return end local char=plr.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid") if not hum then return end local anim=hum:FindFirstChildOfClass("Animator") if not anim then return end for _,c in ipairs(antiConns) do if c.plr==plr then return end end local conn={} conn.plr=plr conn.c=anim.AnimationPlayed:Connect(function() if not S.antiSkill then return end void() end) table.insert(antiConns,conn) end for _,p in ipairs(Players:GetPlayers()) do setupAnti(p) end Players.PlayerAdded:Connect(function(p) task.wait(2) setupAnti(p) end) LP.CharacterAdded:Connect(function() task.wait(2) for _,p in ipairs(Players:GetPlayers()) do setupAnti(p) end end)

elseif PlaceId == 6516141723 then
    -- ==========================================
    -- DOORS SCRIPT
    -- ==========================================
    local makeTab, makeCols, sec, tog, sld, btn, txt = createGUI()
    local ms=makeTab("Main",1)
    local c1, c2 = makeCols(ms)
    local S = {deathFarm=false, autoFarm=false, esp=false, noclip=false, godmode=false}
    
    sec(c1,"Farming")
    tog(c1,"Death Farm",false,function(on) S.deathFarm = on end)
    tog(c1,"Auto Farm Knobs",false,function(on) S.autoFarm = on end)
    btn(c1,"Skip Door",function() for _,v in ipairs(workspace:GetDescendants()) do if v.Name:lower():find("door") and v:IsA("BasePart") then local h=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=v.CFrame+Vector3.new(0,0,10) end end end end)
    
    sec(c2,"Visuals & Char")
    tog(c2,"ESP Players",false,function(on) S.esp = on end)
    tog(c2,"Noclip",false,function(on) S.noclip = on end)
    tog(c2,"Speed Hack",false,function(on) local c=LP.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=on and 100 or 16 end end end)
    tog(c2,"God Mode",false,function(on) S.godmode = on end)
    
    -- LOOPS
    task.spawn(function() 
        while task.wait(1) do 
            if S.deathFarm then 
                local c=LP.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h then h.Health=0 end end 
            end 
        end 
    end)
    task.spawn(function() 
        while task.wait(0.5) do 
            if S.autoFarm then 
                for _,v in ipairs(workspace:GetDescendants()) do 
                    if v.Name:lower():find("knob") and v:IsA("BasePart") then 
                        local h=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=v.CFrame end 
                    end 
                end 
            end 
        end 
    end)
    task.spawn(function() 
        while task.wait(1) do 
            if S.esp then 
                for _,p in ipairs(Players:GetPlayers()) do 
                    if p~=LP and p.Character then 
                        local h=p.Character:FindFirstChild("HumanoidRootPart") 
                        if h and not h:FindFirstChild("ESP") then 
                            local bb=Instance.new("BillboardGui") bb.Name="ESP" bb.Size=UDim2.fromOffset(50,50) bb.AlwaysOnTop=true bb.Adornee=h bb.Parent=h 
                            local f=Instance.new("Frame") f.Size=UDim2.fromScale(1,1) f.BackgroundTransparency=1 f.BorderSizePixel=2 f.BorderColor3=Color3.fromRGB(255,0,0) f.Parent=bb 
                        end 
                    end 
                end 
            end 
        end 
    end)
    task.spawn(function() 
        while task.wait(0.1) do 
            if S.noclip then 
                local c=LP.Character if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end 
            end 
        end 
    end)
    task.spawn(function() 
        while task.wait(0.5) do 
            if S.godmode then 
                local c=LP.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth end end 
            end 
        end 
    end)
  end
