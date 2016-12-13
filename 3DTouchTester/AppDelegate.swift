//
//  AppDelegate.swift
//  3DTouchTester
//
//  Created by Daymein Gregorio on 10/21/15.
//  Copyright © 2015 Daymein Gregorio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var userDefaults = UserDefaults.standard
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let mainVC = self.window!.rootViewController as! ViewController
        if mainVC.timerIsRunning { mainVC.timer.invalidate()}
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let mainVC = self.window!.rootViewController as! ViewController
        if userDefaults.bool(forKey: "springSet") {
            mainVC.animateSpring(0.1, delay: 0.0)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        userDefaults.set(false, forKey: "springSet")
    }


}

