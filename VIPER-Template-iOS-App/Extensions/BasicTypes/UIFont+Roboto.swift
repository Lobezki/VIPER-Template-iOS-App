//
//  UIFont+Roboto.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

public extension UIFont {
  class func robotoFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
    let fontName = ["Roboto", weight.stringValue].joined(separator: "-")
    return UIFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .regular)
  }
}

extension UIFont.Weight {
  static let blackItalic: UIFont.Weight = .init(-1)
  static let boldItalic: UIFont.Weight = .init(-2)
  static let italic: UIFont.Weight = .init(-3)
  static let lightItalic: UIFont.Weight = .init(-4)
  static let mediumItalic: UIFont.Weight = .init(-5)
  static let thinItalic: UIFont.Weight = .init(-6)
  
  var stringValue: String {
    let italic = "Italic"
    switch self {
    case .black, .blackItalic:
      let black = "Black"
      return self == .black ? black : [black, italic].joined()
    case .bold, .boldItalic:
      let bold = "Bold"
      return self == .bold ? bold : [bold, italic].joined()
    case .italic:
      return italic
    case .medium, .mediumItalic:
      let medium = "Medium"
    return self == .medium ? medium : [medium, italic].joined()
    case .light, .lightItalic:
      let light = "Light"
      return self == .light ? light : [light, italic].joined()
    case .thin, .thinItalic:
      let thin = "Thin"
      return self == .thin ? thin : [thin, italic].joined()
    case .regular:
      return "Regular"
    default: return "Unknown"
    }
  }
}
