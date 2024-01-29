//
//  Calendar+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

extension Calendar {
  static func week(from date: Date) -> [Date] {
    var days = [Date]()
    
    var startDate = date
    var interval = TimeInterval()
    var calendar = Calendar.current
    calendar.firstWeekday = 1
    _ = calendar.dateInterval(of: .weekOfMonth, start: &startDate, interval: &interval, for: date)
    for index in 0..<7  {
      if let date = calendar.date(byAdding: .day, value: index, to: startDate) {
        days.append(date)
      }
    }
    
    return days
  }
  
  static func day(from date: Date) -> (hours: Int?, minutes: Int?, seconds: Int?) {
    let diffComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(), to: date)
    let hours = diffComponents.hour
    let minutes = diffComponents.minute
    let seconds = diffComponents.second
    
    return (hours: hours, minutes: minutes, seconds: seconds)
  }
  
  static func day(from fromDate: Date, to toDate: Date) -> (months: Int?, days: Int?, hours: Int?, minutes: Int?, seconds: Int?) {
    let diffComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: fromDate, to: toDate)
  
    let months = diffComponents.month
    let days = diffComponents.day
    let hours = diffComponents.hour
    let minutes = diffComponents.minute
    let seconds = diffComponents.second
    
    return (months: months, days: days, hours: hours, minutes: minutes, seconds: seconds)
  }

}
