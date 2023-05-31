# 🛎 adb-helper 🛎 
## ADB CLI toolbox focused on productivity (macOS only)

<img width="698" alt="1-home" src="https://user-images.githubusercontent.com/225409/173252916-362fdd8d-bc02-4cb6-aa7e-dd463d3db4df.png">

## Installation

```
curl -s https://raw.githubusercontent.com/st-f/adb-helper/main/installation.sh | bash
```

## About

Android development is about working in between repetitive tasks:

- Compile and install an app
- Install / reinstall an APK to investigate something
- Take screenshots and videos

And some other tasks somewhat less repetitively (but still):

- Connect to a device with SCRCPY
- Input text on the device (and often the same texts)
- List connected devices
- Restart ADB
- Turn on / off some accessibility settings

This is exactly what adb-helper does. All options are available within a couple of keystrokes.

## Usage

This allows to easily try a GitHub repo, and install it on a device in just a few steps, without the need for an IDE.

For example [androidnow](https://github.com/android/nowinandroid):

<img width="698" alt="2-demo" src="https://user-images.githubusercontent.com/225409/173252919-79c88fd2-f430-4091-a9ab-1c241b1470f8.png">

Once cloned, cd in the directory then call `adb-helper`:

<img width="698" alt="3-building" src="https://user-images.githubusercontent.com/225409/173252920-8882157d-aa63-466d-9c79-af721310d3e2.png">

Once Gradle has finished listing the tasks, you can chose the variant by entering its index. You can also:

- Refresh the variants. These are retrieved and stored in a config file the first time.
- Edit the emojis. A key/value pairs list of emojis and strings, that can be used to customize build variants, for example if you have many variants for different countries, devices types etc.

<img width="698" alt="4-variant-choice" src="https://user-images.githubusercontent.com/225409/173252922-48fab7b9-530f-4c58-be58-c0920f7726e7.png">

Gradle will then install:

<img width="698" alt="5-install" src="https://user-images.githubusercontent.com/225409/173252924-c2e43b52-d5e5-4d26-b49f-15a7e69008ba.png">

Then packages names will be retrieved from manifest files, and will provide a list of apps to launch. This is a mandatory step due to the fact that Android projects can use a wide range of variants and packages names, and these don't necessarily correlate to each other (especially with a large number of modules / variants).

This is a one time operation. Configuration files are stored in the .idea folder of the project.

<img width="698" alt="6-choose-package" src="https://user-images.githubusercontent.com/225409/173252925-f5ff12db-7d41-4989-8e41-871705799554.png">

The app is launched.

If you keep working on that project, all you need to do at that point is pressing enter. You now also have the option to start / stop the app, clear the cache and uninstall.

<img width="698" alt="7-continue" src="https://user-images.githubusercontent.com/225409/173252926-d4ee5e0d-f2ef-4d54-9671-56c40d8c8a69.png">

The second main option in APK installation, which shows a list of all APKs in the Downloads folder:

<img width="698" alt="8-install-apk" src="https://user-images.githubusercontent.com/225409/173253725-5565f5fa-004f-41c6-a2fe-1bea136c2b0a.png">

The third is pre-CI checks. A configuration file is used to store common commands, such as gradle detekt, tests etc. You can edit it by pressing "e".

<img width="698" alt="9-preci" src="https://user-images.githubusercontent.com/225409/173252928-6ee31ea2-efe0-455c-a114-309f4acdcb46.png">

You can also take screenshots, and use a custom width:

<img width="698" alt="10-screenshot" src="https://user-images.githubusercontent.com/225409/173252929-3d5ef38a-4ae3-4fe9-8d38-be61c04b0fac.png">

And record videos:

<img width="698" alt="11-record" src="https://user-images.githubusercontent.com/225409/173252930-77cca475-2431-4882-93f1-6d3ce6bd2be1.png">

There are also some utils. Text Input has a mechanism to easily enter again previously entered strings.

<img width="698" alt="12-utils" src="https://user-images.githubusercontent.com/225409/173252931-4b26b06f-3f89-4477-9dc5-926085d7d119.png">

And accessibility utils:

<img width="698" alt="13-a11y" src="https://user-images.githubusercontent.com/225409/173252932-5a7bc659-3a85-442b-8307-d0bbb94f6a93.png">
