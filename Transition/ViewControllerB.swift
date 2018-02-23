//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class ViewControllerB: UIViewController {
  let label: UILabel = {
    let _label = UILabel()
    _label.text = "View Controller B"
    _label.font = .systemFont(ofSize: 32)
    _label.translatesAutoresizingMaskIntoConstraints = false

    return _label
  }()

  let dismissButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Dismiss", for: .normal)

    return button
  }()

  let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .white

    return view
  }()

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func loadView() {
    rootView.addSubview(label)
    rootView.addSubview(dismissButton)

    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.centerYAnchor),
      label.centerXAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.centerXAnchor),
      dismissButton.centerXAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.centerXAnchor),
      dismissButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8)
    ])

    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
  }

  @objc func didTapDismissButton(sender: Any) {
    presentingViewController?.dismiss(animated: true) {
      print("Finished dismissing")
    }
  }
}
