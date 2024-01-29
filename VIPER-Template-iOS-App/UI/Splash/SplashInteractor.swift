//
//  SplashInteractor.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

//MARK: - Declaration of functions presenter to deal with
protocol SplashPresenterToInteractor {
  func checkIfAlreadyLogged()
}

//MARK: - Declaration of basics
final class SplashInteractor {
  var presenter: SplashInteractorToPresenter?
  var networkManager = NetworkingManager.shared
}

//MARK: - Realization of functionality
extension SplashInteractor: SplashPresenterToInteractor {
  func checkIfAlreadyLogged() {
    presenter?.onInteractorSuccess()
  }
}
