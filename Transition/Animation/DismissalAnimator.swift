//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class DismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  private var presentationController: PresentationController?

  init(presentationController: PresentationController?) {
    self.presentationController = presentationController
    super.init()
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.25
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView

    guard let dismissedView = transitionContext.view(forKey: .from) else {
      return
    }

    guard let returningToViewController = transitionContext.viewController(forKey: .to),
          let returningToView = returningToViewController.view else {
      return
    }

    let duration = transitionDuration(using: transitionContext)

    var height = returningToView.frame.height


    if let root = returningToViewController as? RootViewController {
      height = root.navController.view.frame.height + 4
    }

    presentationController?.updateSnapshot()
    let dismissedViewFinalFrame = CGRect(
      x: 0.0,
      y: height,
      width: returningToView.frame.size.width,
      height: returningToView.frame.size.height
    )

    UIView.animate(
      withDuration: duration,
      animations: {
        dismissedView.frame = dismissedViewFinalFrame
      },
      completion: { _ in
        let onscreen = CGRect(
          x: containerView.frame.minX,
          y: returningToView.frame.origin.y,
          width: returningToView.frame.width,
          height: returningToView.frame.height
        )
        returningToView.layer.cornerRadius = 0.0
        returningToView.frame = onscreen

        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    )
  }
}
