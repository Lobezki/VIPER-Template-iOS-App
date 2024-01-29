//
//  Double+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

extension Double {
  public func rounded(decimalPoint: Int) -> Double {
    let power = pow(10, Double(decimalPoint))
    return (self * power).rounded() / power
  }
}
