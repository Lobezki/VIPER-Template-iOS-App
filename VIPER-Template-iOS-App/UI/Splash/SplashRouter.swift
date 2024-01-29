//
//  SplashRouter.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

//MARK: - Declaration of functionality presenter to deal with
protocol SplashRoute {
  func toAuthentication()
  func toHome()
}

//MARK: - Realization of funtionality
extension SplashRoute where Self: BaseRouter {
  func toAuthentication() {
    appManager?.coordinate(accordingTo: .authentication)
  }
  
  func toHome() {
    appManager?.coordinate(accordingTo: .home)
  }
}

//MARK: - Presenter will know about routes through this class
final class SplashRouter: BaseRouter, SplashRouter.Routes {
  typealias Routes = SplashRoute
}

