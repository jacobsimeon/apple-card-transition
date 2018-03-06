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
  let animationController = NavigationAnimationController()
  let transitioningDelegate = TransitioningDelegate()

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    window = UIWindow()

    let rootViewController = RootViewController()
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()

    return true
  }
}

