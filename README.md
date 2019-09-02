<p align="left">
    <img src="Media/logo.png", width="100">
</p>

BlueAR
=========

BlueAR application uses ARKit and CoreML technologies. With this app you can make augmented reality and image detection.

How it works?
---

<p>
    <img src="Media/icon1.png", width="30">
</p>
- When the horizontal ground is detected, the icon will turn green. After the icon becomes green, you can add the desired object to the horizontal surface by touching it.

<p>
    <img src="Media/icon4.png", width="30">
</p>
- Similarly, when the horizontal background is detected, you can add the dancing character by selecting the desired dance animation by touching the icon.

<p>
    <img src="Media/icon2.png", width="30">
</p>
- The icon will turn green when the camera detects a hand. After the icon becomes green, you can add the desired planet to your hand by tapping it.

<p>
    <img src="Media/icon3.png", width="30">
</p>
- When the vertical ground is detected, the icon will turn green. After the icon becomes green, you can add the desired wallpaper to the vertical floor by touching it.

Example use GIF
---

<p align="left">
    <img src="Media/screen_capture.gif">
</p>

The working structure of the application
---

- Object data is retrieved via Firebase DB.
- Selected objects and skins are downloaded via Firebase Storage as a Zip file.
- Downloaded objects and overlay files are displayed on the screen.
- Hand recognition is detected by the CoreML model embedded in the application.

Notes: Only "obj" model is supported. It can be changed from within the DownloadManager file.
I haven't found a plugin that works properly yet. I couldn't run [AssimpKit](https://github.com/dmsurti/AssimpKit) in my project.

Author
---

[Hakan Karakaya](https://github.com/hakankarakaya)

