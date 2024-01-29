//
//  UIView+Shake.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UIView {
  func shake(duration: CFTimeInterval, delta: Double = 10, shouldVibrate: Bool = true) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    
    let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
    translation.timingFunction = CAMediaTimingFunction(name: .default)
    
    var values = [Double]()
    var lastValue = delta
    while lastValue > 0 {
      if lastValue < 1 {
        lastValue = 0
        values.append(lastValue)
      } else {
        values.append(contentsOf: [-lastValue, lastValue])
        lastValue = lastValue / 2
      }
    }
    
    translation.values = values
    let shakeGroup: CAAnimationGroup = CAAnimationGroup()
    shakeGroup.animations = [translation]
    shakeGroup.duration = duration
    self.layer.add(shakeGroup, forKey: "shakeIt")
    guard shouldVibrate else { return }
    generator.notificationOccurred(.error)
  }
}
