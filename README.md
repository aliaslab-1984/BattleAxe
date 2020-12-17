# BattleAxe

![Swift](https://github.com/aliaslab-1984/BattleAxe/workflows/Swift/badge.svg)

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
