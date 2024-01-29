//
//  SplashPresenter.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

//MARK: - Translation of view events into presenter
protocol SplashViewToPresenter {
  func onViewLoaded()
  func onViewAppeared()
  func onViewEvent(_ event: SplashViewEvent)
}

//MARK: - Translation of interactor events into presenter
protocol SplashInteractorToPresenter {
  func onInteractorError()
  func onInteractorSuccess()
}

//MARK: - Additional inputs into view
protocol SplashInputs {
  
}

//MARK: - Basic realization of presenter
final class SplashPresenter: SplashInputs {
  weak var view: SplashPresenterToView?
  var interactor: SplashPresenterToInteractor?
  var router: SplashRouter.Routes?
  
  //Module inputs
}

//MARK: - Operations with view
extension SplashPresenter: SplashViewToPresenter {
  //MARK: Any additional setups e.g. launching network requests
  func onViewLoaded() {
    view?.setupInitialState()
  }
  
  func onViewAppeared() {
    interactor?.checkIfAlreadyLogged()
  }
  
  //MARK: - Oparations with view events
  func onViewEvent(_ event: SplashViewEvent) {

  }
}

//MARK: - Operations with interactor
extension SplashPresenter: SplashInteractorToPresenter {
  //MARK: Error handling
  func onInteractorError() {
    router?.toAuthentication()
  }
  
  //MARK: Operating with data
  func onInteractorSuccess() {
    router?.toHome()
  }
}
