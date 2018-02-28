//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class ListItemViewController: UIViewController {
  private let item: ListItem
  weak var rootViewController: RootViewController?

  required init?(coder: NSCoder) {
    fatalError()
  }

  init(item: ListItem) {
    self.item = item
    super.init(nibName: nil, bundle: nil)
  }

  let label: UILabel = {
    let _label = UILabel()
    _label.translatesAutoresizingMaskIntoConstraints = false
    _label.numberOfLines = 0
    _label.textAlignment = .center
    _label.font = .systemFont(ofSize: 32.0)

    return _label
  }()

  let doneButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Done", for: .normal)

    return button
  }()

  let stashButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Stash", for: .normal)

    return button
  }()

  let openButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Open another card", for: .normal)

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
    rootView.addSubview(doneButton)
    rootView.addSubview(stashButton)
    rootView.addSubview(openButton)

    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.centerYAnchor),
      label.leadingAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.trailingAnchor),

      doneButton.leftAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.leftAnchor, constant: 8),
      doneButton.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor, constant: 8),

      stashButton.rightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.rightAnchor, constant: -8),
      stashButton.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor, constant: 8),

      openButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
      openButton.centerXAnchor.constraint(equalTo: label.centerXAnchor)
    ])

    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    label.text = item.title

    doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    stashButton.addTarget(self, action: #selector(didTapStashButton), for: .touchUpInside)
    openButton.addTarget(self, action: #selector(didTapOpenButton), for: .touchUpInside)
  }

  @objc func didTapDoneButton(sender: Any) {
    navigationController?.popViewController(animated: true)
  }

  @objc func didTapStashButton(sender: Any) {
  }

  @objc func didTapOpenButton(sender: Any) {
    let itemVC = ListItemViewController(item: ListItems.random)
    navigationController?.pushViewController(itemVC, animated: true)
  }

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.isNavigationBarHidden = true
    super.viewWillAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    navigationController?.isNavigationBarHidden = false
    super.viewWillDisappear(animated)
  }
}
