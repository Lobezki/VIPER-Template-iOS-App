//
//  UIImageView+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UIImageView {
  func downloaded(fromURL url: String) {
    if let cachedImageData = CacheManager.shared.cacheImage(nil, byKey: url) {
      self.image = UIImage(data: cachedImageData)
    } else {
      NetworkingManager.shared.downloadImage(forURL: url) { [unowned self] result in
        switch result {
        case .success(let imageData):
          self.image = UIImage(data: imageData)
        case .error(let error):
          debugPrint(error)
        }
      }
    }
  }
}
