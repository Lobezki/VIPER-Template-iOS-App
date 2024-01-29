//
//  UIDevice+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UIDevice {
  public static let IS_IPAD = current.userInterfaceIdiom == .pad
  public static let IS_IPHONE = current.userInterfaceIdiom == .phone
  public static let IS_RETINA = UIScreen.main.scale == 2.0
  public static let IS_SUPER_RETINA = UIScreen.main.scale == 3.0
  public static let IS_IPHONE_4_OR_LESS = IS_IPHONE && UIScreen.SCREEN_MAX_LENGTH < 568
  public static let IS_IPHONE_5 = IS_IPHONE && UIScreen.SCREEN_MAX_LENGTH == 568
  public static let IS_IPHONE_8 = IS_IPHONE && UIScreen.SCREEN_MAX_LENGTH == 667
  public static let IS_IPHONE_8P = IS_IPHONE && UIScreen.SCREEN_MAX_LENGTH == 736
  public static let IS_IPHONE_X = IS_IPHONE && UIScreen.SCREEN_MAX_LENGTH == 812
  public static let IS_IPHONE_XsMax = IS_IPHONE && UIScreen.SCREEN_MAX_LENGTH == 896
  public static var HAS_TOP_SAFE_AREA: Bool {
    guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
    if UIDevice.current.orientation.isPortrait {
        return window.safeAreaInsets.top >= 44
    } else {
        return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
    }
  }
  
  public static var HAS_BOTTOM_SAFE_AREA: Bool {
    guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
    return window.safeAreaInsets.bottom >= 34
  }
}
