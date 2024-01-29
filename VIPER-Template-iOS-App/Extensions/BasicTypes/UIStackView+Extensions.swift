//
//  UIStackView+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UIStackView {
  func removeAllArrangedSubviews() {
    let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
      self.removeArrangedSubview(subview)
      return allSubviews + [subview]
    }

    for v in removedSubviews {
      if v.superview != nil {
        NSLayoutConstraint.deactivate(v.constraints)
        v.removeFromSuperview()
      }
    }
  }
}
