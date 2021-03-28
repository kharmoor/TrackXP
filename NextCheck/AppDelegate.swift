//
//  AppDelegate.swift
//  NextCheck
//
//  Created by Khari Moore on 6/11/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import UIKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let _log = OSLog(subsystem: "com.example.NextCheck", category: "DB")
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            try CommonRepo.createVersionTable()
            
            let curVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String  ?? "1.0"
            let storedVersion = try CommonRepo.findVersion()
            
            if curVersion != storedVersion{
            try CommonRepo.insertVersion()
            try ExpenseRepo.createTable()
            try IncomeRepo.createTable()
            try BudgetGroupRepo.createTable()
            try BudgetRepo.createTable()
            try TransactionRepo.createTable()
                
            }
        } catch {
            os_log("Failed to initialize DataStore: %@", log: _log, type: .error,error.localizedDescription)
            return false
        }
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white //UIColor(rgb: 0x072a63)
        navigationBarAppearace.barTintColor = UIColor(red: 7, green: 42, blue: 99) //UIColor(red: 255, green: 255, blue: 255)
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor.white
        tabBarAppearance.barTintColor = UIColor(red: 25, green: 29, blue: 50)
        
        //change status bar color
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //change view background color
        let viewController = self.window?.rootViewController
        viewController?.view.backgroundColor = UIColor(red: 242, green: 239, blue: 231)
        
        
        return true
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

