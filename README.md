# BattleAxe

Welcome to BattleAxe, an easy and super extstensible Logger for iOS and MacOS.

To start using BattleAxe follow this steps:

``` swift
func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        ... scene setup ...
        
        let logDateFormatter = LogDateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ssSSS")
        LogService.register(provider: ConsoleLogProvider(dateFormatter: logDateFormatter))
        LogService.register(provider: FileLogProvider(dateFormatter: logDateFormatter,
                                                      fileWriter: LogFileWriter(filePath: "/Users/andreaslydemann/Desktop/TodoAppLog.txt")))


```
