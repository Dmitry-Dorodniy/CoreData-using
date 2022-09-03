//
//  AppDelegate.swift
//  iOS6-HW26-DmitryDorodniy
//
//  Created by Dmitry Dorodniy on 15.08.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let assembly = Assembly()
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController, assembly: assembly)
        router.setRootVC()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

