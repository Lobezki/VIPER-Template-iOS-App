//
//  Int+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

extension Int {
  mutating func map(fromLow: Int, fromHigh: Int, toLow: Int, toHigh: Int) -> Int {
    var newValue = 0
    
    let oldRange = fromHigh-fromLow
    
    if oldRange == 0 {
        newValue = toLow
    } else {
      let newRange = toHigh - toLow
      newValue = (((self - fromLow) * newRange) / oldRange) + toLow
    }
    
    return newValue
  }
}
