//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.375
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView

    guard let toVC = transitionContext.viewController(forKey: .to) else {
      print("Unable to gather toVC, returning early")
      return
    }

    guard let fromVC = transitionContext.viewController(forKey: .from) else {
      print("Unable to gather fromView, returning")
      return
    }

    let toView = toVC.view!
    let fromView = fromVC.view!

    let containerFrame = containerView.frame
    var toStartFrame = transitionContext.initialFrame(for: toVC)
    toStartFrame.size.width = containerFrame.width
    toStartFrame.origin.x = 0.0
    toStartFrame.origin.y = containerFrame.size.height

    let toFinalFrame = transitionContext.finalFrame(for: toVC)

    print("""
    Presenting \(toVC)
      starting at: \(toStartFrame)
      ending at: \(toFinalFrame)
    """
    )

    containerView.addSubview(toView)
    toView.frame = toStartFrame
    fromView.isHidden = true

    let duration = transitionDuration(using: transitionContext)

    print("Starting animation with duration \(duration)")

    UIView.animate(
      withDuration: duration,
      animations: {
        toView.frame = toFinalFrame
        toView.layer.cornerRadius = 10.0
        toView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      },
      completion: { _ in
        if (transitionContext.transitionWasCancelled) {
          print("transition was cancelled, removing presented view")
          toView.removeFromSuperview()
        }

        print("transition complete")
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    )
  }
}
