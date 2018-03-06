//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit
import CoreGraphics

class PresentationController: UIPresentationController {
  weak var parent: PresentationController?
  weak var transitioningDelegate: TransitioningDelegate?

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
    view.backgroundColor = UIColor(white: 0.0, alpha: 0.55)
    view.alpha = 0.0

    return view
  }()

  private var margin: CGFloat {
    return 44.0
  }

  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerBounds = containerView?.bounds else {
      fatalError("woops, no container view")
    }

    return CGRect(
      x: containerBounds.origin.x,
      y: margin,
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

    updateSnapshot()
    snapshotWrapper.frame = presentingViewController.view.frame
    container.insertSubview(snapshotWrapper, at: 0)

    dimmingOverlay.frame = container.bounds
    dimmingOverlay.alpha = 0.0

//    container.insertSubview(dimmingOverlay, at: 1)
//    coordinator.animate(alongsideTransition: { context in
//      self.dimmingOverlay.alpha = 1.0
//    })

    pushBack(coordinator: coordinator)
  }

  var hasAppliedTranslationTransform = false

  private func pushBack(coordinator: UIViewControllerTransitionCoordinator) {
    if let parent = self.parent {
      parent.pushBack(coordinator: coordinator)
    }

    let shiftMultiplier: CGFloat
    if self.parent == nil, !hasAppliedTranslationTransform {
      shiftMultiplier = 27.0
    } else {
      shiftMultiplier = -16.0
    }

    var transform = CGAffineTransform.scaledBy(self.snapshotWrapper.transform)(x: 0.975, y: 0.975)
    transform = CGAffineTransform.translatedBy(transform)(x: 0.0, y: shiftMultiplier)

    coordinator.animate(alongsideTransition: { context in
      self.snapshotWrapper.transform = transform
      self.hasAppliedTranslationTransform = true
    })
  }

  override func presentationTransitionDidEnd(_ completed: Bool) {
    if (!completed) {
      dimmingOverlay.removeFromSuperview()
      snapshotWrapper.removeFromSuperview()
    }
  }

  override func dismissalTransitionWillBegin() {
    updateSnapshot()

    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingOverlay.alpha = 0.0
      return
    }

    parent?.pullForward(coordinator: coordinator)

    coordinator.animate(alongsideTransition: {
      context in
//      self.dimmingOverlay.alpha = 0.0
//      self.snapshotWrapper.layer.cornerRadius = 0.0
      self.snapshotWrapper.transform = CGAffineTransform.identity
    });
  }

  func pullForward(coordinator: UIViewControllerTransitionCoordinator) {
    parent?.pullForward(coordinator: coordinator)

    var transform = CGAffineTransform.translatedBy(snapshotWrapper.transform)(x: 0.0, y: 16.0)
    transform = CGAffineTransform.scaledBy(transform)(x: 1.025, y: 1.025)
    coordinator.animate(alongsideTransition: { _ in
      self.snapshotWrapper.transform = transform
    })
  }

  override func dismissalTransitionDidEnd(_ completed: Bool) {
    if (completed) {
      dimmingOverlay.removeFromSuperview()
      snapshotWrapper.removeFromSuperview()
    }

    transitioningDelegate?.cleanup(presentationController: self)
  }

  func updateSnapshot() {
    guard let snapshotView = presentingViewController.view.snapshotView(afterScreenUpdates: true) else {
      return
    }
    snapshotWrapper.subviews.forEach {
      view in
      view.removeFromSuperview()
    }
    snapshotWrapper.addSubview(snapshotView)
  }
}
