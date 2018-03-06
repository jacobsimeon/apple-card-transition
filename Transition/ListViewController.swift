//
// Created by pivotal on 2/23/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import UIKit

class ListViewController: CardViewController {
  private let items: [ListItem]
  private let cardTransitioningDelegate = TransitioningDelegate()
  weak var rootViewController: RootViewController?

  required public init?(coder aDecoder: NSCoder) {
    fatalError("RetrosTableViewController cannot be instantiated from a storyboard")
  }

  init(items: [ListItem]) {
    self.items = items
    super.init(nibName: nil, bundle: nil)
    navigationItem.title = "A List of Things"
    navigationItem.largeTitleDisplayMode = .automatic

    rootView.dataSource = self
    rootView.delegate = self
  }

  let rootView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 2, height: 64)
    layout.minimumLineSpacing = 1
    layout.minimumInteritemSpacing = 1

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(
      ListItemCollectionViewCell.self,
      forCellWithReuseIdentifier: "\(ListItemCollectionViewCell.self)"
    )

    collectionView.backgroundColor = .groupTableViewBackground
    return collectionView
  }()

  override func loadView() {
    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension ListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "\(ListItemCollectionViewCell.self)",
      for: indexPath
    ) as? ListItemCollectionViewCell else {
      fatalError("Wrong cell type")
    }

    let item = items[indexPath.item]
    cell.setLabelText(item.title)
    return cell
  }
}

extension ListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let listItemVC = ListItemViewController(item: items[indexPath.item])
    cardStackViewController?.push(listItemVC)
  }
}


