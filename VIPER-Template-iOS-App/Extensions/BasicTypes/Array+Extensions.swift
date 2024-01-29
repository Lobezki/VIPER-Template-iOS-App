//
//  Array+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

protocol Dated {
  var date: Date { get }
}

protocol DatedArray {
  var date: [Date] { get }
}

extension Array where Element: Dated {
  func grouped(by dateComponents: Set<Calendar.Component>) -> [Date: [Element]] {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
    
    let initial = [Date: [Element]]()
    let group = reduce(into: initial) { result, element in
      let components = calendar.dateComponents(dateComponents, from: element.date)
      if let date = calendar.date(from: components) {
        let exisiting = result[date] ?? []
        result[date] = exisiting + [element]
      }
    }
    
    return group
  }
}

extension Array where Element: DatedArray {
  func grouped(by dateComponents: Set<Calendar.Component>) -> [Date: [Element]] {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
    
    let initial = [Date: [Element]]()
    let group = reduce(into: initial) { result, element in
      let components = calendar.dateComponents(dateComponents, from: element.date.last ?? Date())
      if let date = calendar.date(from: components) {
        let exisiting = result[date] ?? []
        result[date] = exisiting + [element]
      }
    }
    
    return group
  }
}

extension Array {
   /**
    * ## Examples:
    * var arr = [0,1,2,3]
    * arr.remove((0..<2)) // 0,1
    * arr // 2,3
    */
   mutating func remove(_ range: Range<Int>) -> Array {
      let values = Array(self[range])
      self.removeSubrange(range)
      return values
   }
}

//extension NameOfStruct: Dated { } / TODO: Example
