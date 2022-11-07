//
//  MonthYearJumperCell.swift
//  FSCalendar
//
//  Created by Vedant.Fi4m on 08/11/22.
//

import UIKit

class MonthYearJumperCell: UICollectionViewCell {
  var titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  private func setup() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
}
