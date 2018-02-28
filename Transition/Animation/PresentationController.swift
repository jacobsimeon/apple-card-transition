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
    view.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
    view.alpha = 0.0

    return view
  }()

  static var count: CGFloat = 0.0
  override var frameOfPresentedViewInContainerView: CGRect {
    defer {
      PresentationController.count += 1
    }
    guard let containerBounds = containerView?.bounds else {
      fatalError("woops, no container view")
    }

    let margin: CGFloat
    if presentingViewController is RootViewController {
      margin = 38
    } else {
      margin = 44
    }

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
    coordinator.animate(alongsideTransition: {
      context in
      self.dimmingOverlay.alpha = 1.0
    })

    updateSnapshot()
    snapshotWrapper.frame = presentingViewController.view.frame
    container.insertSubview(snapshotWrapper, at: 0)

    let scale = CGAffineTransform.scaledBy(.identity)(x: 0.925, y: 0.925)
    let translation: CGAffineTransform

    if presentingViewController is RootViewController {
      translation = scale
    } else {
      translation = CGAffineTransform.translatedBy(scale)(x: -0.0, y: -32.0)
    }

    coordinator.animate(alongsideTransition: {
      context in
      self.snapshotWrapper.transform = translation
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

    coordinator.animate(alongsideTransition: {
      context in
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
