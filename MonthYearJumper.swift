//
//  MonthYearJumper.swift
//  FSCalendar
//
//  Created by Vedant.Fi4m on 08/11/22.
//

import UIKit

protocol MonthYearJumperDelegate: AnyObject {
  func jump(to date: Date)
}

public class MonthYearJumper: UICollectionView {
  
  public var textColor = UIColor.black
  weak var jumperDelegate: MonthYearJumperDelegate?
  
  init(frame: CGRect) {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    super.init(frame: frame, collectionViewLayout: layout)
    layout.itemSize = CGSize(width: bounds.width/3, height: bounds.height/4)
    
    dataSource = self
    delegate = self
    register(MonthYearJumperCell.self, forCellWithReuseIdentifier: "MonthYearJumperCell")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MonthYearJumper: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Calendar.current.monthSymbols.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthYearJumperCell", for: indexPath) as! MonthYearJumperCell
    cell.backgroundColor = collectionView.backgroundColor
    cell.titleLabel.textColor = textColor
    cell.titleLabel.text = Calendar.current.monthSymbols[indexPath.row]
    return cell
  }
}

extension MonthYearJumper: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! MonthYearJumperCell
    let rawDate = "\(cell.titleLabel.text!) 2022"
    let date = Panchaang.dateFormatter.date(from: rawDate)!
    jumperDelegate?.jump(to: date)
  }
}
