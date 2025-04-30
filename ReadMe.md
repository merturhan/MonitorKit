# 📡 MonitorKit

**MonitorKit** is a lightweight Swift package that captures network requests made via `URLSession`, logs detailed information including URLs, request/response bodies, and status codes, and displays them in a user-friendly UI. The interface can be activated simply by **shaking the device**.

---

## 🚀 Features

- Intercepts all `URLSession` network requests
- Logs request & response bodies, status codes, and endpoints
- Provides a built-in UI to inspect captured network traffic
- **Shake gesture** to activate the UI
- Seamless integration via a custom `URLProtocol`

---

## 📦 Installation

### Swift Package Manager (SPM)

In **Xcode**:

1. Go to `File > Add Packages…`
2. Enter the repository URL: https://github.com/merturhan/MonitorKit

---

## 🛠️ Usage

### 1. Configure `URLSession` with MonitorKit

To start capturing network requests, you need to inject `MonitorKitURLProtocol` into your `URLSessionConfiguration`. Use the provided configurator like this:

```swift
import MonitorKit

let configuration = MonitorKitConfigurator.makeConfiguration(from: .default)
let session = URLSession(configuration: configuration)
 ```
 
### 2. Setup in the `AppDelegate`

In your `AppDelegate`, you need to set up a `MonitorKitWindow` to display the UI:

```swift
import UIKit
import MonitorKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Create a MonitorKit window for network traffic inspection
        let window = MonitorKitWindow(frame: UIScreen.main.bounds)
        window.rootViewController = YourInitialViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}
 ```

## Requirements
- Xcode 13.0+

| Platform | Minimum target |
|----------|----------------|
| iOS      | 12.0+          |
