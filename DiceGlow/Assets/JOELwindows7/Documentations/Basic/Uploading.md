# Uploading to ChilloutVR

You can create & upload your own custom content to ChilloutVR to be used here.

To get started, you will need the [Content Creation Kit](https://abinteractive.net) & [Unity 2021](https://unity.com).

Refer to [this instruction]() on how to setup Unity & CCK.

## Preparations

- Create new Unity 2021..... project or use the existing one that is already 2021.........
- Drag & Drop the CCK `.unitypackage` into your Unity window.
- Confirm `Import`.
- You are now ready. Bring your content that you made and/or licensed into this Unity Project folder. As usual in Unity, files should be placed inside the `Assets` folder.

### Best Practice

#### Place whatever you make & edit inside your own name folder.

To make organizing & exporting easy, be sure to place whatever you made & edit in a folder that's dedicated to your stuffs.

e.g. `Assets/YourName/`.

Then you can make another folder for specific purpose, such as one for `Guns`, one for `Avatars`, etc.

With this, you can easily organize & export your file if you need it. It also helps you compact & respect your `.unitypackage` export, as you can make Unity only export that folder not including dependency (uncheck `Include Dependencies`). Additionally, it's very useful to ensure dependency author download & sales count are respected.

## Props

Uploading Props is as easy as attaching `CVR Spawnable` component to the object to be uploaded as.

## Avatars

Uploading Avatar is as easy as attaching `CVR Avatar` component to the object to be uploaded as.

## World

Uploading World is as easy as adding a new GameObject & add `CVR World` components.

> [!NOTE]
> It is recommended to assign Reference Camera & add a dedicated spawn point.
> To add a spawn point, simply add an empty GameObject, position to where you'd like a player will spawn, & add it to the Spawn list. Each position transform of the GameObject of the list will be used as the spawn position reference.

## Upload

Once you are ready, you can begin the upload with the `CCK Control Panel` window.

- See top menu, `AlphaBlend Interactive`, `Control Panel`.
- Login with your Username & your Content Creation Key. To obtain this, visit your [ABI Dashboard](https://hub.abinteractive.net), scroll down & copy the CCK Key. Paste back into the Control Panel, field `Key`. `Login`.

When successfully logged in, you should now see either the Props & Avatar list or the World upload option. You can pick which asset you'd like to upload, by clicking `Upload` below which assets. Wait for all stuffs to be packed in until you are in `Play Mode` where the upload menu appears inside the `Game` tab window.

> [!NOTE]
> You can only upload Props & Avatar at the same time, but not the World. If you added a GameObject with `CVR World` component, the Prop & Avatar upload will be disabled & you can only upload World.  
> To return the ability of uploading Props & Avatar, either disable or remove the GameObject with `CVR World`.

> [!TIPS]
> Be sure to resolve any of the extra fix offers by clicking those extra buttons before the `Upload`, such as `Fix Import Settings`.

Once the file has been packed in & ready, you will be thrown into `Play Mode` with the CCK Upload menu appears in the `Game` tab window.

### Safety Tags

> Main Article: tags

Observe & carefully select what your assets contains. This is very important for safety & accessibility, and you cannot ignore this.

### Description

Correctly Fill in your title & descriptions. Optionally, write the changelog at the third text box.

#### Selecting Thumbnail

You can either select a file (by clicking cloud up button & select picture file) or choose taking image from the scene.

If you'd like to just use whatever in your scene, notice a Camera GameObject `for_CCK...`. Adjust its position & rotation. You'll notice that on your Thumbnail preview in the menu changes as you move that Camera. This will be what appears as the thumbnail later in the asset selection in-game.

> [!TIPS]
> For the best result, you can copy your Scene view position to that CCK Camera.  
> - Align your view position looking at your Prop or Avatar. Once you are good with it, Stay there.
> - Right click the CCK Camera `for_CCK`, and select `Align with View`.
> 
> Your thumbnail will be in that position you just desired.

When you are ready with the thumbnail & decided to change the thumbnail to that, be sure to check `Change` ....

### Legal

Careful read & agree to those 2 legals. If you are agree, check them. You will need to agree to 2 legals before you can proceed.

> [!WARN]
> Ensure you have correctly checked which Safety Tag matches with your assets, especially flashings for epileptic user & NSFW for lewd assets.
> 
> If the asset you are uploading is not your own, ensure that you have the license beforehand.  
> - For Free of Charge assets, abide & agree to the terms listed in the item page. If Redistribution of the original file is not allowed, **ignore the original files**.
> - For Paid assets, abide & agree to the terms listed in the item page. Watchout for the permission for purchasers if you are allowed to do this or not. If you are uploading to public Git, **ignore the original files**!!

### Proceed

Once all has completed, your asset will be encrypted & sent to the ABI cloud.

You should now see your asset appears on your in-game `Props` or `Avatars`.

## Revision

If you make a mistake, or to improve, simply make your edits. Then reupload those again & your assets should be updated to what you edit.

## Safekeeping

> [!WARN]
> Never lose your upload GUID!!! Always keep a list of your upload GUIDs in a safe place such as uploading them to Git.  
> You can collect the GUID attached in `CVR Asset Info` component that automatically added when you add upload Components. `Copy Asset GUID` then paste it to your list notes.
> If you lost your GUID, you can retrieve it again from your [ABI Dashboard]().  
> Be sure not to remove the GUID from those `CVR Asset Info` component, or else it will be treated as new upload rather than update.

It is recommended always safekeep your Asset GUIDs. Create a new note file that will list all your asset GUIDs. You can then use these GUIDs for your world e.g., with `CVR Spawnable Marker` for Prop GUIDs, `CVR Avatar Marker` for Avatar GUIDs, & `CVR World Portal` for World GUIDs.

## More Articles