//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
  weak var cardStackViewController: RootViewController?
}

class RootViewController: UIViewController {
  let listViewController: ListViewController
  let cardTransitionDelegate = TransitioningDelegate()

  required init?(coder: NSCoder) {
    fatalError("Unable to initialize from nib")
  }

  override init(nibName nibNameOrNil: String?, bundle bundleOrNil: Bundle?) {
    listViewController = ListViewController(items: ListItems.all)
    super.init(nibName: nibNameOrNil, bundle: bundleOrNil)
    listViewController.cardStackViewController = self
  }

  let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .black

    return view
  }()

  override func loadView() {
    addChildViewController(listViewController)
    listViewController.view.translatesAutoresizingMaskIntoConstraints = false
    rootView.addSubview(listViewController.view)
    listViewController.didMove(toParentViewController: self)

    NSLayoutConstraint.activate([
      listViewController.view.topAnchor.constraint(equalTo: rootView.topAnchor),
      listViewController.view.leftAnchor.constraint(equalTo: rootView.leftAnchor),
      listViewController.view.rightAnchor.constraint(equalTo: rootView.rightAnchor),
      listViewController.view.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
    ])

    view = rootView
  }

  func push(_ viewController: CardViewController) {
    viewController.transitioningDelegate = cardTransitionDelegate
    viewController.modalPresentationStyle = .custom
    viewController.modalPresentationCapturesStatusBarAppearance = true
    viewController.cardStackViewController = self

    topPresenter().present(viewController, animated: true)
  }

  func pop() {
    let presenter = topPresenter()
    if let card = presenter.presentedViewController as? CardViewController {
      card.cardStackViewController = nil
    }

    presenter.dismiss(animated: true)
  }

  private func topPresenter() -> UIViewController {
    var topmostPresenter: UIViewController = self
    while (topmostPresenter.presentedViewController != nil) {
      topmostPresenter = topmostPresenter.presentedViewController!
    }
    return topmostPresenter
  }
}
