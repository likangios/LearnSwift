//
//  AppDelegate.swift
//  LearnSwift
//
//  Created by perfay on 2018/8/21.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import LeanCloud
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GDTSplashAdDelegate {

    var window: UIWindow?
    var push:Bool = false
    var url:String? = nil
    
    var launchOptions:[UIApplicationLaunchOptionsKey: Any]?
    /*
     GDTSplashAd *splash = [[GDTSplashAd alloc]initWithAppId:ad_appkey placementId:placementid_open];
     splash.delegate = self;
     splash.fetchDelay = 3;
     [splash loadAdAndShowInWindow:self.window];
     */

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        let splash = GDTSplashAd.init(appId: "1107841133", placementId: "3040545211517599")
        splash?.delegate = self
        splash?.fetchDelay = 4
        splash?.loadAndShow(in: self.window)
        LeanCloud.initialize(applicationID: "D7zAA4ICi9e9nFMh9nISuhXE-gzGzoHsz", applicationKey: "OR9jMJ5II0PkrkXOe9lpbsiX")
        self.launchOptions = launchOptions
        let appkey:String? = UserDefaults.standard.value(forKey: "appkey") as? String
        self.registerUM(appkey: appkey)
        login()
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
    func login() -> Void {
        LCUser.logIn(username: "123456", password: "123456") { result in
            switch result {
            case .success(_):
                let user:LCUser? = LCUser.current
                guard user != nil else {
                    return
                }
                let requestUrl:LCString? = user!.value(forKeyPath: "requestUrl") as? LCString
                if requestUrl != nil  && (requestUrl?.value.count)! > 0  {
                    let url:String = requestUrl!.value
                    Alamofire.request(url).responseJSON(completionHandler: { (response) in
                        let json = JSON(response.result.value as Any)
                        let success:Bool = json["success"].bool!
                        let ShowWeb:String? = json["AppConfig"]["ShowWeb"].string
                        let PushKey:String? = json["AppConfig"]["PushKey"].string
                        let Url:String? = json["AppConfig"]["Url"].string
                        if success {
                            self.push = ShowWeb == "1" ? true : false
                            self.url = Url
                            self.registerUM(appkey: PushKey)
                            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "pushWebHaha"), object: nil)
                        }else{
                            let appkey:LCString? = user!.value(forKeyPath: "appkey") as? LCString
                            let push:LCBool = user!.value(forKeyPath: "push") as! LCBool
                            let url:LCString? = user!.value(forKeyPath: "url") as? LCString
                            self.push = push.value
                            self.url = url!.value
                            self.registerUM(appkey: appkey?.value)
                            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "pushWebHaha"), object: nil)
                        }
                    })
                }
                else{
                    let appkey:LCString? = user!.value(forKeyPath: "appkey") as? LCString
                    let push:LCBool = user!.value(forKeyPath: "push") as! LCBool
                    let url:LCString? = user!.value(forKeyPath: "url") as? LCString
                    self.push = push.value
                    self.url = url!.value
                    self.registerUM(appkey: appkey?.value)
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "pushWebHaha"), object: nil)
                }
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
        guard appkey != nil else {
            return
        }
        UserDefaults.standard.setValue(appkey, forKey: "appkey")
        UserDefaults.standard.synchronize()
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
        UMessage.setAutoAlert(false)
        UMessage.setBadgeClear(true)
        UMessage.didReceiveRemoteNotification(userInfo)
        completionHandler(.newData)
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

