//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class ListItemCollectionViewCell: UICollectionViewCell {
  private let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false

    return label
  }()

  required init?(coder: NSCoder) {
    fatalError()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(label)
    contentView.backgroundColor = .white
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      label.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
    ])
  }

  func setLabelText(_ text: String) {
    label.text = text
  }
}
