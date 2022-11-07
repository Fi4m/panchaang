//
//  Panchaang.swift
//  FSCalendar
//
//  Created by Vedant.Fi4m on 07/11/22.
//  Copyright © 2022 wenchaoios. All rights reserved.
//

import UIKit

open class Panchaang: UIView {
  
  static var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
  }()
  
  public lazy var calendar: FSCalendar = {
    let calendar = FSCalendar(frame: bounds)
    calendar.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    calendar.calendarHeaderView.collectionView.delegate = self
    addSubview(calendar)
    return calendar
  }()
  
  
  public lazy var jumper: MonthYearJumper = {
    let jumper = MonthYearJumper(frame: bounds)
    jumper.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    jumper.isHidden = true
    jumper.jumperDelegate = self
    addSubview(jumper)
    jumper.backgroundColor = calendar.backgroundColor
    jumper.textColor = calendar.appearance.titleDefaultColor
    return jumper
  }()
}

extension Panchaang: UICollectionViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    calendar.calendarHeaderView.scrollDidScroll(scrollView)
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? FSCalendarHeaderCell,
          let rawDate = cell.titleLabel.text,
          let date = Panchaang.dateFormatter.date(from: rawDate)
    else { return }
    
    if Calendar.current.isDate(date, equalTo: calendar.currentPage, toGranularity: .month) {
      calendar.isHidden = true
      jumper.isHidden = false
      jumper.reloadData()
    } else {
      calendar.setCurrentPage(date, animated: true)
    }
  }
}

extension Panchaang: MonthYearJumperDelegate {
  func jump(to date: Date) {
    jumper.isHidden = true
    calendar.isHidden = false
    calendar.setCurrentPage(date, animated: true)
  }
}
