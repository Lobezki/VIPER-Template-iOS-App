//
//  UINavigationBar+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UINavigationBar {
  enum Style {
    case `default`(UIColor?)
    case colored(UIColor?)
  }
  
  func changeAppearance(using style: Style) {
    let appearance = type(of: self).appearance()
    appearance.isTranslucent = true
    appearance.shadowImage = UIImage()
    appearance.setBackgroundImage(UIImage(), for: .default)
    appearance.backItem?.title = " "
    appearance.topItem?.backBarButtonItem?.title = " "
    
    var desiredColor: UIColor? = UIColor.clear
    var tintColor = UIColor.slate
    
    switch style {
    case .colored(let color):
      desiredColor = color
      tintColor = .white
    case .default(let color):
      guard let color = color else { break }
      tintColor = color
    }
    
    appearance.backgroundColor = desiredColor
    appearance.barTintColor = desiredColor
    appearance.tintColor = tintColor
    appearance.titleTextAttributes = [.foregroundColor: tintColor]
  }
}
