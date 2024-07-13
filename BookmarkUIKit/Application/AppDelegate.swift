//
//  AppDelegate.swift
//  BookmarkUIKit
//
//  Created by Bekzat Batyrkhanov on 15.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
//        window?.rootViewController = WelcomeViewController()
        
        let navigationController = UINavigationController(rootViewController: WelcomeVC())
        
        window?.rootViewController = navigationController
        
        return true
    }

}

