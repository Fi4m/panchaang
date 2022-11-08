//
//  DateFormatter+Extension.swift
//  FSCalendar
//
//  Created by Vedant.Fi4m on 08/11/22.
//

import Foundation


extension DateFormatter {
  static let month = DateFormatter(format: "MMMM")
  static let gYear = DateFormatter(granularity: .year)
  static let gMonth = DateFormatter(granularity: .month)
  
  convenience init(format: String) {
    self.init()
    self.dateFormat = format
  }
  
  convenience init(granularity: Calendar.Component) {
    self.init()
    switch granularity {
      case .year: dateFormat = "yyyy"
      case .month: dateFormat = "MMMM yyyy"
      default: fatalError()
    }
  }
}
