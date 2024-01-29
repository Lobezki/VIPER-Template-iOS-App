//
//  UITabbar+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UITabBar {
  func changeAppearance() {
    if #available(iOS 13, *) {
      let appearance = standardAppearance.copy()
      appearance.shadowImage = UIImage()
      appearance.shadowColor = .clear
      standardAppearance = appearance
    } else {
      shadowImage = UIImage()
    }
  }
}
