//
// Created by pivotal on 2/27/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class NavigationAnimationController: NSObject, UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationControllerOperation,
    from fromVC: UIViewController,
    to toVC: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    switch operation {
    case .none:
      return nil
    case .pop:
      return DismissalAnimator()
    case .push:
      return PresentationAnimator()
    }
  }
}
