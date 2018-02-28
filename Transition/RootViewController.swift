//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  enum StashMode {
    case none
    case pending
    case stashed
  }

  let navController: UINavigationController
  let listViewController: ListViewController
  var navControllerBottomConstraint: NSLayoutConstraint

  let cardTransitionDelegate = TransitioningDelegate()
  let stashTransitionDelegate = StashTransitioningDelegate()

  let stashedItemTapRecognizer: UIGestureRecognizer
  var stashedItem: ListItem?

  private var visibleStashConstraints: [NSLayoutConstraint]
  private var noStashConstraints: [NSLayoutConstraint]
  private var pendingStashConstraints: [NSLayoutConstraint]

  required init?(coder: NSCoder) {
    fatalError("Unable to initialize from nib")
  }

  override init(nibName nibNameOrNil: String?, bundle bundleOrNil: Bundle?) {
    listViewController = ListViewController(items: ListItems.all)
    navController = UINavigationController(rootViewController: listViewController)
    navController.navigationBar.prefersLargeTitles = true
    navController.view.clipsToBounds = true

    stashedItemTapRecognizer = UITapGestureRecognizer()
    navControllerBottomConstraint = NSLayoutConstraint()

    visibleStashConstraints = [
      stashedItemView.layoutMarginsGuide.topAnchor.constraint(equalTo: stashedItemLabel.topAnchor),
      stashedItemView.topAnchor.constraint(equalTo: navController.view.bottomAnchor, constant: 4.0),
      stashedItemView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
      stashedItemView.leftAnchor.constraint(equalTo: navController.view.leftAnchor),
      stashedItemView.rightAnchor.constraint(equalTo: navController.view.rightAnchor),

      stashedItemLabel.bottomAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
      stashedItemLabel.centerXAnchor.constraint(equalTo: rootView.centerXAnchor)
    ]

    noStashConstraints = [
      navController.view.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
    ]

    pendingStashConstraints = [
      navController.view.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -44.0),
    ]

    super.init(nibName: nibNameOrNil, bundle: bundleOrNil)

    stashedItemTapRecognizer.addTarget(self, action: #selector(didTapStashedItem))
    stashedItemView.addGestureRecognizer(stashedItemTapRecognizer)
    listViewController.rootViewController = self
  }

  var stashMode: StashMode = .none {
    didSet {
      NSLayoutConstraint.deactivate(noStashConstraints)
      NSLayoutConstraint.deactivate(pendingStashConstraints)
      NSLayoutConstraint.deactivate(visibleStashConstraints)

      switch stashMode {
      case .none:
        NSLayoutConstraint.activate(noStashConstraints)
        stashedItemView.isHidden = true
        navController.view.layer.cornerRadius = 0.0
      case .pending:
        NSLayoutConstraint.activate(pendingStashConstraints)
        stashedItemView.isHidden = true
        navController.view.layer.cornerRadius = 10.0
      case .stashed:
        NSLayoutConstraint.activate(visibleStashConstraints)
        stashedItemView.isHidden = false
        navController.view.layer.cornerRadius = 10.0
      }

      self.rootView.layoutIfNeeded()
    }
  }

  let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .black

    return view
  }()

  let stashedItemView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false

    view.backgroundColor = .white
    view.layer.cornerRadius = 10.0
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    return view
  }()

  let stashedItemLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false

    return label
  }()

  @objc func didTapStashedItem() {
    let itemViewController = ListItemViewController(item: stashedItem!)
//    itemViewController.transitioningDelegate = stashTransitionDelegate
    itemViewController.modalPresentationStyle = .custom
    itemViewController.modalPresentationCapturesStatusBarAppearance = true
    itemViewController.rootViewController = self

    present(itemViewController, animated: true)
  }

  override func loadView() {
    addChildViewController(navController)
    navController.view.translatesAutoresizingMaskIntoConstraints = false
    rootView.addSubview(navController.view)
    navController.didMove(toParentViewController: self)

    stashedItemView.addSubview(stashedItemLabel)
    rootView.addSubview(stashedItemView)

    NSLayoutConstraint.activate([
      navController.view.topAnchor.constraint(equalTo: rootView.topAnchor),
      navController.view.leftAnchor.constraint(equalTo: rootView.leftAnchor),
      navController.view.rightAnchor.constraint(equalTo: rootView.rightAnchor),
    ])

    NSLayoutConstraint.activate(noStashConstraints)

    view = rootView
  }

  func showItem(at index: Int) {
    let item: ListItem = ListItems.all[index]
    showItem(item: item)
  }

  private func showItem(item: ListItem) {
    let itemViewController = ListItemViewController(item: item)
    itemViewController.modalPresentationCapturesStatusBarAppearance = true
    itemViewController.modalPresentationStyle = .custom
    itemViewController.transitioningDelegate = self.cardTransitionDelegate
    itemViewController.rootViewController = self

    var topmostVC: UIViewController = self
    while (topmostVC.presentedViewController != nil) {
      topmostVC = topmostVC.presentedViewController!
    }

    topmostVC.present(
      itemViewController,
      animated: true,
      completion: {
        self.stashMode = .pending
      }
    )
  }

  func stash(item: ListItem) {
    stashedItem = item

    updateStash()
    pop()
  }

  func dismiss(item: ListItem) {
    if item.title == stashedItem?.title {
      stashedItem = nil
    }

    updateStash()
    pop()
  }

  private func pop() {
    var topmostPresenter: UIViewController = self
    while (topmostPresenter.presentedViewController != nil) {
      topmostPresenter = topmostPresenter.presentedViewController!
    }

    topmostPresenter.dismiss(animated: true)
  }

  func present(item: ListItem) {
    showItem(item: item)
  }

  private func updateStash() {
    stashedItemLabel.text = stashedItem?.title
    if stashedItem != nil {
      stashMode = .stashed
    } else {
      stashMode = .none
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
