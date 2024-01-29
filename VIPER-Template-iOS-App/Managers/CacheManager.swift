//
//  CacheManager.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

class CacheManager {
  static var shared = CacheManager()
  
  private var cache = NSCache<AnyObject, AnyObject>()
  
  @discardableResult
  func cacheImage(_ image: Data?, byKey key: String) -> Data? {
    if let imageFromCache = cache.object(forKey: key as AnyObject) as? Data {
      return imageFromCache
    } else {
      cache.setObject(image as AnyObject, forKey: key as AnyObject)
      return nil
    }
  }
}
