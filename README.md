# BattleAxe

![Swift](https://github.com/aliaslab-1984/BattleAxe/workflows/Swift/badge.svg)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

Welcome to BattleAxe, an easy and super extstensible Logger for iOS and MacOS.

To start using BattleAxe follow this steps:

It might be useful to initialize all the LogProviders whenever the app is launched/created, in order to mantain syncronization.
A good place for that could be `application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool` or `scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)`if you use `SceneDelegate`.

Here's a small example to intilaize `LogService`:
``` swift
let logDateFormatter = LogDateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ssSSS")
LogService.register(provider: ConsoleLogProvider(dateFormatter: logDateFormatter))
LogService.register(provider: FileLogProvider(dateFormatter: logDateFormatter,
                                              fileWriter: LogFileWriter(filePath: "~/logs.log")))
// And so on for all your providers..
```

Once you're done with the configuration, you can start logging by calling:

``` swift
LogService.shared.debug("Your first log!")
```

--------

BattleAxe offers a LogRotation feature built into any FileWriter. Logs could be rotated following three main criteria:

- Log Size;
- Log file Age;
- Number of files.

You can easilly specify each of these properties when you initialize your custom `RotatorConfiguration` instance: 

```swift
RotatorConfiguration(maxSize: 10.kiloBytes, maxFiles: 2) 
// keeps on logging on a file until it excedes the 10 kiloBytes threshold.
// rotates two backup files, plus the current logging file.
```

To make things easier BattleAxe offers some cool extensions to make your code even more readable, such as from days/hours to seconds, from int to kilo/Mega/Gigabytes.

