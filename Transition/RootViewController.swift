//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  let transitionDelegate = TransitioningDelegate()

  let label: UILabel = {
    let _label = UILabel()
    _label.text = "View Controller A"
    _label.font = .systemFont(ofSize: 32)
    _label.translatesAutoresizingMaskIntoConstraints = false

    return _label
  }()

  let presentButton: UIButton = {
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
    rootView.addSubview(label)
    rootView.addSubview(presentButton)

    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.centerYAnchor),
      label.centerXAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.centerXAnchor),
      presentButton.centerXAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.centerXAnchor),
      presentButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8)
    ])

    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "View A"
    navigationItem.largeTitleDisplayMode = .always
    presentButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }

  @objc func didTapButton(sender: Any) {
    let viewB = ViewControllerB()
    viewB.transitioningDelegate = transitionDelegate
    viewB.modalPresentationCapturesStatusBarAppearance = true
    viewB.modalPresentationStyle = .custom

    present(viewB, animated: true) {
      print("Finished presenting")
    }
  }
}
