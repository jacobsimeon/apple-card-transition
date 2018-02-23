//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class DismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.375
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView

    guard let dismissedView = transitionContext.view(forKey: .from) else {
      print("Unable to find view being dismissed")
      return
    }

    guard let returningToViewController = transitionContext.viewController(forKey: .to),
          let returningToView = returningToViewController.view else {
      print("Unable to find view to return to")
      return
    }

    let dismissedViewFinalFrame = CGRect(
      x: 0.0,
      y: containerView.frame.size.height,
      width: returningToView.frame.size.width,
      height: returningToView.frame.size.height
    )

    let duration = transitionDuration(using: transitionContext)
    print("Animating \(dismissedView) to \(dismissedViewFinalFrame) with duration: \(duration)")


    UIView.animate(
      withDuration: duration,
      animations: {
        dismissedView.frame = dismissedViewFinalFrame
      },
      completion: { _ in
        if (transitionContext.transitionWasCancelled) {
          print("transition was cancelled, removing view we were trying to return to")
        }

        returningToView.isHidden = false

        print("transition complete")
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    )
  }
}
