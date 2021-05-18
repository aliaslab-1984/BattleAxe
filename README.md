# BattleAxe

![Swift](https://github.com/aliaslab-1984/BattleAxe/workflows/Swift/badge.svg)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

Welcome to BattleAxe, an easy and super extstensible Logger for iOS and macOS.

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

BattleAxe offers a `LogRotation` feature built into any `FileWriter`. Logs could be rotated following three main criteria:

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

```swift
/// This creates the number of bytes that corresponds to 10 megabytes. (1024 * 1024 * 10 in this case)
let fileSize = 10.megaBytes
```
--------

Another great feature offered by BattleAxe is the ability to gather all the relevant information from each log entry, in fact, each log is transformed by the `LogService` into a `LogMessage`.
A `LogMessage` is a protocol that describes all the required information that a `LogEntry` should hold.

```swift
public protocol LogMessage {
    
    var description: String { get }
    
    var callingThread: String { get }
    var processId: Int32 { get }
    var payload: String { get }
    var severity: LogSeverity { get }
    var callingFilePath: String { get }
    var callingFileLine: Int { get }
    var callingStackFrame: String { get }
    var callingThreadID: UInt64 { get }
    var timestamp: Date { get }
}
```

All of these information could be useful when you write your own `LogProvider` object.

## Channels

BattleAxe let's you organize your logs per Channel! This makes log filtering easier.
By default, if you don't specify a channel to log into, BattleAxe will log on the default general channel (`BattleAxe 🪓`)
To start using channels all you have to do is:
1. Register all your LogProviders as it follows:

```swift

let provider = ConsoleLogProvider(dateFormatter: BattleAxe.LogDateFormatter.init(dateFormat: "dd-mm-yy"), configuration: .naive)
LogService.register(provider: provider)

```

2. After that you need to register all the channels that you intend to use on your project. We highly raccomend to define them in an enum, as we show below. This will make sure that you won't make typos and log on unwanted channels.
```swift
// Define a unique enum that holds all the LogChannels.
enum LogChannel: String, CaseIterable {
    
    case networking = "Networking 📻"
    case authentication = "Authentication 🗝"
    case general = "General Logger 📝"
    
}
```
3. After defining your channels you only need to register them by using the LogSevice static method, or to register each provider with a subset of your channels:
```swift
// .. Into your logger:

LogChannel.allCases.forEach {
    LogService.add($0.rawValue)
}
```
This approach subscribes *all* your registered providers to the specified channel.
An alternative is to call the `addChannel(_ channel: String)` to a single `LogProvider`, like so:

``` swift
let provider = ConsoleLogProvider(dateFormatter: BattleAxe.LogDateFormatter.init(dateFormat: "dd-mm-yy"), configuration: .naive)
let remoteProvider = MyProvider(dateFormatter: BattleAxe.LogDateFormatter.init(dateFormat: "dd-mm-yy"), configuration: .naive)

// ..

remoteProvider.addChannel(LogChannel.networking)
// from now all the logs that are shared via the `.network` channel, are going to be passed to the remoteProvider instance.

```

