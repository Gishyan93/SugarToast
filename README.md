# Installation

SugarToast is available through [Swift Package Manager](https://www.swift.org/package-manager/)

# Usage 

### Initializing somewhere in your ViewController
```swift
let data = ToastViewData(image: UIImage(named: "My-Sugar-image")!,
                         title: "Sugar Title",
                         subtitle: "Sugar Subtitle")
            
let presenter = ToastView.presenter(forAlertWithData: data)
present(presenter, animated: true)
```

### Customizing
```swift
let data = ToastViewData(image: UIImage(named: "My-Sugar-image")!,
                         title: "Sugar Title",
                         subtitle: "Sugar Subtitle")
                         
 var settings = ToastViewContentSettings()
 settings.type = .centeredImage
 settings.verticalInsets = 20
 settings.horizontalInsets = 20
 settings.horizontalSpacing = 20
 settings.verticalSpacing = 20
 settings.cornerRadius = 0
 settings.titleTextAlignment = .center
 settings.subtitleTextAlignment = .center
            
let presenter = ToastView.presenter(forAlertWithData: data, with: settings)
// Closure will fire right after toast dismissed
presenter.closeAction = { [weak self] in
    print("Your code here...")
}

// More customizations
presenter.autohideDuration = 5
presenter.horizontalPaddings = 0
presenter.verticalPaddings = 0

present(presenter, animated: true)
```

### Callback listeners
```swift
let data = ToastViewData(image: UIImage(named: "My-Sugar-image")!,
                        title: "Sugar Title",
                        subtitle: "Sugar Subtitle")
            
let presenter = ToastView.presenter(forAlertWithData: data)
// Closure will fire right after toast dismissed
presenter.closeAction = { [weak self] in
  print("Your code here...")
}
present(presenter, animated: true)
```
# License
SugarToast is available under the MIT license. See the LICENSE file for more information.
