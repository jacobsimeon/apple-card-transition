//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  let button: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Show View B", for: .normal)

    return button
  }()

  let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .white

    return view
  }()

  override func loadView() {
    rootView.addSubview(button)

    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
      button.leadingAnchor.constraint(equalTo: rootView.layoutMarginsGuide.leadingAnchor)
    ])

    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "View A"
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }

  @objc func didTapButton(sender: Any) {
    let viewB = ViewControllerB()
    present(viewB, animated: true)
  }
}
