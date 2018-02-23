//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
  override init(presentedViewController: UIViewController, presenting: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presenting)
  }

  private let snapshotWrapper: UIView = {
    let view = UIView()
    view.clipsToBounds = true

    return view
  }()

  private let dimmingOverlay: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
    view.alpha = 0.0

    return view
  }()

  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerBounds = containerView?.bounds else {
      fatalError("woops, no container view")
    }

    let margin: CGFloat = 48.0

    return CGRect(
      x: containerBounds.origin.x,
      y: containerBounds.origin.y + margin,
      width: containerBounds.width,
      height: containerBounds.height - margin
    )
  }

  override func presentationTransitionWillBegin() {
    guard let container = containerView else {
      return
    }

    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingOverlay.alpha = 1.0
      return
    }

    dimmingOverlay.frame = container.bounds
    dimmingOverlay.alpha = 0.0
    container.insertSubview(dimmingOverlay, at: 1)
    coordinator.animate(alongsideTransition: { context in
      self.dimmingOverlay.alpha = 1.0
    })

    guard let snapshotView = presentingViewController.view.snapshotView(afterScreenUpdates: false) else {
      return
    }

    snapshotWrapper.subviews.forEach { view in
      view.removeFromSuperview()
    }
    snapshotWrapper.frame = presentingViewController.view.bounds
    snapshotWrapper.addSubview(snapshotView)
    container.insertSubview(snapshotWrapper, at: 0)

    coordinator.animate(alongsideTransition: { context in
      self.snapshotWrapper.layer.cornerRadius = 10.0
      self.snapshotWrapper.transform = CGAffineTransform.scaledBy(.identity)(x: 0.925, y: 0.925)
    })
  }

  override func presentationTransitionDidEnd(_ completed: Bool) {
    if (!completed) {
      print("didn't complete, removing")
      dimmingOverlay.removeFromSuperview()
      snapshotWrapper.removeFromSuperview()
    }
  }

  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingOverlay.alpha = 0.0
      return
    }

    coordinator.animate(alongsideTransition: { context in
      self.dimmingOverlay.alpha = 0.0
      self.snapshotWrapper.layer.cornerRadius = 0.0
      self.snapshotWrapper.transform = CGAffineTransform.identity
    });
  }

  override func dismissalTransitionDidEnd(_ completed: Bool) {
    if (completed) {
      dimmingOverlay.removeFromSuperview()
      snapshotWrapper.removeFromSuperview()
    }
  }
}
