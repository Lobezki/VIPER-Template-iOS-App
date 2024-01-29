//
//  UIScreen+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UIScreen {
  public static let SCREEN_WIDTH          = Int(UIScreen.main.bounds.size.width)
  public static let SCREEN_HEIGHT         = Int(UIScreen.main.bounds.size.height)
  public static let SCREEN_MAX_LENGTH     = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
  public static let SCREEN_MIN_LENGTH     = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
}
