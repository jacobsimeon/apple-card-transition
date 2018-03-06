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
    return 0.325
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView

    guard let toVC = transitionContext.viewController(forKey: .to) else {
      print("Unable to gather toVC, returning early")
      return
    }

    let fromVC = transitionContext.viewController(forKey: .from)!
    transitionContext.initialFrame(for: fromVC)

    let toFinalFrame = transitionContext.finalFrame(for: toVC)

    containerView.addSubview(toVC.view)
    toVC.view.frame = CGRect(
      x: containerView.frame.minX,
      y: containerView.frame.maxY,
      width: toFinalFrame.width,
      height: toFinalFrame.height
    )

    moveOffscreen(fromVC.view)
    fromVC.view.layer.cornerRadius = 3.0
    toVC.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    let duration = transitionDuration(using: transitionContext)
    UIView.animate(
      withDuration: duration,
      animations: {
        toVC.view.frame = toFinalFrame
        toVC.view.layer.cornerRadius = 3.0
        toVC.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        toVC.view.layer.shadowColor = UIColor.black.cgColor
        toVC.view.layer.shadowRadius = 2.0
        toVC.view.layer.shadowOpacity = 1.0
        toVC.view.layer.shadowOffset = .zero
      },
      completion: { _ in
        if (transitionContext.transitionWasCancelled) {
          toVC.view.removeFromSuperview()
        }

        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    )
  }

  private func moveOffscreen(_ view: UIView) {
    let offscreen = CGRect(
      x: UIScreen.main.bounds.maxX,
      y: view.frame.minY,
      width: view.frame.width,
      height: view.frame.height
    )

    view.layer.shadowColor = UIColor.gray.cgColor
    view.layer.shadowRadius = 10.0
    view.frame = offscreen
  }
}
