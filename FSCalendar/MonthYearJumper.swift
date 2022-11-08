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

class MonthYearJumper: UIStackView {
  
  private enum MonthYearJumperType {
    case month, year
  }
  
  weak var calendar: FSCalendar!
  weak var jumperDelegate: MonthYearJumperDelegate?
  private var selectedMonth: String!
  private var selectedYear: String!
  private var type = MonthYearJumperType.month
  
  private lazy var headerView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.heightAnchor.constraint(equalToConstant: bounds.height/5).isActive = true
    collectionView.dataSource = self
    collectionView.delegate = self
    addArrangedSubview(collectionView)
    return collectionView
  }()
  
  private lazy var grid: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
        
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    addArrangedSubview(collectionView)
    return collectionView
  }()
  
  init(frame: CGRect, calendar: FSCalendar) {
    self.calendar = calendar
    super.init(frame: frame)
    axis = .vertical
    spacing = 0.5
    headerView.backgroundColor = calendar.backgroundColor
    grid.backgroundColor = calendar.backgroundColor
    headerView.register(MonthYearJumperCell.self, forCellWithReuseIdentifier: "MonthYearJumperCell")
    grid.register(MonthYearJumperCell.self, forCellWithReuseIdentifier: "MonthYearJumperCell")
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func reloadData(with date: Date) {
    selectedMonth = DateFormatter.month.string(from: date)
    selectedYear = DateFormatter.gYear.string(from: date)
    
    let index = Calendar.current.dateComponents([.year], from: calendar.minimumDate, to: date).year!
    let indexPath = IndexPath(row: index, section: 0)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {//patch
      self.headerView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
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
    switch collectionView {
      case grid where type == .month:
        cell.titleLabel.text = Calendar.current.monthSymbols[indexPath.row]
        cell.titleLabel.textColor = cell.titleLabel.text == selectedMonth ? calendar.appearance.titleSelectionColor : calendar.appearance.titleDefaultColor
      default:
        let year = Calendar.current.date(byAdding: .year, value: indexPath.row, to: calendar.minimumDate)!
        cell.titleLabel.text = DateFormatter.gYear.string(from: year)
        cell.titleLabel.textColor = cell.titleLabel.text == selectedYear ? calendar.appearance.titleSelectionColor : calendar.appearance.titleDefaultColor
    }
    
    return cell
  }
}

extension MonthYearJumper: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
      case grid where type == .month:
        let cell = collectionView.cellForItem(at: indexPath) as! MonthYearJumperCell
        selectedMonth = cell.titleLabel.text!
        let rawDate = "\(selectedMonth!) \(selectedYear!)"
        let date = DateFormatter.gMonth.date(from: rawDate)!
        jumperDelegate?.jump(to: date)
      case headerView:
        let cell = collectionView.cellForItem(at: indexPath) as! MonthYearJumperCell
        if cell.titleLabel.text == selectedYear {
          let index = Calendar.current.dateComponents([.year], from: calendar.minimumDate, to: DateFormatter.gYear.date(from: selectedYear)!).year!
          let indexPath = IndexPath(row: index, section: 0)
          headerView.isHidden = true
          type = .year
          grid.performBatchUpdates {
            grid.reloadSections([0])
          } completion: { [weak self] completed in
            guard completed else { return }
            self?.grid.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
          }
        } else {
          selectedYear = cell.titleLabel.text
          headerView.reloadData()
          headerView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
      default:
        let cell = collectionView.cellForItem(at: indexPath) as! MonthYearJumperCell
        selectedYear = cell.titleLabel.text
        headerView.isHidden = false
        type = .month
        grid.reloadData()
        
        let index = Calendar.current.dateComponents([.year], from: calendar.minimumDate, to: DateFormatter.gYear.date(from: selectedYear)!).year!
        let indexPath = IndexPath(row: index, section: 0)
        headerView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
  }
}

extension MonthYearJumper: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
      case grid where type == .month:
        return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height/4)
      case grid where type == .year:
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/6)
      default:
        return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height)
    }
  }
}
