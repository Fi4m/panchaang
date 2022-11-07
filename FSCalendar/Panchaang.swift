//
//  Panchaang.swift
//  FSCalendar
//
//  Created by Vedant.Fi4m on 07/11/22.
//  Copyright © 2022 wenchaoios. All rights reserved.
//

import UIKit

open class Panchaang: UIView {
  public lazy var calendar: FSCalendar = {
    let calendar = FSCalendar(frame: bounds)
//    calendar.calendarHeaderView.collectionView.delegate = self
    calendar.translatesAutoresizingMaskIntoConstraints = false
    addSubview(calendar)
    applyConstraints(to: calendar)
    return calendar
  }()
  
  
  public lazy var jumper: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: bounds, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(collectionView)
    applyConstraints(to: collectionView)
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }()
  
  private func applyConstraints(to view: UIView) {
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: topAnchor),
      view.leftAnchor.constraint(equalTo: leftAnchor),
      view.rightAnchor.constraint(equalTo: rightAnchor),
      view.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
}

extension Panchaang: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    fatalError()
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    fatalError()
  }
}

extension Panchaang: UICollectionViewDelegate {
  
}
