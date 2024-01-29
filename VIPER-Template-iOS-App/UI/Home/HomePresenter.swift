//
//  HomePresenter.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

//MARK: - Translation of view events into presenter
protocol HomeViewToPresenter {
  func onViewLoaded()
  func onViewEvent(_ event: HomeViewEvent)
}

//MARK: - Translation of interactor events into presenter
protocol HomeInteractorToPresenter {
  func onInteractorError(_ error: Error)
  func onInteractorSuccess()
}

//MARK: - Additional inputs into view
protocol HomeInputs {
  
}

//MARK: - Basic realization of presenter
final class HomePresenter: HomeInputs {
  weak var view: HomePresenterToView?
  var interactor: HomePresenterToInteractor?
  var router: HomeRouter.Routes?
  
  //Module inputs
}

//MARK: - Operations with view
extension HomePresenter: HomeViewToPresenter {
  //MARK: Any additional setups e.g. launching network requests
  func onViewLoaded() {
    view?.setupInitialState()
  }
  
  //MARK: - Oparations with view events
  func onViewEvent(_ event: HomeViewEvent) {

  }
}

//MARK: - Operations with interactor
extension HomePresenter: HomeInteractorToPresenter {
  //MARK: Error handling
  func onInteractorError(_ error: Error) {
    debugPrint(error)
  }
  
  //MARK: Operating with data
  func onInteractorSuccess() {
    
  }
}
