//
//  AppDelegate.swift
//  HooqAssignment
//
//  Created by Sudheer Palchuri on 11/12/19.
//  Copyright © 2019 Sudheer Palchuri. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: RootCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = RootCoordinator(window: window)
        coordinator.initMainScreen()
        
        self.coordinator = coordinator
        self.window = window
        return true
    }
    
}


