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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        let setting = UIUserNotificationSettings.init(types: [UIUserNotificationType.alert,UIUserNotificationType.badge,UIUserNotificationType.sound], categories: nil)
        application.registerUserNotificationSettings(setting)
        application.registerForRemoteNotifications()
        LeanCloud.initialize(applicationID: "D7zAA4ICi9e9nFMh9nISuhXE-gzGzoHsz", applicationKey: "OR9jMJ5II0PkrkXOe9lpbsiX")
        login()
        return true
    }
    func login() -> Void {
        
        LCUser.logIn(username: "123456", password: "123456") { result in
            switch result {
            case .success(let user):
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

