//
//  AppDelegate.swift
//  Reached
//
//  Created by Laikh Tewari on 10/16/15.
//  Copyright © 2015 Laikh Tewari. All rights reserved.
//

import UIKit
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = NSUserDefaults.standardUserDefaults()
    let mixpanel = Mixpanel.sharedInstanceWithToken("e6bbb41ffc936f18357b7bb308f6f9aa")

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        mixpanel.track("Application Launched", properties: ["Name": UIDevice.currentDevice().name])
        
//        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
//        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
          UIApplication.sharedApplication().registerForRemoteNotifications()
        
//        if let launchOptions = launchOptions as? [String : AnyObject] {
//            if let notificationDictionary = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject] {
//                self.application(application, didReceiveRemoteNotification: notificationDictionary)
//            }
//        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        let installation = PFInstallation.currentInstallation()
//        installation["device"] = installation.deviceType
//        installation.setDeviceTokenFromData(deviceToken)
//        defaults.setObject(deviceToken, forKey: "deviceToken")
//        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        PFPush.handlePush(userInfo)
        print("\n\n\n\nTREY SUCKS\n\n\n\n")
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
//        let pushQuery = PFInstallation.query()!
//        let installationId = PFInstallation.currentInstallation().installationId
//        pushQuery.whereKey("installationId", equalTo: installationId)
//        let push = PFPush()
//        let data = ["alert" : "Reached cannot send messages once the app is completely closed. Ensure that you have reached your destination before completely closing the app"]
//        push.setQuery(pushQuery)
//        push.setData(data)
//        push.sendPushInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            if success
//            {
//                print("YASSS")
//            }
//            else
//            {
//                print(":(")
//            }
//        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        let pushQuery = PFInstallation.query()!
//        let installationId = PFInstallation.currentInstallation().installationId
//        pushQuery.whereKey("installationId", equalTo: installationId)
//        let push = PFPush()
//        let data = ["alert" : "Warning: Reached cannot send messages if the app is completely closed"]
//        push.setQuery(pushQuery)
//        push.setData(data)
//        NSThread.sleepForTimeInterval(3)
//        do {
//            try push.sendPush()
//        }
//        catch {
//            print("ERROR")
//        }
    }

//    func clearBadges() {
//        let installation = PFInstallation.currentInstallation()
//        installation.badge = 0
//        installation.saveInBackgroundWithBlock { (success, error) -> Void in
//            if success {
//                print("cleared badges")
//                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
//            }
//            else {
//                print("failed to clear badges")
//            }
//        }
//    }
}

