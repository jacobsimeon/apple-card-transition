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

    let navController = UINavigationController(
      rootViewController: ListViewController(items: ListItems.all)
    )
    navController.navigationBar.prefersLargeTitles = true
    navController.transitioningDelegate = transitioningDelegate
    navController.delegate = animationController

    window?.rootViewController = navController
    window?.makeKeyAndVisible()

    return true
  }
}

