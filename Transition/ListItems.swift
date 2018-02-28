//
// Created by pivotal on 2/27/18.
// Copyright (c) 2018 PivotalTracker. All rights reserved.
//

import Foundation

class ListItems {
  static let all: [ListItem] = [
    ListItem(title: "Lorem ipsum dolor sit"),
    ListItem(title: "amet, consectetur adipiscing"),
    ListItem(title: "elit. Cras lobortis volutpat"),
    ListItem(title: "aliquet. Suspendisse"),
    ListItem(title: "sit amet leo dui."),
    ListItem(title: "Nulla sit amet felis et "),
    ListItem(title: "enim suscipit maximus"),
    ListItem(title: "Integer a enim pellentesque"),
    ListItem(title: "gravida augue vel, aliquam justo"),
    ListItem(title: "Proin tincidunt convallis"),
    ListItem(title: "nunc, sed sagittis nisi "),
    ListItem(title: "auctor vitae."),
    ListItem(title: "Aliquam erat volutpat."),
    ListItem(title: "Phasellus ac nisi finibus"),
    ListItem(title: "tempor tellus ut, rutrum lorem"),
    ListItem(title: "Donec non augue fermentum"),
    ListItem(title: "bibendum ligula quis, "),
    ListItem(title: "tristique magna."),
    ListItem(title: "Aliquam semper ipsum"),
    ListItem(title: "ac ipsum feugiat venenatis.")
  ]

  static var random: ListItem {
    return all[Int(arc4random_uniform(UInt32(all.count)))]
  }
}
