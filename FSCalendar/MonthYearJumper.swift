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

class MonthYearJumper: UIView {
  
  private enum MonthYearJumperType {
    case month, year
  }
  
  weak var calendar: FSCalendar!
  weak var jumperDelegate: MonthYearJumperDelegate?
  private var type = MonthYearJumperType.month
  
  private lazy var headerView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let frame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: 46))
    layout.itemSize = CGSize(width: frame.width/3, height: frame.height)
    
    let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(MonthYearJumperCell.self, forCellWithReuseIdentifier: "MonthYearJumperCell")
    collectionView.isPagingEnabled = true
    collectionView.backgroundColor = calendar.backgroundColor
    addSubview(collectionView)
    return collectionView
  }()
  
  private lazy var grid: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let headerHeight = headerView.bounds.height
    let frame = CGRect(x: 0, y: headerHeight, width: bounds.width, height: bounds.height - headerHeight)
    layout.itemSize = CGSize(width: frame.width/3, height: frame.height/4)
    
    let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(MonthYearJumperCell.self, forCellWithReuseIdentifier: "MonthYearJumperCell")
    collectionView.backgroundColor = calendar.backgroundColor
    addSubview(collectionView)
    return collectionView
  }()
  
  init(frame: CGRect, calendar: FSCalendar) {
    self.calendar = calendar
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @discardableResult
  func reloadData() -> IndexPath {
    grid.reloadData()
    let index = Calendar.current.dateComponents([.year], from: calendar.minimumDate, to: calendar.currentPage).year!
    let indexPath = IndexPath(row: index, section: 0)
    headerView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    return indexPath
  }
}

extension MonthYearJumper: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
      case grid where type == .month:
        return Calendar.current.monthSymbols.count
      default:
        return Calendar.current.dateComponents([.year], from: calendar.minimumDate, to: calendar.maximumDate).year!
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthYearJumperCell", for: indexPath) as! MonthYearJumperCell
    cell.backgroundColor = calendar.backgroundColor
    cell.titleLabel.textColor = calendar.appearance.titleDefaultColor
    switch collectionView {
      case grid where type == .month:
        cell.titleLabel.text = Calendar.current.monthSymbols[indexPath.row]
      default:
        let year = Calendar.current.date(byAdding: .year, value: indexPath.row, to: calendar.minimumDate)!
        cell.titleLabel.text = Panchaang.dateFormatter.string(from: year)
    }
    
    return cell
  }
}

extension MonthYearJumper: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
      case grid where type == .month:
        let cell = collectionView.cellForItem(at: indexPath) as! MonthYearJumperCell
        let rawDate = "\(cell.titleLabel.text!) 2022"
        let date = Panchaang.dateFormatter.date(from: rawDate)!
        jumperDelegate?.jump(to: date)
      case headerView:
        self.type = .year
        grid.reloadData()
      default:
        self.type = .month
        grid.reloadData()
    }
  }
}
