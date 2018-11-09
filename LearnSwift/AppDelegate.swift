//
//  AppDelegate.swift
//  LearnSwift
//
//  Created by perfay on 2018/8/21.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GDTSplashAdDelegate {

    var window: UIWindow?
    var push:Bool = false
    var url:String? = nil
    
    var launchOptions:[UIApplicationLaunchOptionsKey: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        let splash = GDTSplashAd.init(appId: "1107841133", placementId: "3040545211517599")
        splash?.delegate = self
        splash?.fetchDelay = 4
        splash?.loadAndShow(in: self.window)
        let appkey:String = UserDefaults.standard.value(forKey: "appkey") as? String ?? "5bae359cf1f556a7c70005f1"
        let url:String = UserDefaults.standard.value(forKey: "url") as? String ?? ""
        if url.hasPrefix("http") {
            let deadTime = DispatchTime.now() + .seconds(3)
            DispatchQueue.main.asyncAfter(deadline: deadTime) {
                self.pushToRootVC(url)
            }
        }
        self.registerUM(appkey: appkey)
        return true
    }
    func splashAdSuccessPresentScreen(_ splashAd: GDTSplashAd!) {
        print("广告展示成果")
    }
    func splashAdFail(toPresent splashAd: GDTSplashAd!, withError error: Error!) {
        print("广告展示失败:\(error.localizedDescription)")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let data = NSData.init(data: deviceToken)
        print("deviceToken :" + data.description.replacingOccurrences(of: " ", with: ""))
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    func  registerUM(appkey:String?) {
        guard appkey != nil else {
            return
        }
        UMConfigure .initWithAppkey(appkey, channel: "App Store")
        let entity = UMessageRegisterEntity.init()
        entity.types = Int(Double(UMessageAuthorizationOptions.badge.rawValue) + TimeInterval(UMessageAuthorizationOptions.alert.rawValue) + Double(UMessageAuthorizationOptions.sound.rawValue))
        UMessage .registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (bool, error) in
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UMessage.setAutoAlert(false)
        UMessage.setBadgeClear(true)
        UMessage.didReceiveRemoteNotification(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let appkey:String = userInfo["appkey"] as? String ?? ""
        let url:String = userInfo["url"] as? String ?? ""
        
        UMessage.setAutoAlert(false)
        UMessage.setBadgeClear(true)
        UMessage.didReceiveRemoteNotification(userInfo)
        completionHandler(.newData)
        if appkey.count > 0 {
            UserDefaults.standard.set(appkey, forKey: "appkey")
            UserDefaults.standard.synchronize()
            self.registerUM(appkey: appkey)
        }
        UserDefaults.standard.set(url, forKey: "url")
        UserDefaults.standard.synchronize()
        if url.hasPrefix("http") {
            self.pushToRootVC(url)
        }
    }
    func pushToRootVC(_ url:String) -> Void {
        if self.window!.rootViewController!.isKind(of: TestViewController.self) {
            return
        }
        let  test = TestViewController()
        test.loadUrl = url
        self.window?.rootViewController = test
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

