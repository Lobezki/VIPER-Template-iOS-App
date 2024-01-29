//
//  UIView+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UIView {
  static var reuseId: String {
    return String(describing: self)
  }
  
  var asImage: UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
  
  var asImageA4: UIImage {
    let boundsWidth = bounds.width
    let boundsHeight = boundsWidth * 1.41
    
    let renderer = UIGraphicsImageRenderer(bounds: CGRect(x: 0.0, y: 0.0, width: boundsWidth, height: boundsHeight))
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
}
