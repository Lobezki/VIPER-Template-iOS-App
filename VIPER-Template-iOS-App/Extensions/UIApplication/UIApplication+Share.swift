//
//  UIApplication+Share.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UIApplication {
  
  class var topViewController: UIViewController? {
    var keyWindow: UIWindow?
    
    if #available(iOS 13.0, *) {
      if #available(iOS 15.0, *) {
        keyWindow = UIApplication.shared.currentUIWindow()
      } else {
        keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
      }
    } else {
      keyWindow = UIApplication.shared.keyWindow
    }
        
    return getTopViewController(base: keyWindow?.rootViewController)
  }
  
  class func topViewController(controller: UIViewController?/* = UIApplication.shared.keyWindow?.rootViewController*/) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
  
  private class func getTopViewController(base: UIViewController?/* = UIApplication.shared.keyWindow?.rootViewController*/) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return getTopViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return getTopViewController(base: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return getTopViewController(base: presented)
    }
    return base
  }
  
  class func appVersion() -> String {
    return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
  }

  class func appBuild() -> String {
    return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
  }

  class func versionBuild() -> String {
    let version = appVersion(), build = appBuild()
    return version == build ? "v\(version)" : "v\(version)(\(build))"
  }

  @available(iOS 15.0, *)
  func currentUIWindow() -> UIWindow? {
    let connectedScenes = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
    
    let window = connectedScenes.first?
        .windows
        .first { $0.isKeyWindow }

    return window
  }
}

extension Equatable {
  func share() {
    let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
    UIApplication.topViewController?.present(activity, animated: true, completion: nil)
  }
}
