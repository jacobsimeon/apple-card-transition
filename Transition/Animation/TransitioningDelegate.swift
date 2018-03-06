//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class StashTransitioningDelegate: NSObject, UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
  ) -> UIViewControllerInteractiveTransitioning? {
    fatalError(
      "navigationController(navigationController:animationController:) has not been implemented"
    )
  }

  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationControllerOperation,
    from fromVC: UIViewController,
    to toVC: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    fatalError(
      "navigationController(navigationController:operation:fromVC:toVC:) has not been implemented"
    )
  }

//  var presentationController: PresentationController?
//
//  public func animationController(
//    forPresented presented: UIViewController,
//    presenting: UIViewController,
//    source: UIViewController
//  ) -> UIViewControllerAnimatedTransitioning? {
//    return PresentationAnimator(startingFrameOriginYOffset: 32.0)
//  }
//
//  public func animationController(
//    forDismissed dismissed: UIViewController
//  ) -> UIViewControllerAnimatedTransitioning? {
//    return DismissalAnimator(presentationController: presentationController)
//  }
//
//  func presentationController(
//    forPresented presented: UIViewController,
//    presenting: UIViewController?,
//    source: UIViewController
//  ) -> UIPresentationController? {
//    presentationController = PresentationController(
//      presentedViewController: presented,
//      presenting: presenting
//    )
//
//    return presentationController
//  }
}

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  var presentationControllers: [PresentationController]

  override init() {
    presentationControllers = []
    super.init()
  }

  public func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return PresentationAnimator()
  }

  public func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return DismissalAnimator()
  }

  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    let newPresentationController = PresentationController(
      presentedViewController: presented,
      presenting: presenting
    )

    newPresentationController.parent = presentationControllers.last
    newPresentationController.transitioningDelegate = self
    presentationControllers.append(newPresentationController)

    return newPresentationController
  }

  func cleanup(presentationController: PresentationController) {
    presentationControllers.remove(at: presentationControllers.index(of: presentationController)!)
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
