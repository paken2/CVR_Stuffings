# Poiyomi Tips & Tricks

> Main Article: [Poiyomi Shaders](https://www.poiyomi.com/)

Poiyomi is a Unity Shader collection that contains many features & customizabilities. Despite being the focus for VRChat, Poiyomi is compatible for every Unity projects this shader supports (at least 2019s).

The following are highlights of the Poiyomi features & how to use those.

## Stickers

> Main article: [Decals](https://www.poiyomi.com/color-and-normals/decals)

> [!NOTE]
> Location: `Colors & Normals`, `Decals`

Stickers / Decals allows you attach an image into the material as an overlay, kind of like installing stickers / decal onto the unit.  
You can adjust its size, position, rotation, & other things. Stickers / Decals transforms are based on your 3D model UV against your UV image plane of this material.

## Sparkle

> Main article: [Glitter / Sparkle](https://www.poiyomi.com/special-fx/glitter)

> [!NOTE]
> Location: `Special FX`, `Glitter`

You can add glitter effect on your material that gives sparkling effect to your unit. You can filter which area that allows glitter with masking, adjust their granularity, noise, and also shapes. Glitter / Sparkle can also be made to react with AudioLink.

## Video Texture

> Main Article: [Decals, Video Texture](https://www.poiyomi.com/color-and-normals/decals#video-texture)

> [!NOTE]
> Location: `Colors & Normals`, `Decals`, `Video Texture`

It is possible to make your material read a global video texture, & then showing it somewhere into the material.

- Enable `VideoTex` feature for this decal.
- (Optional) Have a mask to define the video cutout shape. You can draw yourself or find a mask, with pixel of `White` being allow & `Black` occlude.
- Adjust size & position to where you'd want the video to appear at against the UV of your 3D Model.
- Choose your `Aspect Ratio` mode for this video decal. `Shrink2Fit` shrinks the video to fit inside the square while maintaining aspect ratio, `Grow2Fit` expands so that it fills but fit into the square while maintaining aspect ratio, `Off` expands both vertical & horizontal into square and breaking the aspect ratio.
- (Recommended) Enable `Fit2Scale` to ...
- (Recommended) To prevent dark video, ensure `Emission` is set= to above `0.0`. If you unsure, set it to `1.0`. This makes this video decal self emitting.
- Enable `Use Decal Alpha`. Keep this enabled if you unsure, or that the video does not work.
- (Optional) Enable `Only show video` if you do not want to show placeholder shape when the video is not being available

Poiyomi expects `_Udon_VideoTex` global texture for the Video Texture.

> [!TIPS]
> `_Udon_VideoTex` is well known & most used Global Texture address for broadcasting video frames, even *become a standard*. All or most shaders that *plays video*, will read & display this texture.

## Animated GIF

> Main article: [Flipbook](https://www.poiyomi.com/special-fx/flipbook) 

> [!NOTE]
> Location: `Special FX`, `Flipbook`

You can put an animated GIF file into your material & it loops. This is called `Flipbook`.  
Flipbook uses Thry packed Texture Array to be played frame to frame & looping it over if used.  
To make animated GIF, you will first need to convert the GIF file to Texture array.

- Open Thry Texture Array tab window. Top menu, `Tools`, `Thry`, `Texture Array`.
- Place your GIF file into the input `???` field.
- Convert.
- Place the output `TextureArray` into this `Flipbook` feature, `Texture Array` field.
- Adjust position & size as needed.