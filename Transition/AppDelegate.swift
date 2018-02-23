//
//  AppDelegate.swift
//  Transition
//
//  Created by pivotal on 2/23/18.
//  Copyright © 2018 PivotalTracker. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    window = UIWindow()
    window?.rootViewController = UINavigationController(rootViewController: RootViewController())
    window?.makeKeyAndVisible()

    return true
  }

}

