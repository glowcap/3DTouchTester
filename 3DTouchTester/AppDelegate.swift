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
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        let mainVC = self.window!.rootViewController as! ViewController
        if mainVC.timerIsRunning { mainVC.timer.invalidate()}
        
        if mainVC.springIsSet == true {
            userDefaults.setBool(true, forKey: "springSet")
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        let mainVC = self.window!.rootViewController as! ViewController
        
        if userDefaults.boolForKey("springSet") == true {
            mainVC.springView.frame = CGRect(x: mainVC.springView.frame.origin.x, y: mainVC.springView.frame.origin.y, width: mainVC.springView.frame.width, height: mainVC.springView.frame.height)
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        userDefaults.setBool(false, forKey: "springSet")
    }


}

