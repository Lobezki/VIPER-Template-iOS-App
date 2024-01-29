//
//  DateManager.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

class DateManager {
  enum Format {
    case designated
    case iso8601
    case deviceFormat
    case ekg
    case report
    case server
    case custom(String)
    
    var rawValue: String {
      switch self {
      case .designated:
        return "MM-dd-yyyy"
      case .iso8601:
        return "yyyy-MM-dd"
      case .deviceFormat:
        return "yyyy M d H m s"
      case .ekg:
        return "yyyy-MM-dd'T'HH:mm:ss"
      case .report:
        return "MMM dd, hh:mm:ss a"
      case .server:
        return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      case .custom(let format):
        return format
      }
    }
  }
  
  static var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    return dateFormatter
  }()
  
  static func stringFromRange(_ fromDate: Date, toDate: Date) -> String {
    dateFormatter.dateFormat = "MMMM d"
    let start = dateFormatter.string(from: fromDate)
    dateFormatter.dateFormat = "d, yyyy"
    let finish = dateFormatter.string(from: toDate)
    return [start, finish].joined(separator: " - ")
  }
  
  static func stringFromDate(_ date: Date, using format: Format) -> String {
    dateFormatter.dateFormat = format.rawValue
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = .current
    return dateFormatter.string(from: date)
  }
  
  static func dateFromString(_ string: String, using format: Format) -> Date {
    dateFormatter.dateFormat = format.rawValue
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    return dateFormatter.date(from: string) ?? Date()
  }
  
  static func dateFromString(_ string: String, in timeZone: TimeZone, using format: Format) -> Date {
    dateFormatter.dateFormat = format.rawValue
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = timeZone
    return dateFormatter.date(from: string) ?? Date()
  }
  
  static func unixEpochTimeFromDate(_ date: Date) -> Int {
    return date.timeIntervalSince1970.intValue
  }
  
  static func dateFromUnixEpochTime(_ seconds: Int) -> Date {
    let timeInterval = TimeInterval(seconds)
    return Date(timeIntervalSince1970: timeInterval)
  }
}
