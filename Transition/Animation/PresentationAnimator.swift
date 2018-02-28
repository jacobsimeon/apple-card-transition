//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  private let startingFrameOriginYOffset: CGFloat

  init(startingFrameOriginYOffset: CGFloat = 0.0) {
    self.startingFrameOriginYOffset = startingFrameOriginYOffset
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1.0
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
    var toStartFrame = calculateStartingFrame(
      transitionContext: transitionContext,
      toVC: toVC,
      containerFrame: containerFrame
    )

    if let from = fromVC as? RootViewController {
      toStartFrame.origin.y = from.navController.view.frame.height + 4
    }

    var toFinalFrame = transitionContext.finalFrame(for: toVC)
    toFinalFrame.origin.y = 44.0

    containerView.addSubview(toView)
    toView.frame = toStartFrame

    toView.layer.cornerRadius = 10.0
    toView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//    moveOffscreen(fromView: fromView, containerView: containerView)

    let duration = transitionDuration(using: transitionContext)
    UIView.animate(
      withDuration: duration,
      animations: {
        toView.frame = toFinalFrame
      },
      completion: { _ in
        if (transitionContext.transitionWasCancelled) {
          toView.removeFromSuperview()
        }

        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    )

  }

  private func calculateStartingFrame(
    transitionContext: UIViewControllerContextTransitioning,
    toVC: UIViewController,
    containerFrame: CGRect
  ) -> CGRect {
    var toStartFrame = transitionContext.initialFrame(for: toVC)
    toStartFrame.size.width = containerFrame.width
    toStartFrame.size.height = containerFrame.height
    toStartFrame.origin.x = 0.0
    toStartFrame.origin.y = containerFrame.size.height - startingFrameOriginYOffset
    return toStartFrame
  }

  private func moveOffscreen(fromView: UIView, containerView: UIView) {
    let offscreen = CGRect(
      x: UIScreen.main.bounds.minX + UIScreen.main.bounds.width,
      y: fromView.frame.minY,
      width: fromView.frame.width,
      height: fromView.frame.height
    )

    // move fromView offscreen so we can snapshot it later
    fromView.frame = offscreen
  }
}
