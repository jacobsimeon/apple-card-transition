//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  public func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    print("Making animator to present \(presented) from \(presenting)")
    return PresentationAnimator()
  }

  public func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    print("Making dismissal animator for \(dismissed)")
    return DismissalAnimator()
  }

  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    print("making presentation controller")
    return PresentationController(presentedViewController: presented, presenting: presenting)
  }

  /*
  func interactionControllerForPresentation(
    using animator: UIViewControllerAnimatedTransitioning
  ) -> UIViewControllerInteractiveTransitioning? { fatalError(
    "interactionControllerForPresentation(animator:) has not been implemented"
  ) }

  func interactionControllerForDismissal(
    using animator: UIViewControllerAnimatedTransitioning
  ) -> UIViewControllerInteractiveTransitioning? { fatalError(
    "interactionControllerForDismissal(animator:) has not been implemented"
  ) }

  */
}
