//
//  AppDelegate.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 2/19/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         // user is not login

        FirebaseApp.configure()
        checkIfUserIsLogIn()
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    func checkIfUserIsLogIn() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    if Auth.auth().currentUser?.uid == nil {
        window?.rootViewController = LoginController()
        OpenLogIn = true
        OpenTabBar = false
        }else{
        window?.rootViewController = UINavigationController(rootViewController: MessagesController())
        OpenTabBar = true
        OpenLogIn = false
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

public var OpenLogIn = Bool()
public var OpenTabBar = Bool()

public func PresenController(Controller:UIViewController) {
    if OpenLogIn {
        let Messages = UINavigationController(rootViewController: MessagesController())
        Messages.modalPresentationStyle = .fullScreen
        Messages.modalTransitionStyle = .flipHorizontal
        Controller.present(Messages, animated: true)
        print("Presen")
    }else{
        Controller.dismiss(animated: true)
        print("dismiss")
    }
}

public func ToPresenController(Controller:UIViewController) {
    if OpenTabBar {
        let logInController = LoginController()
        logInController.modalPresentationStyle = .fullScreen
        logInController.modalTransitionStyle = .flipHorizontal
        Controller.present(logInController, animated: true)
        print("Presen")
    }else{
        Controller.dismiss(animated: true)
        print("dismiss")
    }
}
