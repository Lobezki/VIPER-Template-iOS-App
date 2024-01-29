//
//  Numeric+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

extension Numeric {
  var separated: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale(identifier: "en_US")
    return formatter.string(for: self) ?? ""
  }
  
  var intValue: Int {
    guard let nsNumber = self as? NSNumber else { return 0 }
    return nsNumber.intValue
  }
}
