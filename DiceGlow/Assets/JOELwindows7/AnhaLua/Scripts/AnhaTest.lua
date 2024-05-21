-- help
--[[
    https://documentation.abinteractive.net/cck/lua/hello-world/
    https://github.com/NotAKidOnSteam/NAK_CVR_Prefabs/blob/main/LuaExamples/CubeFactory/Script/CubeFactory.lua
    https://discord.com/channels/410126604237406209/1240763673346183279/1241233382487228478 to get component according to DDAkebono: `GetComponent("[full class name]")` like `gameObject.GetComponent("UnityEngine.RigidBody")`
    https://github.com/NotAKidOnSteam/NAK_CVR_Prefabs/blob/c7d1ce6c5925f2375e7b37f29c4d86be521f8b57/LuaExamples/PlayerWall/PlayerWall.lua#L34
]]--
-- JOELwindows7
UnityEngine = require("UnityEngine")
TMP = require("TextMeshPro")
TM = UnityEngine.TextMesh
-- UITextOld = UnityEngine.UI

local isSpun = false
local spounThingy
local yikYukThingy
local tmpThingy
local tmpTextItself
local tmThingy
local tmTextItself
local angle = 0
local toMoveAt = 0
local isBacking = false
local velocity = 5
local title = 'Halo Lua from JOELwindows7'
local installSay = ''
local sayWelcomeHome = ''

-- Start is called before the first frame update
function Start()
    spounThingy = BoundObjects.Spoun
    yikYukThingy = BoundObjects.IyakYikYuk
    tmpThingy = BoundObjects.Titler
    -- tmpTextItself = tmpThingy.GetComponent(TMP)
    -- tmpTextItself = tmpThingy:GetComponent("TextMeshPro.TMP")
    tmThingy = BoundObjects.TitlerOld
    -- tmTextItself = tmThingy.GetComponent(TM)
    -- tmTextItself = tmThingy:GetComponent("UnityEngine.TextMesh")
    -- tmTextItself = tmThingy.GetComponent("UnityEngine.UI.Text")
    print "Hello world!"

    installSay = title .. "\n" .. "Ping: " .. InstancesAPI.Ping .. "\n" .. sayWelcomeHome .. "\n"

    if tmTextItself == nil then
        print "nil"
    else
        print "ok"
    end

    print('haha')
    -- tmThingy:GetComponent("UnityEngine.TextMesh").text = 'HEy Hey Hey'
    -- tmThingy:GetComponent("UnityEngine.UI.Text").text = 'HEy Hey Hey'
    print(installSay)
    -- tmTextItself.text = 'HEy Hey Hey'
    print('huhu')
end

-- Update is called once per frame
function Update()
    angle = angle + UnityEngine.Time.deltaTime * velocity
    -- Codeium intervenes!
    if angle > 360 then
        angle = 0
    end
    if not isBacking then
        toMoveAt = toMoveAt + UnityEngine.Time.deltaTime * velocity
        if toMoveAt > 1 then
            isBacking = true
        end
    else
        toMoveAt = toMoveAt - UnityEngine.Time.deltaTime * velocity
        if toMoveAt < -1 then
            isBacking = false
        end
    end

    if InstancesAPI.IsHomeInstance then
        sayWelcomeHome = "Welcome Home"
    else
        sayWelcomeHome = ""
    end

    installSay = title .. "\n" .. "Ping: " .. InstancesAPI.Ping .. "\n" .. sayWelcomeHome .. "\n"
    -- installSay = 'test'
    -- tmpThingy.gameObject.TMP_Text.text = installSay
    -- tmpTextItself.text = installSay
    -- tmTextItself.text = installSay
    -- tmThingy.GetComponent(UnityEngine.TextMesh).text = installSay
    -- tmThingy.GetComponent("UnityEngine.TextMesh").text = installSay
    -- tmThingy.text = installSay

    -- spounThingy.transform.Rotate(0,angle,0)
    spounThingy.transform.localRotation = UnityEngine.Quaternion.Euler(UnityEngine.NewVector3(0,angle,0))
    yikYukThingy.transform.localPosition = UnityEngine.NewVector3(.75,toMoveAt,0)
end