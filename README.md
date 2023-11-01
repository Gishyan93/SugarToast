SugarToast
=============

SugarToast is a Swift extension that adds toast notifications. It is highly customizable, lightweight, and easy to use. Most toast notifications can be triggered with just a few lines of code.
SugarToast is available through [Swift Package Manager](https://www.swift.org/package-manager/)

Screenshots
---------
![alt tag](https://github.com/Gishyan93/SugarToast/blob/main/Assets/example-1.jpg)

Features
---------

**Core features:**
 - Top and bottom positions for toast appearance
 - Customizable toast properties: Paddings, instets, spacings, cornerRadius, backgroundColor, fonts etc...
 - Show toast with or without image or change image position: `.leadingPinnedImage`, `.trailingPinnedImage` or `.centeredImage`
 - Changing autohide duration
 - Callback to catch dismiss event
 - Enable or disable dismiss functionality with touch events

**Availability:**
 - Swift 5.4 (main branch)
 - iOS >= 13.0

## Demo Sample Application

* `SugarToast/SampleApp/SampleApp.xcodeproj` is the demo project for iOS
* Make sure you are running a supported version of Xcode.
  * Usually it is specified here a few lines above.
  * In most cases it will be the latest Xcode version.


## Usage

In order to correctly compile:

### Initializing somewhere in your ViewController
```swift
    func createSimpleToast() {
        let data = ToastViewData(image: UIImage(named: "info")!,
                                 title: "Sugar Title",
                                 subtitle: "Sugar Subtitle")
                    
        let presenter = ToastView.presenter(forAlertWithData: data)
        present(presenter, animated: true)
    }
```

### Customizing
```swift
    func createCustomizedToast() {
        let data = ToastViewData(image: UIImage(named: "info")!,
                                 title: "Sugar Title",
                                 subtitle: "Sugar Subtitle")
        
        var settings = ToastSettings()
        settings.type = .trailingPinnedImage
        settings.titleTextAlignment = .center
        settings.subtitleTextAlignment = .center
        settings.backgroundColor = .systemGreen
        settings.verticalSpacing = 30
        settings.horizontalSpacing = 15
        settings.cornerRadius = 0

        var appearance = ToastAppearance()
        appearance.position = .top
        appearance.autohideDuration = 5
        appearance.horizontalPaddings = 0
        appearance.verticalPaddings = 0
        
        let presenter = ToastView.presenter(forAlertWithData: data,
                                            settings: settings,
                                            appearance: appearance)
        present(presenter, animated: true)
    }
```

### Callback listeners
```swift
    func createToastWithCompletion() {
        let data = ToastViewData(image: UIImage(named: "info")!,
                                 title: "Sugar Title")
                    
        let presenter = ToastView.presenter(forAlertWithData: data)
        presenter.closeAction = { [weak self] in
            print("Your business flow here...")
        }
        present(presenter, animated: true)
    }
```
# License
This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.
