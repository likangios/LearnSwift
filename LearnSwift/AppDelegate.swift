//
//  AppDelegate.swift
//  LearnSwift
//
//  Created by perfay on 2018/8/21.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import LeanCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchOptions:[UIApplicationLaunchOptionsKey: Any]?
    /*
     // Push组件基本功能配置
     UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
     //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
     entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
     [UNUserNotificationCenter currentNotificationCenter].delegate=self;
     [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
     if (granted) {
     }else{
     }
     }];
     \*/
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
//        let setting = UIUserNotificationSettings.init(types: [UIUserNotificationType.alert,UIUserNotificationType.badge,UIUserNotificationType.sound], categories: nil)
//        application.registerUserNotificationSettings(setting)
//        application.registerForRemoteNotifications()
        LeanCloud.initialize(applicationID: "D7zAA4ICi9e9nFMh9nISuhXE-gzGzoHsz", applicationKey: "OR9jMJ5II0PkrkXOe9lpbsiX")
        self.launchOptions = launchOptions
        login()

        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let data = NSData.init(data: deviceToken)
        let token = String.init(data: deviceToken, encoding: .utf8)
        print(data.description)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    func login() -> Void {
        
        LCUser.logIn(username: "123456", password: "123456") { result in
            switch result {
            case .success(_):
                let user:LCUser? = LCUser.current
                guard user != nil else {
                    return
                }
                let appkey:LCString? = user!.value(forKeyPath: "appkey") as? LCString
                self.registerUM(appkey: appkey?.value)
                print("登录 成功")
                break
            case .failure(let error):
                print("登录 失败")
                let deadTime = DispatchTime.now() + .seconds(5)
                DispatchQueue.main.asyncAfter(deadline: deadTime) {
                    self.login()
                }
                print(error)
            }
        }
    }
    func  registerUM(appkey:String?) {
        UMConfigure .initWithAppkey(appkey, channel: "APP Store")
        let entity = UMessageRegisterEntity.init()
        entity.types = Int(Double(UMessageAuthorizationOptions.badge.rawValue) + TimeInterval(UMessageAuthorizationOptions.alert.rawValue) + Double(UMessageAuthorizationOptions.sound.rawValue))
        UMessage .registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (bool, error) in
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

