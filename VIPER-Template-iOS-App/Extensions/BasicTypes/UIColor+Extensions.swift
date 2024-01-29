//
//  UIColor+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UIColor {
  var hexString: String {
    let components = self.cgColor.components

    let red = Float(components![0])
    let green = Float(components![1])
    let blue = Float(components![2])
    return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
  }
  
  class final var coral: UIColor {
      return UIColor(red: 245, green: 71, blue: 71)
  }
  
  class final var grapefruit: UIColor {
      return UIColor(red: 255, green: 92, blue: 92)
  }
  
  class final var cloudyBlue: UIColor {
      return UIColor(red: 182, green: 205, blue: 209)
  }
  
  class final var brownGray: UIColor {
      return UIColor(red: 151, green: 151, blue: 151)
  }
  
  class final var slate: UIColor {
      return UIColor(red: 78, green: 96, blue: 112)
  }
  
  class final var lightGreyBlue: UIColor {
      return UIColor(red: 144, green: 209, blue: 224)
  }
  
  class final var mango: UIColor {
      return UIColor(red: 252, green: 154, blue: 45)
  }
  
  class final var shamrockGreen: UIColor {
      return UIColor(red: 0, green: 199, blue: 104)
  }
  
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }

  convenience init(hexString: String) {
    var rgbValue32: UInt32 = 0
    var rgbValue64: UInt64 = 0

    let scanner = Scanner(string: hexString)

    if #available(iOS 13.0, *) {
      scanner.currentIndex = hexString.index(after: hexString.startIndex)
      scanner.scanHexInt64(&rgbValue64)
      self.init(red: CGFloat((rgbValue64 & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue64 & 0xFF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue64 & 0xFF) / 255.0,
                alpha: 1)
    } else {
      scanner.scanLocation = 1
      scanner.scanHexInt32(&rgbValue32)
      self.init(red: CGFloat((rgbValue32 & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue32 & 0xFF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue32 & 0xFF) / 255.0,
                alpha: 1)
    }
  }
}
