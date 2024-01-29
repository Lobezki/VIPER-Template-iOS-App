//
//  AppManager.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation
import UIKit

final class AppManager {
  enum CoordinationStrategy {
    case authentication
    case home
    case designated(_ viewController: UIViewController?)
  }
  
  @frozen private enum HostNames: String {
    case restorePassword = "restore-password"
  }
  
  private var window: UIWindow?
  
  init(with window: UIWindow?) {
    self.window = window
  }
  
  func coordinate(accordingTo strategy: CoordinationStrategy) {
    var destinationVC: UIViewController?
    switch strategy {
    case .authentication:
      break
    case .home:
      let entity = HomeBuilder.create()
      entity.router.appManager = self
      destinationVC = entity.view.viewController
    case .designated(let viewController):
      destinationVC = viewController
    }
    
    guard let destination = destinationVC else { return }
      window?.rootViewController = UINavigationController(rootViewController: destination)
      window?.makeKeyAndVisible()
  }
}
