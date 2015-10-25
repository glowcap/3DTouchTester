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
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        let mainVC = self.window!.rootViewController as! ViewController
        if mainVC.timerIsRunning { mainVC.timer.invalidate()}
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        let mainVC = self.window!.rootViewController as! ViewController
        if userDefaults.boolForKey("springSet") {
            print("called Active")
            mainVC.animateSpring(0.1, delay: 0.0)
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        userDefaults.setBool(false, forKey: "springSet")
    }


}

