//
//  UIControl+Closure.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

typealias VoidClosure = () -> Void
typealias EventHandler<T> = ((T) -> Void)

private class ClosureSleeve {
  let closure: VoidClosure?
  
  init (_ closure: VoidClosure?) {
    self.closure = closure
  }
  
  @objc func invoke () {
    closure?()
  }
}

extension UIControl {
  @objc func addAction(for controlEvent: UIControl.Event, action: VoidClosure?) {
    let sleeve = ClosureSleeve(action)
    addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvent)
    objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
  }
  
  func addAction(for controlEvents: UIControl.Event..., action: VoidClosure?) {
    let sleeve = ClosureSleeve(action)
    controlEvents.forEach { controlEvent in
      addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvent)
    }
    
    objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
  }
}
