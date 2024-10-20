# Lua Assorted Examples

Here are some cool example snippets of Lua Script for your reference scripting in ChilloutVR

> WARNING: At the time of creation of this document, snippets were made & collected during early phase of Lua Scripting in ChilloutVR, as early as **2024r176ex1** (Experimental). Therefore some of these snippets below may not be compatible with newer ChilloutVR you have today, or outright breaks everything. Use the following document with precaution!

## Dummy Starter

Everytime you created a new `CVRLuaScript` by Right Clicking in `Project` tab window, `Create`, `CVRLuaScript`, you'll get a new lua file pre-filled with 2 empty important functions to get you started

Sauce: [Official CVR Documentation](https://documentation.abinteractive.net/cck/lua/hello-world/)

```lua
-- Start is called before the first frame update
function Start()

end

-- Update is called once per frame
function Update()

end
```

## Hello World
Your first Lua Script!

Sauce: [Official CVR Documentation](https://documentation.abinteractive.net/cck/lua/hello-world/)

```lua
-- Start is called before the first frame update
function Start()
   print "Hello, world!" 
end

-- Update is called once per frame
function Update()

end
```

> Note, Lua does support shortcutting like the case with `print "Hello, world!"` above. it is equivalent with `print("Hello, world!")`.

## Get Players in instance
Snippets corrected for now's working today as of 2024r176ex1

Sauce: [Official CVR Lua Recipes](https://documentation.abinteractive.net/cck/lua/recipes/getting-users/)

### Player Count
```lua
-- Pull get the number of users in an instance
local playerCount = CVR.PlayersAPI.PlayerCount
-- or..
local playerCountA = #CVR.PlayersAPI.AllPlayers
-- the hashtags means lengths of the array, a.k.a. how many datas in the array.
```

For convenience, we prefer to use `CVR.PlayersAPI.PlayerCount`. Well, it's up to you anyways.

### All Players
```lua
-- Pull in all the users in an instance, including you.
local playersHere = PlayersAPI.AllPlayers
```

### Just remote players (excluding you)
```lua
-- Pull in all the users in an instance, excluding you.
local otherPlayers = PlayersAPI.RemotePlayers
```

### Just yourself
```lua
local yourself = PlayersAPI.LocalPlayer
```

## `new Vector3()` in Lua

many class instantiation methods (`new Type<>()` in C#) has been interfaced for the lua, such as for `Vector3` with `NewVector3`.

Sauce: [Official CVR Documentation](https://documentation.abinteractive.net/cck/lua/api/globals/#example)

```lua
-- Top of your script
UnityEngine = require("UnityEngine") -- Access to UnityEngine bindings
CCK = require("CVR.CCK") -- Access to CCK component bindings

-- Usage in script
local coolVector = UnityEngine.NewVector3(1, 2, 3)
```

## Viewpoint Raycaster

Sauce: [Official CVR Documentation](https://documentation.abinteractive.net/cck/lua/examples/viewpoint-raycast/)

This shows how to perform a Raycast. For the example we're using the player's Viewpoint as the source of the ray.

This script is meant to be run on an Avatar and only for the Wearer, it will self-destruct otherwise.

We're setting the Raycast to only hit the Remote Player colliders, and the Water Layer.

The Raycast is only active if you set your Toggle to `1`, you can do this on the Big Menu.

```lua
-- Import necessary UnityEngine components
UnityEngine = require "UnityEngine"
local CVR   = require "CVR"

function Start()
    -- Check if this script is running on an Avatar
    if not RunningInAvatar then 
        -- If not, lets destroy the script to prevent wasting resources
        Script.Destroy("This script is only meant to run on Avatars only!")
        return;
    end

    -- Also check if we're the one wearing the avatar, no point in spamming other people's consoles
    if not IsWornByMe then 
        -- If not, lets destroy the script to prevent wasting resources
        Script.Destroy("This script is only meant to run on for the Avatar Wearer!")
        return;
    end

    print("Starting the Viewpoint Raycaster example!")
end

-- The bit32 is exposed without importing. It's useful to calculate bit operations

-- Calculate the layer mask for water
local onlyWaterMask = bit32.lshift(1, CVR.CVRLayers.Water)

-- Calculate the layer mask for the remote players
local onlyRemotePlayerMask = bit32.lshift(1, CVR.CVRLayers.PlayerNetwork)

-- Combine both masks into a single one
local onlyWaterAndRemotePlayerMask = bit32.bor(onlyWaterMask, onlyRemotePlayerMask)

-- Define the maximum distance for the raycast
local maxDistance = 100.0

function Update()

    -- Lets only fire raycasts when the Core parameter toggle is 1
    -- You can set the toggles on the Big Menu
    if PlayerAPI.LocalPlayer.Core.Toggle ~= 1 then return end

    -- Only raycast every 200 frames (let's not create a lot of spam)
    if UnityEngine.Time.frameCount % 200 ~= 0 then return end

    -- Get the position of the local player view point, since that's where we're going to shoot the raycast from
    local origin = PlayerAPI.LocalPlayer.GetViewPointPosition()

    -- Get the local player viewpoint Rotation and convert into a forward direction
    -- We can do this by multiplying the Quaternion with the forward vector
    -- This result in a Vector3 with with the direction of where the player is looking at
    local forward = PlayerAPI.LocalPlayer.GetViewPointRotation() * UnityEngine.Vector3.forward

    -- Shoot a raycast from the playe's view point, that can hit the layers water and remotePlayers, and hits colliders with IsTrigger enabled
    local hit, hitInfo = UnityEngine.Physics.Raycast(origin, forward, maxDistance, onlyWaterAndRemotePlayerMask, UnityEngine.QueryTriggerInteraction.Collide)

    -- Other examples:

    -- Shoot a raycast from the playe's view point, that can hit ONLY the water layers, and hits colliders with IsTrigger enabled
    -- local hit, hitInfo = UnityEngine.Physics.Raycast(origin, forward, maxDistance, onlyWaterMask, UnityEngine.QueryTriggerInteraction.Collide)

    -- Shoot a raycast from the playe's view point, that can hit all layers, and ignores colliders with IsTrigger enabled
    -- local hit, hitInfo = UnityEngine.Physics.Raycast(origin, forward, maxDistance, UnityEngine.Physics.AllLayers, UnityEngine.QueryTriggerInteraction.Ignore)

    print("Shooting the Raycast...")

    -- Check if the raycast hit something
    if hit then

        print("Raycast hit an object!")

        -- Access the hit information
        local hitPoint = hitInfo.point
        local hitNormal = hitInfo.normal
        local hitDistance = hitInfo.distance

        print("Hit point: " .. hitPoint.ToString() .. " | Hit normal: " .. hitNormal.ToString() .. " | Hit distance: " .. hitDistance)

    end
end
```

### Expected Output

```log
print: Starting the Viewpoint Raycaster example!
print: Shooting the Raycast...
print: Shooting the Raycast...
print: Shooting the Raycast...
print: Raycast hit an object!
print: Hit point: (-1.61, 1.72, 5.73) | Hit normal: (-0.86, 0.00, -0.51) | Hit distance: 1,0413384437561
print: Shooting the Raycast...
```

## Listening to Events

Sauce: [Official CVR Documentation](https://documentation.abinteractive.net/cck/lua/recipes/listen-game-events/)

This script will log some of the game events. You can check all available events at [Events](https://documentation.abinteractive.net/cck/lua/api/events/)

This script can be placed on `Worlds`, `Props`, and `Avatars`. But for `Props`, and `Avatars` it will only run for the avatar wearer, and the prop spawned because of the `if` placed on each function.

The `--#region` and `--#endregion` are not needed, but some code editors might recognize them as blocks that you can collapse and expand for better organization.

```lua
function Start()
    print("Starting the Listening to Events example script")
end

--#region Instances Events

function OnInstanceConnected()
    if (RunningInProp and not IsSpawnedByMe) or (RunningInAvatar and not IsWornByMe) then return end
    print("We have Connected to an instance.")
end

function OnInstanceDisconnected()
    if (RunningInProp and not IsSpawnedByMe) or (RunningInAvatar and not IsWornByMe) then return end
    print("We have Disconnected to an instance.")
end

function OnInstanceConnectionLost()
    if (RunningInProp and not IsSpawnedByMe) or (RunningInAvatar and not IsWornByMe) then return end
    print("We have Lost Connection to an instance.")
end

function OnInstanceConnectionRecovered()
    if (RunningInProp and not IsSpawnedByMe) or (RunningInAvatar and not IsWornByMe) then return end
    print("We have Recovered Connection to an instance.")
end

--#endregion

--#region Player Events

function OnPlayerJoined(remotePlayer)
    if (RunningInProp and not IsSpawnedByMe) or (RunningInAvatar and not IsWornByMe) then return end
    print("A remote player has joined instance: " .. remotePlayer.Username)
end

function OnPlayerLeft(remotePlayer)
    if (RunningInProp and not IsSpawnedByMe) or (RunningInAvatar and not IsWornByMe) then return end
    print("A remote player has left the Instance: " .. remotePlayer.Username)
end

--#endregion

--#region Avatar Events

function OnLocalPlayerAvatarLoaded(avatar, localPlayer)
    if (RunningInProp and not IsSpawnedByMe) or (RunningInAvatar and not IsWornByMe) then return end
    print("The local player " .. localPlayer.Username .. " has Loaded INTO the avatar with the ID: " .. avatar.AvatarID)
end

function OnLocalPlayerAvatarClear(avatar, localPlayer)
    if (RunningInProp and not IsSpawnedByMe) or (RunningInAvatar and not IsWornByMe) then return end
    print("The local player " .. localPlayer.Username .. " has Cleared OUT of the avatar with the ID: " .. avatar.AvatarID)
end

function OnRemotePlayerAvatarLoaded(avatar, remotePlayer)
    if (RunningInProp and not IsSpawnedByMe) or (RunningInAvatar and not IsWornByMe) then return end
    print("The remote player " .. remotePlayer.Username .. " has Loaded INTO the avatar with the ID: " .. avatar.AvatarID)
end

function OnRemotePlayerAvatarClear(avatar, remotePlayer)
    if (RunningInProp and not IsSpawnedByMe) or (RunningInAvatar and not IsWornByMe) then return end
    print("The remote player " .. remotePlayer.Username .. " has Cleared OUT of the avatar with the ID: " .. avatar.AvatarID)
end

--#endregion
```

## Play an audio file simple

Sauce: [JOELwindows7](https://discord.com/channels/410126604237406209/1240763673346183279/1243523877536141312)

```lua
local ac
local acCompo
local sound

function Start()
  -- obtain AudioSource object
  ac = BoundObjects.Speaker
  -- then its component
  if ac then
    acCompo = ac.GetComponent('UnityEngine.AudioSource')
  else
    print('you forgor dragging the AudioSource to this Speaker bound')
  end
  -- don't forget the audio clip file
  sound = BoundObjects.SoundFile
end

function OnMouseDown()
  -- Let's say, you want to play the audio when you click on this prop / world object
  -- This built-in callback works by having a collider, on root itself.
  if acCompo then
    -- argument: the variable inserted with the file which is `sound`, the volume float from 0.0 to 1.0
    acCompo.PlayOneShot(sound,1)
  else
    print('acCompo is nil')
  end
end
```

[Full test script](https://github.com/Perkedel/CVR_Stuffings/blob/main/DiceGlow/Assets/JOELwindows7/AnhaLua/Scripts/AnhaTest.lua)

## Acquire Properties of an object
e.g., getting **UI Slider value**. Simply read the `value` of this `UnityEngine.UI.Slider` component of that Canvas GameObject

Sauce: [Lolatron & Kafeijao](https://discord.com/channels/410126604237406209/1240763673346183279/1242874106798538792)

```lua
UnityEngine = require "UnityEngine"
UnityEngineUI = require "UnityEngine.UI"
-- Start is called before the first frame update
function Start()
    --Slider from the bound objects
    local sliderGameObject = BoundObjects.Slider
    --Get the slider component from the bound object
    Slider = sliderGameObject.GetComponent("UnityEngine.UI.Slider")
    --Print it as a test
    print(tostring(Slider.value))
    --Setup for not spamming the slider value 
    SliderPrev = 0

end

-- Update is called once per frame
function Update()
    --Slider value is put into varible SliderValue as to not call .value again
    SliderValue = Slider.value
    --check if the slider value changed
    if SliderValue ~= SliderPrev then
    --test print
    print("Slider 1 = " .. tostring(SliderValue))
    --Makes it so when the loop comes back arround if nothing happenes it doesnt print again.
    SliderPrev = SliderValue
    end
```

## Change Text (Legacy UI Text)

Sauce: [JOELwindows7](https://discord.com/channels/410126604237406209/1240763673346183279/1242857103270482014), [EmmyHeart](https://discord.com/channels/410126604237406209/1240763673346183279/1241009800045789224)

(JOELwindows7)
```lua
local textUI
local textUIComponent

function start()
  -- Obtain from a bound object
  textUI = BoundObjects.TextUIObject
  -- Obtain its component
  if not textUI then
    print('You forgot to bind TextUI into the BoundObjects!')
  else
    textUIComponent = textUI.GetComponent('UnityEngine.UI.Text')
  end
  
  -- Start interacting
  if textUIComponent then
    textUIComponent.text = 'Hello world iyeay bwah!'
  else
    print('The Text component is missing!')
  end
end
```

(EmmyHeart (**Corrected**))  
Please drag & drop the Legacy UI Text itself to the bound again. Our testing works by **drag & droping the object itself** onto the `TextTest` titled bound, **not** the component.  
You can even drag itself as the bound, if itself has that `UnityEngine.UI.Text` (*Text* in inspector) component next to this our `CVRLuaClientBehaviour`
```lua
-- Start is called before the first frame update
local textObj
local textObjCompo -- JOELwindows7: new!
local i = 2

UnityEngineUI = require("UnityEngine.UI")
function Start()
    textObj = BoundObjects.TextTest

    -- JOELwindows7: also, since now we're drag & dropping the object itself,
    if textObj then
        textObjCompo = textObj.GetComponent('UnityEngine.UI.Text') -- And now get the component.
    else
        print('You forgot to drag & drop the target Legacy Text UI')
    end
end

-- Update is called once per frame
function Update()
    i = i * 2
    -- textObj.text = i -- STRIKE
    -- JOELwindows7: Ensure to have safety before accessing!
    if textObjCompo then
        textObjCompo.text = i -- NEW!
    else
        -- the component failed to acquire!
    end
end
```

[Full test script](https://github.com/Perkedel/CVR_Stuffings/blob/main/DiceGlow/Assets/JOELwindows7/AnhaLua/Scripts/AnhaTest.lua)

## Change Text (TextMesh)

Sauce: [NotAKidOnSteam's PlayerWall edit TextMesh](https://github.com/NotAKidOnSteam/NAK_CVR_Prefabs/blob/c7d1ce6c5925f2375e7b37f29c4d86be521f8b57/LuaExamples/PlayerWall/PlayerWall.lua#L103). [JOELwindows7's Instance Info](https://github.com/Perkedel/CVR_Stuffings/blob/main/DiceGlow/Assets/JOELwindows7/AnhaLua/Scripts/HardText.lua)

It is same as above with legacy text UI, only this time, the component class you'll drag & drop to is is `UnityEngine.TextMesh`. Let's title this bound `TextMeshObject`.
```lua
local textMesh
local textMeshComponent

function start()
  -- Obtain from a bound object
  textMesh = BoundObjects.TextMeshObject
  -- Obtain its component
  if not textMesh then
    print('You forgot to bind legacy TextMesh into the BoundObjects!')
  else
    textMeshComponent = textMesh.GetComponent('UnityEngine.TextMesh')
  end
  
  -- Start interacting
  if textMeshComponent then
    textMeshComponent.text = 'Hello world iyeay bwah!'
  else
    print('The Text component is missing!')
  end
end
```

> Note, currently as of 2024r176ex1, the `UnityEngine.TextMesh` component is **NOT whitelisted** for props, only for world object. Therefore you will get error if you attempted to access your legacy TextMesh, in the prop, since it is automatically removed upon spawning. 

## Change Text (TextMeshPro)

> WERROR BROKEN! PLS FIX

Sauce: [Forum thread started by Ch33ri0s](https://forum.unity.com/threads/access-textmeshpro-text-through-script.527992/), [Unity's TMPro Package docs](https://docs.unity3d.com/Packages/com.unity.textmeshpro@1.3/api/TMPro.TextMeshPro.html), [Forum thread started by Guich](https://forum.unity.com/threads/from-unity-ui-to-textmeshpro.463619/)

```lua
local textMeshPro
local textMeshProComponent

function start()
  -- Obtain from a bound object
  textMeshPro = BoundObjects.TextMeshProObject
  -- Obtain its component
  if not textMeshPro then
    print('You forgot to bind TextMeshPro into the BoundObjects!')
  else
    textMeshProComponent = textMeshPro.GetComponent('TMPro.TMP_Text')
  end
  
  -- Start interacting
  if textMeshProComponent then
    textMeshProComponent.text = 'Hello world iyeay bwah!'
  else
    print('The Text component is missing!')
  end
end
```

> Tips: According to Stephan_B, the `TMPro.TMP_Text` is the base for 3D Object version (`TMPro.TextMeshPro`) & the Unity GUI version (`TMPro.TextMeshProUGUI`). Therefore you can simply ask just their abstract / interface `TMP_Text` to conveniently acquire the TextMeshPro component for both types.

## Instantiate Prefab
Drag & Drop your prefab file into the BoundObjects list. Let's title this `ItemPlacementPrefab`.

Sauce: [NotAKidOnSteam, SketchFoxsky](https://discord.com/channels/410126604237406209/1240763673346183279/1242250968813535247), [Simple ]

```lua
UnityEngine = require("UnityEngine")

local myNewObject = UnityEngine.GameObject.Instantiate(BoundObjects.ItemPlacementPrefab)
```

([SketchFoxsky](https://discord.com/channels/410126604237406209/1240763673346183279/1242242417399431238))
```lua
-- Define the Inventory Prefab
local ItemPlacementPrefab = UnityEngine.GameObject.Instantiate(prefab)

-- Get the LocalPlayer's AvatarID 
-- this will need a function to check if the player changed avatars to redo the check.
LocalAvatarID = PlayerAPI.LocalPlayer.Avatar.AvatarID

-- Get the _PlayerLocal gameobject
PlayerObject = GameObject.FindGameObjectWithTag("Player")
```

([NotAKidOnSteam PlayerWall snippet](https://discord.com/channels/410126604237406209/1240763673346183279/1242250968813535247))
```lua
UnityEngine = require("UnityEngine")

local myNewObject = UnityEngine.GameObject.Instantiate(BoundObjects.ItemPlacementPrefab)
```
[Full Script](https://github.com/NotAKidOnSteam/NAK_CVR_Prefabs/blob/c7d1ce6c5925f2375e7b37f29c4d86be521f8b57/LuaExamples/PlayerWall/PlayerWall.lua#L34)

> Note, [you cannot instantiate from a prop](https://discord.com/channels/410126604237406209/1240763673346183279/1242245348320215080).

## CoolObject

Sauce: [SDraw](https://discord.com/channels/410126604237406209/1240763673346183279/1242106194525425805)

```lua
function thatStupidFunction(...)
    print(...)
    return "fish"
end

CoolObject_mt = {}
CoolObject_mt.__call = function(t,...)
    return thatStupidFunction(...)
end
CoolObject_mt.__index = function(t,k) end
CoolObject_mt.__newindex = function(t,k,v) end
CoolObject_mt.__metatable = false
CoolObject = setmetatable({},CoolObject_mt)
CoolObject_mt = nil

print("You got:",CoolObject(5,6,7))
```

## Whitelist system
Give special action if the player that runs the script is included in the *whitelist*.

Sauce: [Shin](https://discord.com/channels/410126604237406209/1240763673346183279/1241155392944341063)

```lua
-- Local Whitelisted UserIDs
local WL = {
    "aeae3ecf-9826-4e03-830f-96e8240c19e3", --Shin
    "32bc279d-15f1-155e-5fa0-cbe1cd686500", -- Okami
    }
    Whitelisted = false

function Start()
    for _, _wl in ipairs(WL) do
        if(_wl == PlayerAPI.LocalPlayer.UserID) then
            Whitelisted = true
            break
        end
    end
        if(Whitelisted == true) then
                print("You are whitelisted.")
                end
            end
```

> simple whitelist if you wanna use it for any world/prop/avatar
> just add the things u need after `if(Whitelisted == true) then`

<!-- > Pro-tips: To avoid controvercy, it is best to follow the [`Word on security`](https://documentation.abinteractive.net/cck/lua/security/) advise, in which to encrypt the `UserID`s & insert them as encrypted. Then query by comparing its hashing. Additionally, it is recommended to also obfuscate the variable names. -->

## Launch player upward when doing `Thumbs Up` gesture

Sauce: [Official CVR documentation](https://documentation.abinteractive.net/cck/lua/api/player-api/#example-1), [Page](https://documentation.abinteractive.net/cck/lua/examples/player-thumbs-up-launch/)

```lua
UnityEngine = require("UnityEngine")

-- Function to check if both hands of a player are doing a thumbs up gesture
local function isPlayerDoubleThumbsUp(player)
    return player.Core.GestureLeftIdx == 2 and player.Core.GestureRightIdx == 2
end

-- Update is called once per frame
function Update()
    local localPlayer = PlayerAPI.LocalPlayer -- Get the local player

    if localPlayer and isPlayerDoubleThumbsUp(localPlayer) then
        local upwardForce = UnityEngine.NewVector3(0, 1000, 0) -- Create an upward force vector
        localPlayer:AddForce(upwardForce, UnityEngine.ForceMode.Impulse)
        print("Dual thumbs up detected! Launching local player upward.")
    end
end
```

## Teleport player when fully immmersed in water a.k.a. `Fluid Volume`

Sauce: [Official CVR Documentation](https://documentation.abinteractive.net/cck/lua/api/player-api/#example-2), [Page](https://documentation.abinteractive.net/cck/lua/examples/player-teleport-away-from-water/)

```lua
UnityEngine = require("UnityEngine")

local function isPlayerFullyImmersed(player)
    return player.ImmersionDepth == 1
end

-- Update is called once per frame
function Update()
    local localPlayer = PlayerAPI.LocalPlayer -- Get the local player

    if localPlayer and isPlayerFullyImmersed(localPlayer) then
        local targetPosition = UnityEngine.NewVector3(0, 10, 0) -- Teleport to position (0, 10, 0)
        localPlayer:TeleportPlayerTo(targetPosition, false, true, false)
        print("Player fully immersed in water. Teleporting to (0, 10, 0).")
    end
end
```

## Disable certain GameObject if current instance is Home instance

Sauce: [Official CVR Documentation](https://documentation.abinteractive.net/cck/lua/api/instances-api/#examples), [Page](https://documentation.abinteractive.net/cck/lua/examples/instances-disable-go-in-home/)

```lua
-- Start is called before the first frame update
function Start()
    -- Get the bound GameObject
    local targetGameObject = BoundObjects.TargetGameObject
    if not targetGameObject then
        print("Error! Target GameObject not bound.")
        return
    end

    -- Check if the current instance is the home instance
    local isHomeInstance = InstancesAPI.IsHomeInstance

    if isHomeInstance then
        targetGameObject:SetActive(false)
        print("The current instance is the home instance. Disabling the target GameObject.")
    else
        print("The current instance is not the home instance. The target GameObject remains active.")
    end
end
```

## Funny Cube

Featured in one of the ABI's internal meeting for Lua Scriptin

Sauce: [Offical CVR Lua Examples](https://documentation.abinteractive.net/cck/lua/examples/funny-cube/)

```lua
-- From scripting team meeting notes:
--   First use case: Cubespin with random start position, random direction, resets after 10s.
UnityEngine = require "UnityEngine"
CCKComponents = require "ABI.CCK"

-- LuaLS/LuaCATS annotations start with three dashes (---)

--- @type UnityEngine.Time
Time = UnityEngine.Time

--- @type UnityEngine.Random
UnityRandom = UnityEngine.Random

ORIGINAL_POSITION = UnityEngine.NewVector3(0, 0, 0)
ROTATION_AXIS = nil

nextBehaviourChange = 0.0

function Start()
    -- Seed random noise.
    math.randomseed(math.floor(Time.time))

    -- Print "Hello world!" to Debug console.
    print("Hello world!")

    -- Record original position.
    ORIGINAL_POSITION = UnityEngine.NewVector3(gameObject.transform.position.x, gameObject.transform.position.y,
        gameObject.transform.position.z)
end

function Update()
    if Time.realtimeSinceStartup > nextBehaviourChange then
        i = math.random(1, 6)
        if i == 1 then
            ROTATION_AXIS = UnityEngine.NewVector3(1, 0, 0)
        elseif i == 2 then
            ROTATION_AXIS = UnityEngine.NewVector3(0, 1, 0)
        elseif i == 3 then
            ROTATION_AXIS = UnityEngine.NewVector3(0, 0, 1)
        elseif i == 4 then
            ROTATION_AXIS = UnityEngine.NewVector3(-1, 0, 0)
        elseif i == 5 then
            ROTATION_AXIS = UnityEngine.NewVector3(0, -1, 0)
        elseif i == 6 then
            ROTATION_AXIS = UnityEngine.NewVector3(0, 0, -1)
        end

        gameObject.transform.position = ORIGINAL_POSITION + UnityRandom.insideUnitSphere
        nextBehaviourChange = Time.realtimeSinceStartup + 10.0
    end

    if ROTATION_AXIS ~= nil then
        gameObject.transform.Rotate(ROTATION_AXIS)
    end

    --- @type CVR.CCK.CVRSpawnable
    spawnable = gameObject.GetComponentInParent("ABI.CCK.Components.CVRSpawnable")
    if spawnable ~= nil then
        spawnable.ForceUpdate()
    end
end
```

## Detect GameObject that collided its trigger

Sauce: [NotAKidOnSteam (Tezmal asked)](https://discord.com/channels/410126604237406209/1240763673346183279/1243927957840334980), [again](https://discord.com/channels/410126604237406209/1240763673346183279/1243934357299662951)

> NAK: on mobile so might not be formatted right but:

```lua
UnityEngine = require(“UnityEngine”)
CCK = require(“CVR.CCK”)

function OnTriggerEnter(collision)
    local collidedObject = collision.gameObject
    local cvrPointer = collidedObject:GetComponent(“ABI.CCK.Components.CVRPointer”)
    
    if cvrPointer then
        if cvrPointer.type == "cooltype" then
            print("Type matched!")
        else
            print("Type did not match. Found type: " .. cvrPointer.type)
        end
    else
        print("CVRPointer component not found on the collided object.")
    end
end
```

> ...
> NAK: is it the same error or something else?
> this script of mine using OnCollisionEnter was able to get gameObject fine, but i did not test getting components

```lua
UnityEngine = require("UnityEngine")

local audioSource = nil
local collisionSounds = {}
local minCollisionForce = 0.5
local minCollisionInterval = 0.5
local usePitchVariance = false
local pitchVariance = {0.8, 1.2}
local collisionMask = nil

local lastCollisionTime = 0

function Start()
    audioSource = BoundObjects.SFX_Source

    collisionSounds = {
        BoundObjects.SFX_Hit_0,
        BoundObjects.SFX_Hit_1,
        BoundObjects.SFX_Hit_2,
        BoundObjects.SFX_Hit_3,
        BoundObjects.SFX_HitSoft_0,
        BoundObjects.SFX_HitSoft_1,
        BoundObjects.SFX_HitSoft_2,
        BoundObjects.SFX_HitSoft_3
    }

    collisionMask = bit32.bnot(bit32.bor(bit32.lshift(1, 15), bit32.lshift(1, 8)))
end

function Update()
    if lastCollisionTime > 0 and UnityEngine.Time.time - lastCollisionTime >= minCollisionInterval then
        lastCollisionTime = 0
    end
end

function OnCollisionEnter(collision)
    if lastCollisionTime == 0 then
        local layerShifted = bit32.lshift(1, collision.gameObject.layer)
        if (bit32.band(layerShifted, collisionMask) ~= 0) and (collision.relativeVelocity.magnitude > minCollisionForce) then
            PlayRandomCollisionSound()
            lastCollisionTime = UnityEngine.Time.time
        end
    end
end

function PlayRandomCollisionSound()
    if audioSource == nil or #collisionSounds <= 0 then return end

    if usePitchVariance then
        audioSource.pitch = UnityEngine.Random.Range(pitchVariance[1], pitchVariance[2])
    end

    local index = UnityEngine.Random.Range(1, #collisionSounds)
    audioSource:PlayOneShot(collisionSounds[index])
end
```

## Get last interacted by (untested)

Sauce: [LensError](https://discord.com/channels/410126604237406209/1240763673346183279/1244469617867489300)

> LensError: For a world. Currently i have this but ofc the text either not update for others or it updates for all to have their name on it, depending if its local on GlobalNetworked. Atleast that what i assume.

```lua
UnityEngine = require("UnityEngine")
UI = require("UnityEngine.UI")

local lastInteractedBy = nil

function SetLastInteractedBy()
    lastInteractedBy = PlayerAPI.LocalPlayer.Username
    UpdateUIText()
end

function UpdateUIText()
    local uiText = BoundObjects.LastInteractedText

    if not uiText then
        print("Error: LastInteractedText not bound in ChilloutVR inspector.")
        return
    end

    local textComponent = uiText:GetComponent("UnityEngine.UI.Text")

    if not textComponent then
        print("Error: Text component not found on LastInteractedText.")
        return
    end

    if lastInteractedBy then
        textComponent.text = "Last interacted by: " .. lastInteractedBy
    else
        textComponent.text = "No interactions yet"
    end
end

Start = UpdateUIText
```

> Note: It appears you can instead set variable `Start` which is by default `function Start()` into another function (`UpdateUIText()`). Huh??

## Synced Value using Animator

Sauce: [JOELwindows7](https://discord.com/channels/410126604237406209/1240763673346183279/1244876798165254176)

Tutorial How to sync some variable: using animator. e.g., sync an integer
- Prepare a `UnityEngine.Animator` component of this prop. Create its animator controller, & put it inside the `UnityEngine.Animator`!
- In this animator controller, add Parameter! e.g., `randIntTest` type `Integer`. Put this parameter into Prop Sync Values!
- Make doing something that changes this Parameter value. e.g., when I clicked this (`OnInteractDown` Interactible), it sets random integer for certain range to this Paramter (`SetAnimatorIntRandom`).

Now, onto the code how to read it. There is method `GetInteger(v)` in this `UnityEngine.Animator` class instance.
```lua
-- You will need to assign this prop itself as bound object! e.g., this bound is titled `OwnSelf`. oh & also, Animator component! & stuffs
local ownSelf
local animCompo
local randomIntSay = '999999999999' -- we'll talk about this later.
-- on `function Start()`, capture it!
ownSelf = BoundObjects.OwnSelf
-- still on `Start()`, you can now do anything! In this case, get its Animator component
if ownSelf then
    print('obtain self')
    animCompo = ownSelf.GetComponent("UnityEngine.Animator")
else
    print('forgor assign this self')
end

-- Now, onto the `function Update()`. Because we already created the code on `CVRInteractible`, no need to do anymore things. Just read its value!
if animCompo then
    randomIntSay = tostring(animCompo.GetInteger('randIntTest'))
end
-- Notice there is `tostring(v)` meta methods! If you'd like to insert Number into a string variable, you must first convert it!
-- Now you can put this `randomIntSay` to whatever you want. e.g., still in `Update()`, I can insert it to
local installSay = 'bla blabla random int: ' .. randomIntSay
-- cool and good
```

with that, everyone else should see the value same. hopefully. Oh, also, maybe you can also use this variable to say.. select a cell in Array? yess! everyone will view the same selection!
[Full code](https://github.com/Perkedel/CVR_Stuffings/blob/main/DiceGlow/Assets/JOELwindows7/AnhaLua/Scripts/AnhaTest.lua)

The method also has been used on Shin's MoonClicker (Cookie Clicker clone CVR)

> Fearless7: interesting, imma mess with this tomorrow. If i have issues, imma bug you <:CVRchanHehe:713475383499948145>

oh, thancc LensError too, for that figure out. yess.

## Get Sync values from `CVRSpawnable` instead!

Sauce: [Shin](https://discord.com/channels/410126604237406209/1240763673346183279/1245066412595347610)

> Shin: I used to use this (`UnityEngine.Animator`) but it was not very accurate, i use spawnable value now (ones from `ABI.CCK.Components.Spanwable`)

```lua
spawnable = gameObject.GetComponentInParent("ABI.CCK.Components.CVRSpawnable")
            if spawnable ~= nil then
                if localCurrency <= Currency then
                    spawnable.SetValue(indexVal, Currency)
                end
```

## Friend Detection

Sauce: [NotAKidOnSteam](https://discord.com/channels/410126604237406209/1240763673346183279/1254075162974883987), [SDraw](https://discord.com/channels/410126604237406209/1240763673346183279/1253229299478040596), [Zeia Nala](https://discord.com/channels/410126604237406209/1240763673346183279/1254056420408561708), [Hans](https://discord.com/channels/410126604237406209/1240763673346183279/1253187284925415455)

> Zeia Nala: so, im messing with scripting finally.  
> yay
> is there a way to detect if a friend is in the lobby with you, and depending on who it is, it can set a specific profile, or parameter on my avatar?

```lua
function Start()
local isFriend = PlayerAPI:IsFriendsWith(Avatar.Wearer.UserID) or IsWornByMe
Avatar:SetParameter(“#IsFriend”, isFriend)
end
```

> NAK: something like that  
> (am on mobile, may have messed something up)

Explain: If you saw this avatar where the wearer is your friend, their `#isFriend` shows up `true` to you, only at your screen (& every other friends screen. `#` prefixed parameter name means local in Animator).

### Other Friend Detection

> Hans: query. how would one go about, if at all, making a game object on your avatar 'turn off' if the viewer is not your friend? I know there's some bits and bobs relating to avatar wearer and friend status with regards to that but I'm a dumb dumb at times.  
> ...  
> ...  
> SDraw: should work, give it a try

```lua
function Start()
  if(Script.RunningInAvatar and not Script.IsWornByMe and not PlayerAPI.IsFriendsWith(AvatarAPI.Wearer.UserID)) then
    BoundObjects.funnyObj:SetActive(false) -- or do something else, idk :3
  end
end
```

Explain: similar as above but this one disables target / Bound Object inside their Avatar if the wearer **is not your friend**.

## Dummy Extended

Want some overbloated dummy starter script? okay, here we go..

```lua
--[[
    Description

    Author
]]--
print('HALO LUA POWERED OBJECT')

System = require('System')
UnityEngine = require('UnityEngine')
AI = require('UnityEngine.AI')
UI = require('UnityEngine.UI')
CVR = require('CVR')
Network = require('CVR.Network')
CCK = require('ABI.CCK')
TMP = require('TextMeshPro')
RCC = require('RCC')

-- Awake is called when this script is being loaded
function Awake()

end

-- Start is called before the first frame update
function Start()

end

-- Update is called once per frame
function Update()

end

-- Same as Update() but at fixed rate, basically physics calculation frame
function FixedUpdate()

end

-- LateUpdate is called just after the Update()
function LateUpdate()

end

-- OnEnabled is called when this object becomes active / enabled
function OnEnabled()

end

-- OnDisabled is called when this object becomes deactivated / disabled
function OnDisabled()

end

-- OnDestroy is called when this object (mainly this script) is being destroyed / removed from scene
function OnDestroy()

end

--- Collision

-- When a collider start colliding
function OnCollisionEnter(collision)

end

-- When a collider stayed colliding
function OnCollisionStay(collision)

end

-- When a collider stopped colliding
function OnCollisionExit(collision)

end

--- Collision 2D

-- When a collider start colliding with another GameObject
function OnCollisionEnter2D(collision)

end

-- When a collider stayed colliding with another GameObject
function OnCollisionStay2D(collision)

end

-- When a collider stopped colliding with another GameObject
function OnCollisionExit2D(collision)

end

--- Trigger (Collider that isTrigger is checked)

-- When a trigger start colliding with another GameObject
function OnTriggerEnter(collision)

end

-- When a trigger stayed colliding with another GameObject
function OnTriggerStay(collision)

end

-- When a trigger stopped colliding with another GameObject
function OnTriggerExit(collision)

end

--- Trigger 2D


-- When a trigger start colliding with another GameObject
function OnTriggerEnter2D(collision)

end

-- When a trigger stayed colliding with another GameObject
function OnTriggerStay2D(collision)

end

-- When a trigger stopped colliding with another GameObject
function OnTriggerExit2D(collision)

end

--- Mouse

-- When Player has clicked its collider
function OnMouseDown()

end

-- When Player Click & hold its collider
function OnMouseDrag()

end

-- When Player's aimming dot / mouse enters its collider
function OnMouseEnter()

end

-- When Player's aiming dot / mouse exits its collider
function OnMouseExit()

end

-- When Player released the mouse click
function OnMouseUp()

end

-- When Player released the mouse click, while aiming dot / mouse stayed on this same collider it being clicked to
function OnMouseUpAsButton()

end

--- Application

-- Called before application quits
function OnApplicationQuit()

end

-- Called when the application pauses or resumes on losing or regaining focus. `pause = true` if application paused
function OnApplicationPause(pause)

end

-- Called when the player gets or loses focus. `focus = true` if focus has regained
function OnApplicationFocus(focus)

end

--- Animator

-- Called on an `Animator` move.
function OnAnimatorMove()

end

-- Called for setting up animation IK (inverse kinematics).
function OnAnimatorIK(layerIndex)

end

--- Particle

-- Called when a particle hits a Collider.
function OnParticleCollision(other)

end

-- Called when all particles in the system have died, and no new particles will be born.
function OnParticleSystemStopped()

end

-- Called when any particles in a Particle System meet the conditions in the trigger module.
function OnParticleTrigger()

end

-- Called when a Particle System's built-in update job has been scheduled.
function OnParticleUpdateJobScheduled()

end

--- Transform

-- Called when a direct or indirect parent of the transform changes.
function OnTransformParentChanged()

end

-- Called when the list of children of the transform changes.
function OnTransformChildrenChanged()

end

-- Called before the transform's parent changes.
function OnBeforeTransformParentChanged()	

end

--- Rendering

-- Called when the renderer becomes visible by any camera.
function OnBecameVisible()

end

-- Called when the renderer is no longer visible by any camera.
function OnBecameInvisible()

end

-- Called for each camera if the object is visible and not a UI element.
function OnWillRenderObject()

end

-- Called after the camera has rendered the scene.
function OnRenderObject()

end

-- Called before a camera culls the scene.
function OnPreCull()

end

-- Called before a camera renders the scene.
function OnPreRender()

end

-- Called after a camera has finished rendering the scene.
function OnPostRender()

end

-- Called after a camera has finished rendering, allows modifying the Camera's final image.
function OnRenderImage(source, destination)

end

--- Canvas UI

-- Called when the CanvasGroup changes.
function OnCanvasGroupChanged()

end

-- Called when the RectTransform is removed.
function OnRectTransformRemoved()

end

-- Called when the dimensions of the RectTransform change.
function OnRectTransformDimensionsChange()

end

--- Joint

-- Called when a joint attached to the same game object breaks.
function OnJointBreak(breakForce)

end

-- Called when a `Joint2D` attached to the same game object breaks.
function OnJointBreak2D(joint)

end

----- WHEW!! that was alot of them! -----
```

> Note, `UnityEngine.Time.fixedDeltaTime` in ChilloutVR is set based on target refresh rate, clamped between 30Hz to 144Hz. 
<!-- > `OnTriggerStay` both 3D & 2D version runs every physics frame during both collision staying (Pls confirm) -->
<!-- > `OnColliderStay` both 3D & 2D version runs every frame during both collision staying (Pls confirm) -->

pls confirm `pause` & `focus`!

## MOAR!!!

More Lua Examples
- [Official CVR Documentation about Lua](https://documentation.abinteractive.net/cck/lua/)
- [NotAKidOnSteam's](https://github.com/NotAKidOnSteam/NAK_CVR_Prefabs/tree/main/LuaExamples)
- [Shin's](https://github.com/DjShinter/CVRLuaScripts)
- [LensError's](https://github.com/LensError/CVRLuaTesting)