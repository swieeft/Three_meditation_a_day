//
//  AppDelegate.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 6..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var deviceToken: Data? = nil
    
    var loginViewController: UIViewController?
    var mainViewController: UIViewController?

    fileprivate func setupEntryController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "navigator") as! UINavigationController
        let navigationController2 = storyboard.instantiateViewController(withIdentifier: "navigator") as! UINavigationController
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "login") as UIViewController
        navigationController.pushViewController(viewController, animated: true)
        self.loginViewController = navigationController
        
        let viewController2 = storyboard.instantiateViewController(withIdentifier: "Main") as UIViewController
        navigationController2.pushViewController(viewController2, animated: true)
        self.mainViewController = navigationController2
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        Thread.sleep(forTimeInterval: 2.0)
        
        setupEntryController()
        
        initNotificationSetupCheck()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.kakaoSessionDidChangeWithNotification), name: NSNotification.Name.KOSessionDidChange, object: nil)
        
        reloadRootViewController()
        
        KOSession.shared().clientSecret = SessionConstants.clientSecret.string
        
        return true
    }

    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        { (success, error) in
            
        }
    }
    
    fileprivate func reloadRootViewController() {
        let isOpened = KOSession.shared().isOpen()
        if !isOpened {
            let mainViewController = self.mainViewController as! UINavigationController
            
            let stack = mainViewController.viewControllers
            for i in 0 ..< stack.count {
                print(NSString(format: "[%d]: %@", i, stack[i] as UIViewController))
            }
            mainViewController.popToRootViewController(animated: true)
        }
        
        self.window?.rootViewController = isOpened ? self.mainViewController : self.loginViewController
        self.window?.makeKeyAndVisible()
    }
    
    @objc func kakaoSessionDidChangeWithNotification() {
        reloadRootViewController()
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if KOSession.handleOpen(url) {
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if KOSession.handleOpen(url) {
            return true
        }
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if KOSession.handleOpen(url) {
            return true
        }
        return false
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let dic = userInfo["aps"] as? NSDictionary {
            let message: String = dic["alert"] as! String
            print("message=\(message)")
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken
        print("didRegisterForRemoteNotificationsWithDeviceToken=\(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError=\(error.localizedDescription)")
    }


}

