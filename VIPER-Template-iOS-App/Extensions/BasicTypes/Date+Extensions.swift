//
//  Date+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

extension Date {
  func isBetween(_ date1: Date, _ date2: Date) -> Bool {
    date1 < date2
      ? DateInterval(start: date1, end: date2).contains(self)
      : DateInterval(start: date2, end: date1).contains(self)
  }
}
